tableextension 50115 "Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50100; "List Price"; Decimal)
        {
            Caption = 'List Price';
            DataClassification = ToBeClassified;
        }
        field(50101; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;

        }
        field(50102; Currency; Code[20])
        {
            Caption = 'Currency';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50103; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
        }
        field(50104; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(50105; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(50106; "Your Reference"; Text[250])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }

        field(50107; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(50108; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(50109; "Shipment No."; Code[20])
        {
            Caption = 'Shipment No.';
            Editable = false;
        }

        field(50110; "Prepmt. Amt. Inv."; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FieldNo("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Editable = false;
        }

        field(50111; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                TransferLine: Record "Transfer Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
                VatFactor: Decimal;
                LineInvDiscAmt: Decimal;
                InvDiscRounding: Decimal;
            begin
                TestStatusOpen();

                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    TransferLine.SetRange("Document Type", "Document Type");
                    TransferLine.SetRange("Document No.", "No.");
                    TransferLine.SetFilter("Job Contract Entry No.", '<>%1', 0);
                    if TransferLine.Find('-') then begin
                        TransferLine.TestField("Job No.", '');
                        TransferLine.TestField("Job Contract Entry No.", 0);
                    end;

                    TransferLine.Reset();
                    TransferLine.SetRange("Document Type", "Document Type");
                    TransferLine.SetRange("Document No.", "No.");
                    TransferLine.SetFilter("Unit Price", '<>%1', 0);
                    TransferLine.SetFilter("VAT %", '<>%1', 0);
                    OnValidatePricesIncludingVATOnBeforeTransferLineFindFirst(TransferLine);
                    if TransferLine.FindFirst() then begin
                        RecalculatePrice := ConfirmRecalculatePrice(TransferLine);
                        OnAfterConfirmSalesPrice(Rec, TransferLine, RecalculatePrice);
                        TransferLine.SetTransferHeader(Rec);

                        InitializeRoundingPrecision(Currency);

                        TransferLine.LockTable();
                        LockTable();
                        TransferLine.FindSet();
                        repeat
                            TransferLine.TestField("Quantity Invoiced", 0);
                            TransferLine.TestField("Prepmt. Amt. Inv.", 0);
                            if not RecalculatePrice then begin
                                TransferLine."VAT Difference" := 0;
                                TransferLine.UpdateAmounts();
                            end else begin
                                VatFactor := 1 + TransferLine."VAT %" / 100;
                                if VatFactor = 0 then
                                    VatFactor := 1;
                                if not "Prices Including VAT" then
                                    VatFactor := 1 / VatFactor;
                                if TransferLine."VAT Calculation Type" = TransferLine."VAT Calculation Type"::"Full VAT" then
                                    VatFactor := 1;
                                TransferLine."Unit Price" :=
                                  Round(TransferLine."Unit Price" * VatFactor, Currency."Unit-Amount Rounding Precision");
                                TransferLine."Line Discount Amount" :=
                                  Round(
                                    TransferLine.Quantity * TransferLine."Unit Price" * TransferLine."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                                LineInvDiscAmt := InvDiscRounding + TransferLine."Inv. Discount Amount" * VatFactor;
                                TransferLine."Inv. Discount Amount" := Round(LineInvDiscAmt, Currency."Amount Rounding Precision");
                                InvDiscRounding := LineInvDiscAmt - TransferLine."Inv. Discount Amount";
                                if TransferLine."VAT Calculation Type" = TransferLine."VAT Calculation Type"::"Full VAT" then
                                    TransferLine."Line Amount" := TransferLine."Amount Including VAT"
                                else
                                    if "Prices Including VAT" then
                                        TransferLine."Line Amount" := TransferLine."Amount Including VAT" + TransferLine."Inv. Discount Amount"
                                    else
                                        TransferLine."Line Amount" := TransferLine.Amount + TransferLine."Inv. Discount Amount";
                                UpdatePrepmtAmounts(TransferLine);
                            end;
                            OnValidatePricesIncludingVATOnBeforeTransferLineModify(Rec, TransferLine, Currency, RecalculatePrice);
                            TransferLine.Modify();
                        until TransferLine.Next() = 0;
                    end;
                    OnAfterChangePricesIncludingVAT(Rec);
                end;
            end;
        }

        field(50112; "No."; Code[20])
        {
            CaptionClass = GetCaptionClass(FieldNo("No."));
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true), "Account Type" = const(Posting), Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("Allocation Account")) "Allocation Account"
            else
            if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item where(Blocked = const(false), "Sales Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = filter("Credit Memo" | "Return Order")) Item where(Blocked = const(false));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                TempTransferLine: Record "Transfer Line" temporary;
                IsHandled: Boolean;
                ShouldStopValidation: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateNo(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                GetSalesSetup();

                "No." := FindOrCreateRecordByNo("No.");

                TestJobPlanningLine();
                TestStatusOpen();
                CheckItemAvailable(FieldNo("No."));

                if (xRec."No." <> "No.") and (Quantity <> 0) then begin
                    TestField("Qty. to Asm. to Order (Base)", 0);
                    CalcFields("Reserved Qty. (Base)");
                    TestField("Reserved Qty. (Base)", 0);
                    if Type = Type::Item then
                        SalesWarehouseMgt.TransferLineVerifyChange(Rec, xRec);
                    OnValidateNoOnAfterVerifyChange(Rec, xRec);
                    if CurrFieldNo = Rec.FieldNo("No.") then
                        CheckWarehouse(false);
                end;

                TestField("Qty. Shipped Not Invoiced", 0);
                TestField("Quantity Shipped", 0);
                TestField("Shipment No.", '');

                TestField("Prepmt. Amt. Inv.", 0);

                TestField("Return Qty. Rcd. Not Invd.", 0);
                TestField("Return Qty. Received", 0);
                TestField("Return Receipt No.", '');

                if "No." = '' then
                    ATOLink.DeleteAsmFromTransferLine(Rec);
                CheckAssocPurchOrder(FieldCaption("No."));
                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                OnValidateNoOnBeforeInitRec(Rec, xRec, CurrFieldNo);
                TempTransferLine := Rec;
                Init();
                SystemId := TempTransferLine.SystemId;
                if xRec."Line Amount" <> 0 then
                    "Recalculate Invoice Disc." := xRec."Allow Invoice Disc.";
                Type := TempTransferLine.Type;
                "No." := TempTransferLine."No.";
                OnValidateNoOnCopyFromTempTransferLine(Rec, TempTransferLine, xRec, CurrFieldNo);
                ShouldStopValidation := "No." = '';
                OnValidateNoOnAfterCalcShouldStopValidation(Rec, xRec, CurrFieldNo, ShouldStopValidation);
                if ShouldStopValidation then
                    exit;

                if HasTypeToFillMandatoryFields() then begin
                    Quantity := TempTransferLine.Quantity;
                    "Outstanding Qty. (Base)" := TempTransferLine."Outstanding Qty. (Base)";
                end;

                "System-Created Entry" := TempTransferLine."System-Created Entry";
                GetTransferHeader();
                OnValidateNoOnBeforeInitHeaderDefaults(TransferHeader, Rec, TempTransferLine);
                InitHeaderDefaults(TransferHeader);
                OnValidateNoOnAfterInitHeaderDefaults(TransferHeader, TempTransferLine, Rec);

                CalcFields("Substitution Available");

                "Promised Delivery Date" := TransferHeader."Promised Delivery Date";
                "Requested Delivery Date" := TransferHeader."Requested Delivery Date";

                IsHandled := false;
                OnValidateNoOnBeforeCalcShipmentDateForLocation(IsHandled, Rec);
                if not IsHandled then
                    CalcShipmentDateForLocation();

                IsHandled := false;
                OnValidateNoOnBeforeUpdateDates(Rec, xRec, TransferHeader, CurrFieldNo, IsHandled, TempTransferLine);
                if not IsHandled then
                    UpdateDates();

                OnAfterAssignHeaderValues(Rec, TransferHeader);

                case Type of
                    Type::" ":
                        CopyFromStandardText();
                    Type::"G/L Account":
                        CopyFromGLAccount(TempTransferLine);
                    Type::Item:
                        CopyFromItem();
                    Type::Resource:
                        CopyFromResource();
                    Type::"Fixed Asset":
                        CopyFromFixedAsset();
                    Type::"Charge (Item)":
                        CopyFromItemCharge();
                end;

                OnAfterAssignFieldsForNo(Rec, xRec, TransferHeader);

                IsHandled := false;
                OnValidateNoOnBeforeCheckPostingSetups(Rec, IsHandled);
                if not IsHandled then
                    if Type <> Type::" " then
                        if not IsTemporary() then begin
                            PostingSetupMgt.CheckGenPostingSetupSalesAccount("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                            PostingSetupMgt.CheckGenPostingSetupCOGSAccount("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                            PostingSetupMgt.CheckVATPostingSetupSalesAccount("VAT Bus. Posting Group", "VAT Prod. Posting Group");
                        end;

                if HasTypeToFillMandatoryFields() and (Type <> Type::"Fixed Asset") then
                    ValidateVATProdPostingGroup();

                UpdatePrepmtSetupFields();

                if HasTypeToFillMandatoryFields() then begin
                    PlanPriceCalcByField(FieldNo("No."));
                    ValidateUnitOfMeasureCodeFromNo();
                    if Quantity <> 0 then begin
                        OnValidateNoOnBeforeInitOutstanding(Rec, xRec);
                        InitOutstanding();
                        if IsCreditDocType() then
                            InitQtyToReceive()
                        else
                            InitQtyToShip();
                        InitQtyToAsm();
                        UpdateWithWarehouseShip();
                    end;
                end;

                IsHandled := false;
                OnValidateNoOnBeforeCreateDimFromDefaultDim(Rec, IsHandled, TempTransferLine);
                if not IsHandled then
                    CreateDimFromDefaultDim(Rec.FieldNo("No."));

                OnValidateNoOnAfterCreateDimFromDefaultDim(Rec, xRec, TransferHeader, CurrFieldNo);

                if "No." <> xRec."No." then begin
                    if Type = Type::Item then begin
                        if (Quantity <> 0) and ItemExists(xRec."No.") then begin
                            VerifyChangeForTransferLineReserve(FieldNo("No."));
                            SalesWarehouseMgt.TransferLineVerifyChange(Rec, xRec);
                        end;
                        CheckItemCanBeAddedToTransferLine();
                    end;

                    GetDefaultBin();
                    Rec.AutoAsmToOrder();
                    DeleteItemChargeAssignment("Document Type", "Document No.", "Line No.");
                    if Type = Type::"Charge (Item)" then
                        DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                end;

                UpdateItemReference();

                UpdateUnitPriceByField(FieldNo("No."));

                OnValidateNoOnAfterUpdateUnitPrice(Rec, xRec, TempTransferLine);
            end;
        }
        field(50113; "Return Qty. Received"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Qty. Received';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50114; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
            Editable = false;
        }

        field(50115; "Purch. Order Line No."; Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = if ("Drop Shipment" = const(true)) "Purchase Line"."Line No." where("Document Type" = const(Order),
                                                                                               "Document No." = field("Purchase Order No."));

            trigger OnValidate()
            begin
                if (xRec."Purch. Order Line No." <> "Purch. Order Line No.") and (Quantity <> 0) then begin
                    VerifyChangeForTransferLineReserve(FieldNo("Purch. Order Line No."));
                    SalesWarehouseMgt.TransferLineVerifyChange(Rec, xRec);
                end;
            end;
        }

        field(50116; "Drop Shipment"; Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer" = R;
            Caption = 'Drop Shipment';
            Editable = true;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateDropShipment(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                TestField("Document Type", "Document Type"::Order);
                TestField(Type, Type::Item);
                TestField("Quantity Shipped", 0);

                IsHandled := false;
                OnValidateDropShipmentOnBeforeTestJobNo(Rec, IsHandled, CurrFieldNo);
                if not IsHandled then
                    TestField("Job No.", '');
                TestField("Qty. to Asm. to Order (Base)", 0);

                if "Drop Shipment" then
                    TestField("Special Order", false);

                CheckAssocPurchOrder(FieldCaption("Drop Shipment"));

                if "Special Order" then
                    Reserve := Reserve::Never
                else
                    if "Drop Shipment" then begin
                        Reserve := Reserve::Never;
                        Evaluate("Outbound Whse. Handling Time", '<0D>');
                        Evaluate("Shipping Time", '<0D>');
                        UpdateDates();
                        "Bin Code" := '';
                    end else
                        SetReserveWithoutPurchasingCode();

                CheckItemAvailable(FieldNo("Drop Shipment"));

                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                if (xRec."Drop Shipment" <> "Drop Shipment") and (Quantity <> 0) then begin
                    if not "Drop Shipment" then begin
                        InitQtyToAsm();
                        Rec.AutoAsmToOrder();
                        UpdateWithWarehouseShip();
                    end else
                        InitQtyToShip();
                    SalesWarehouseMgt.TransferLineVerifyChange(Rec, xRec);
                    if not FullReservedQtyIsForAsmToOrder() then
                        VerifyChangeForTransferLineReserve(FieldNo("Drop Shipment"));
                end;
            end;
        }
        field(50117; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(50118; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';

            trigger OnValidate()
            var
                TempSalesLine: Record "Sales Line" temporary;
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateType(Rec, xRec, CurrFieldNo, IsHandled);
                if IsHandled then
                    exit;

                TestJobPlanningLine();
                TestStatusOpen();
                GetSalesHeader();

                TestField("Qty. Shipped Not Invoiced", 0);
                TestField("Quantity Shipped", 0);
                TestField("Shipment No.", '');

                TestField("Return Qty. Rcd. Not Invd.", 0);
                TestField("Return Qty. Received", 0);
                TestField("Return Receipt No.", '');

                TestField("Prepmt. Amt. Inv.", 0);

                CheckAssocPurchOrder(FieldCaption(Type));

                if Type <> xRec.Type then begin
                    case xRec.Type of
                        Type::Item:
                            begin
                                ATOLink.DeleteAsmFromSalesLine(Rec);
                                if Quantity <> 0 then begin
                                    SalesHeader.TestField(Status, SalesHeader.Status::Open);
                                    CalcFields("Reserved Qty. (Base)");
                                    TestField("Reserved Qty. (Base)", 0);
                                    VerifyChangeForSalesLineReserve(FieldNo(Type));
                                    SalesWarehouseMgt.SalesLineVerifyChange(Rec, xRec);
                                    OnValidateTypeOnAfterCheckItem(Rec, xRec);
                                end;
                            end;
                        Type::"Fixed Asset":
                            if Quantity <> 0 then
                                SalesHeader.TestField(Status, SalesHeader.Status::Open);
                        Type::"Charge (Item)":
                            DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                    end;
                    if xRec."Deferral Code" <> '' then
                        DeferralUtilities.RemoveOrSetDeferralSchedule('',
                          Enum::"Deferral Document Type"::Sales.AsInteger(), '', '',
                          xRec."Document Type".AsInteger(), xRec."Document No.", xRec."Line No.",
                          xRec.GetDeferralAmount(), xRec."Posting Date", '', xRec."Currency Code", true);

                    OnValidateTypeOnAfterVerifyChange(Rec, xRec);
                end;
                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                OnValidateTypeOnBeforeInitRec(Rec, xRec, CurrFieldNo);
                TempSalesLine := Rec;
                Init();
                SystemId := TempSalesLine.SystemId;
                if xRec."Line Amount" <> 0 then
                    "Recalculate Invoice Disc." := xRec."Allow Invoice Disc.";

                Type := TempSalesLine.Type;
                "System-Created Entry" := TempSalesLine."System-Created Entry";
                "Currency Code" := SalesHeader."Currency Code";

                OnValidateTypeOnCopyFromTempSalesLine(Rec, TempSalesLine);

                if Type = Type::Item then
                    "Allow Item Charge Assignment" := true
                else
                    "Allow Item Charge Assignment" := false;
            end;
        }
    }
    procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        TransferLineCaptionClassMgmt: Codeunit "Event Procedure";
    // TransferLineCaptionClassMgmt: Codeunit "Transfer Line CaptionClass Mgmt";
    begin
        exit(TransferLineCaptionClassMgmt.GetTransferLineCaptionClass(Rec, FieldNumber));
    end;

    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping; var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var VATAmountLine: Record "VAT Amount Line") LineWasModified: Boolean
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
        LineAmountToInvoiceDiscounted: Decimal;
        DeferralAmount: Decimal;
    begin
        if IsUpdateVATOnLinesHandled(SalesHeader, SalesLine, VATAmountLine, QtyType, LineWasModified) then
            exit(LineWasModified);

        LineWasModified := false;
        if QtyType = QtyType::Shipping then
            exit;

        Currency.Initialize(SalesHeader."Currency Code");
        OnUpdateVATOnLinesOnAfterCurrencyInitialize(Rec, SalesHeader, Currency);

        TempVATAmountLineRemainder.DeleteAll();

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SetLoadFieldsForInvDiscoundCalculation(SalesLine);
        OnUpdateVATOnLinesOnAfterSalesLineSetFilter(SalesLine);
        SalesLine.LockTable();
        if SalesLine.FindSet() then
            repeat
                if not SalesLine.ZeroAmountLine(QtyType) then begin
                    DeferralAmount := SalesLine.GetDeferralAmount();
                    VATAmountLine.Get(SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0);
                    if VATAmountLine.Modified then begin
                        if not TempVATAmountLineRemainder.Get(
                             SalesLine."VAT Identifier", SalesLine."VAT Calculation Type", SalesLine."Tax Group Code", false, SalesLine."Line Amount" >= 0)
                        then begin
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.Init();
                            TempVATAmountLineRemainder.Insert();
                        end;

                        if QtyType = QtyType::General then
                            LineAmountToInvoice := SalesLine."Line Amount"
                        else
                            LineAmountToInvoice :=
                              Round(SalesLine."Line Amount" * SalesLine."Qty. to Invoice" / SalesLine.Quantity, Currency."Amount Rounding Precision");

                        if SalesLine."Allow Invoice Disc." then begin
                            if (VATAmountLine."Inv. Disc. Base Amount" = 0) or (LineAmountToInvoice = 0) then
                                InvDiscAmount := 0
                            else begin
                                LineAmountToInvoiceDiscounted :=
                                  VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                                  VATAmountLine."Inv. Disc. Base Amount";
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                                InvDiscAmount :=
                                  Round(
                                    TempVATAmountLineRemainder."Invoice Discount Amount", Currency."Amount Rounding Precision");
                                TempVATAmountLineRemainder."Invoice Discount Amount" :=
                                  TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                            end;
                            if QtyType = QtyType::General then begin
                                SalesLine."Inv. Discount Amount" := InvDiscAmount;
                                SalesLine.CalcInvDiscToInvoice();
                            end else
                                SalesLine."Inv. Disc. Amount to Invoice" := InvDiscAmount;
                        end else
                            InvDiscAmount := 0;

                        OnUpdateVATOnLinesOnBeforeCalculateAmounts(SalesLine, SalesHeader);
                        if QtyType = QtyType::General then begin
                            if SalesHeader."Prices Including VAT" then begin
                                if (VATAmountLine.CalcLineAmount() = 0) or (SalesLine."Line Amount" = 0) then begin
                                    VATAmount := 0;
                                    NewAmountIncludingVAT := 0;
                                end else begin
                                    VATAmount :=
                                      TempVATAmountLineRemainder."VAT Amount" +
                                      VATAmountLine."VAT Amount" * SalesLine.CalcLineAmount() / VATAmountLine.CalcLineAmount();
                                    NewAmountIncludingVAT :=
                                      TempVATAmountLineRemainder."Amount Including VAT" +
                                      VATAmountLine."Amount Including VAT" * SalesLine.CalcLineAmount() / VATAmountLine.CalcLineAmount();
                                end;
                                OnUpdateVATOnLinesOnBeforeCalculateNewAmount(
                                  Rec, SalesHeader, VATAmountLine, TempVATAmountLineRemainder, NewAmountIncludingVAT, VATAmount);
                                NewAmount :=
                                  Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                                  Round(VATAmount, Currency."Amount Rounding Precision");
                                NewVATBaseAmount :=
                                  Round(
                                    NewAmount * (1 - SalesLine.GetVatBaseDiscountPct(SalesHeader) / 100), Currency."Amount Rounding Precision");
                            end else begin
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then begin
                                    VATAmount := SalesLine.CalcLineAmount();
                                    NewAmount := 0;
                                    NewVATBaseAmount := 0;
                                end else begin
                                    NewAmount := SalesLine.CalcLineAmount();
                                    NewVATBaseAmount :=
                                      Round(
                                        NewAmount * (1 - SalesLine.GetVatBaseDiscountPct(SalesHeader) / 100), Currency."Amount Rounding Precision");
                                    if VATAmountLine."VAT Base" = 0 then
                                        VATAmount := 0
                                    else
                                        VATAmount :=
                                          TempVATAmountLineRemainder."VAT Amount" +
                                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                                end;
                                OnUpdateVATOnLinesOnBeforeCalculateNewAmount(
                                  Rec, SalesHeader, VATAmountLine, TempVATAmountLineRemainder, NewAmount, VATAmount);
                                NewAmountIncludingVAT := NewAmount + Round(VATAmount, Currency."Amount Rounding Precision");
                            end;
                            OnUpdateVATOnLinesOnAfterCalculateNewAmount(
                              Rec, SalesHeader, VATAmountLine, TempVATAmountLineRemainder, NewAmountIncludingVAT, VATAmount,
                              NewAmount, NewVATBaseAmount);
                        end else begin
                            if VATAmountLine.CalcLineAmount() = 0 then
                                VATDifference := 0
                            else
                                VATDifference :=
                                  TempVATAmountLineRemainder."VAT Difference" +
                                  VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount();
                            if LineAmountToInvoice = 0 then
                                SalesLine."VAT Difference" := 0
                            else
                                SalesLine."VAT Difference" := Round(VATDifference, Currency."Amount Rounding Precision");
                        end;
                        OnUpdateVATOnLinesOnAfterCalculateAmounts(SalesLine, SalesHeader);

                        if QtyType = QtyType::General then begin
                            if not SalesLine."Prepayment Line" then
                                SalesLine.UpdatePrepmtAmounts();
                            UpdateBaseAmounts(NewAmount, Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision"), NewVATBaseAmount);
                            OnUpdateVATOnLinesOnAfterUpdateBaseAmounts(SalesHeader, SalesLine, TempVATAmountLineRemainder, VATAmountLine, Currency);
                        end;
                        SalesLine.InitOutstanding();
                        if SalesLine.Type = SalesLine.Type::"Charge (Item)" then
                            SalesLine.UpdateItemChargeAssgnt();
                        OnUpdateVATOnLinesOnBeforeModifySalesLine(SalesLine, VATAmount);
                        SalesLine.Modify();
                        LineWasModified := true;

                        if (SalesLine."Deferral Code" <> '') and (DeferralAmount <> SalesLine.GetDeferralAmount()) then
                            SalesLine.UpdateDeferralAmounts();

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - Round(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder."VAT Difference" := VATDifference - SalesLine."VAT Difference";
                        OnUpdateVATOnLinesOnBeforeTempVATAmountLineRemainderModify(Rec, TempVATAmountLineRemainder, VATAmount, NewVATBaseAmount);
                        TempVATAmountLineRemainder.Modify();
                    end;
                end;
            until SalesLine.Next() = 0;
        SalesLine.SetLoadFields();

        OnAfterUpdateVATOnLines(SalesHeader, SalesLine, VATAmountLine, QtyType);
    end;

    local procedure IsUpdateVATOnLinesHandled(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var VATAmountLine: Record "VAT Amount Line"; QtyType: Integer; var LineWasModified: Boolean) IsHandled: Boolean
    begin
        IsHandled := false;
        OnBeforeUpdateVATOnLines(SalesHeader, SalesLine, VATAmountLine, IsHandled, QtyType, LineWasModified, xRec, CurrFieldNo, PrepaymentLineAmountEntered);
        exit(IsHandled);
    end;

    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var VATAmountLine: Record "VAT Amount Line")
    begin
        CalcVATAmountLines(QtyType, TransferHeader, TransferLine, VATAmountLine, true);
    end;

    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping; var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var VATAmountLine: Record "VAT Amount Line"; IncludePrepayments: Boolean)
    var
        TotalVATAmount: Decimal;
        QtyToHandle: Decimal;
        AmtToHandle: Decimal;
        RoundingLineInserted: Boolean;
        ShouldProcessRounding: Boolean;
        IsHandled: Boolean;
    begin
        if IsCalcVATAmountLinesHandled(TransferHeader, TransferLine, VATAmountLine, QtyType, IncludePrepayments) then
            exit;

        Currency.Initialize(TransferHeader."Currency Code");
        OnCalcVATAmountLinesOnAfterCurrencyInitialize(Rec, TransferHeader, Currency);

        VATAmountLine.DeleteAll();

        TransferLine.SetRange("Document Type", TransferHeader."Document Type");
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetFilter(Type, '<>%1', TransferLine.Type::" ");
        TransferLine.SetFilter(Quantity, '<>0');
        TransferLine.SetFilter("Unit Price", '<>0');
        SetLoadFieldsForInvDiscoundCalculation(TransferLine);
        OnCalcVATAmountLinesOnAfterSetFilters(TransferLine, TransferHeader);
        if TransferLine.FindSet() then
            repeat
                if not TransferLine.ZeroAmountLine(QtyType) then begin
                    OnCalcVATAmountLinesOnBeforeProcessTransferLine(TransferLine);
                    if (TransferLine.Type = TransferLine.Type::"G/L Account") and not TransferLine."Prepayment Line" and TransferLine."System-Created Entry" and not RoundingLineInserted then
                        RoundingLineInserted := (TransferLine."No." = TransferLine.GetCPGInvRoundAcc(TransferHeader));
                    if TransferLine."VAT Calculation Type" in
                       [TransferLine."VAT Calculation Type"::"Reverse Charge VAT", TransferLine."VAT Calculation Type"::"Sales Tax"]
                    then
                        TransferLine."VAT %" := 0;
                    if not VATAmountLine.Get(
                         TransferLine."VAT Identifier", TransferLine."VAT Calculation Type", TransferLine."Tax Group Code", false, TransferLine."Line Amount" >= 0)
                    then begin
                        VATAmountLine.InsertNewLine(
                          TransferLine."VAT Identifier", TransferLine."VAT Calculation Type", TransferLine."Tax Group Code", false, TransferLine."VAT %", TransferLine."Line Amount" >= 0, false, 0);
                        OnCalcVATAmountLinesOnAfterInsertNewVATAmountLine(TransferLine, VATAmountLine);
                    end;

                    OnCalcVATAmountLinesOnBeforeQtyTypeCase(VATAmountLine, TransferLine, TransferHeader);
                    case QtyType of
                        QtyType::General:
                            begin
                                OnCalcVATAmountLinesOnBeforeQtyTypeGeneralCase(TransferHeader, TransferLine, VATAmountLine, IncludePrepayments, QtyType, QtyToHandle, AmtToHandle);
                                VATAmountLine.Quantity += TransferLine."Quantity (Base)";
                                VATAmountLine.SumLine(TransferLine."Line Amount", TransferLine."Inv. Discount Amount", TransferLine."VAT Difference", TransferLine."Allow Invoice Disc.", TransferLine."Prepayment Line");
                            end;
                        QtyType::Invoicing:
                            begin
                                IsHandled := false;
                                OnCalcVATAmountLinesOnBeforeAssignQuantities(TransferHeader, TransferLine, VATAmountLine, QtyToHandle, IsHandled);
                                if not IsHandled then
                                    case true of
                                        (TransferLine."Document Type" in [TransferLine."Document Type"::Order, TransferLine."Document Type"::Invoice]) and
                                        (not TransferHeader.Ship) and TransferHeader.Invoice and (not TransferLine."Prepayment Line"):
                                            if TransferLine."Shipment No." = '' then begin
                                                QtyToHandle := TransferLine.GetAbsMin(TransferLine."Qty. to Invoice", TransferLine."Qty. Shipped Not Invoiced");
                                                VATAmountLine.Quantity += TransferLine.GetAbsMin(TransferLine."Qty. to Invoice (Base)", TransferLine."Qty. Shipped Not Invd. (Base)");
                                            end else begin
                                                QtyToHandle := TransferLine."Qty. to Invoice";
                                                VATAmountLine.Quantity += TransferLine."Qty. to Invoice (Base)";
                                            end;
                                        TransferLine.IsCreditDocType() and (not TransferHeader.Receive) and TransferHeader.Invoice:
                                            if TransferLine."Return Receipt No." = '' then begin
                                                QtyToHandle := TransferLine.GetAbsMin(TransferLine."Qty. to Invoice", TransferLine."Return Qty. Rcd. Not Invd.");
                                                VATAmountLine.Quantity += TransferLine.GetAbsMin(TransferLine."Qty. to Invoice (Base)", TransferLine."Ret. Qty. Rcd. Not Invd.(Base)");
                                            end else begin
                                                QtyToHandle := TransferLine."Qty. to Invoice";
                                                VATAmountLine.Quantity += TransferLine."Qty. to Invoice (Base)";
                                            end;
                                        else begin
                                            QtyToHandle := TransferLine."Qty. to Invoice";
                                            VATAmountLine.Quantity += TransferLine."Qty. to Invoice (Base)";
                                        end;
                                    end;

                                OnCalcVATAmountLinesOnBeforeAssignAmtToHandle(TransferHeader, TransferLine, VATAmountLine, IncludePrepayments, QtyType, QtyToHandle, AmtToHandle);
                                if IncludePrepayments then
                                    AmtToHandle := TransferLine.GetLineAmountToHandleInclPrepmt(QtyToHandle)
                                else
                                    AmtToHandle := TransferLine.GetLineAmountToHandle(QtyToHandle);
                                if TransferHeader."Invoice Discount Calculation" <> TransferHeader."Invoice Discount Calculation"::Amount then
                                    VATAmountLine.SumLine(
                                      AmtToHandle, Round(TransferLine."Inv. Discount Amount" * QtyToHandle / TransferLine.Quantity, Currency."Amount Rounding Precision"),
                                      TransferLine."VAT Difference", TransferLine."Allow Invoice Disc.", TransferLine."Prepayment Line")
                                else
                                    VATAmountLine.SumLine(
                                      AmtToHandle, TransferLine."Inv. Disc. Amount to Invoice", TransferLine."VAT Difference", TransferLine."Allow Invoice Disc.", TransferLine."Prepayment Line");
                            end;
                        QtyType::Shipping:
                            begin
                                if TransferLine."Document Type" in
                                   [TransferLine."Document Type"::"Return Order", TransferLine."Document Type"::"Credit Memo"]
                                then begin
                                    QtyToHandle := TransferLine."Return Qty. to Receive";
                                    VATAmountLine.Quantity += TransferLine."Return Qty. to Receive (Base)";
                                end else begin
                                    QtyToHandle := TransferLine."Qty. to Ship";
                                    VATAmountLine.Quantity += TransferLine."Qty. to Ship (Base)";
                                end;
                                if IncludePrepayments then
                                    AmtToHandle := TransferLine.GetLineAmountToHandleInclPrepmt(QtyToHandle)
                                else
                                    AmtToHandle := TransferLine.GetLineAmountToHandle(QtyToHandle);
                                VATAmountLine.SumLine(
                                  AmtToHandle, Round(TransferLine."Inv. Discount Amount" * QtyToHandle / TransferLine.Quantity, Currency."Amount Rounding Precision"),
                                  TransferLine."VAT Difference", TransferLine."Allow Invoice Disc.", TransferLine."Prepayment Line");
                            end;
                    end;
                    TotalVATAmount += TransferLine."Amount Including VAT" - TransferLine.Amount;
                    OnCalcVATAmountLinesOnAfterCalcLineTotals(VATAmountLine, TransferHeader, TransferLine, Currency, QtyType, TotalVATAmount, QtyToHandle);
                end;
            until TransferLine.Next() = 0;
        TransferLine.SetRange(Type);
        TransferLine.SetRange(Quantity);
        TransferLine.SetRange("Unit Price");
        TransferLine.SetLoadFields();

        IsHandled := false;
        OnCalcVATAmountLinesOnBeforeVATAmountLineUpdateLines(TransferLine, IsHandled, VATAmountLine, TotalVATAmount);
        if not IsHandled then
            VATAmountLine.UpdateLines(
              TotalVATAmount, Currency, TransferHeader."Currency Factor", TransferHeader."Prices Including VAT",
              TransferHeader."VAT Base Discount %", TransferHeader."Tax Area Code", TransferHeader."Tax Liable", TransferHeader."Posting Date");

        ShouldProcessRounding := RoundingLineInserted and (TotalVATAmount <> 0);
        OnCalcVATAmountLinesOnAfterCalcShouldProcessRounding(VATAmountLine, Currency, ShouldProcessRounding, TransferLine, TotalVATAmount);
        if ShouldProcessRounding then
            if GetVATAmountLineOfMaxAmt(VATAmountLine, TransferLine) then begin
                VATAmountLine."VAT Amount" += TotalVATAmount;
                VATAmountLine."Amount Including VAT" += TotalVATAmount;
                VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
                VATAmountLine.Modify();
            end;

        OnAfterCalcVATAmountLines(TransferHeader, TransferLine, VATAmountLine, QtyType);
    end;

}
