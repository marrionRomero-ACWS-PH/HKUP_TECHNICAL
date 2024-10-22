tableextension 50112 "Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50100; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            trigger OnValidate()
            var
                LocationCode: Code[10];
                ShouldSkipConfirmSellToCustomerDialog: Boolean;
                IsHandled: Boolean;
                Confirmed: Boolean;
                ConfirmedShouldBeFalse: Boolean;
                Text062: Label 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
                ConfirmChangeQst: Label 'Do you want to change %1?', Comment = '%1 = a Field Caption like Currency Code';
                SellToCustomerTxt: Label 'Sell-to Customer';
                TransferLine: Record "Transfer Line";
                Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
                Text006: Label 'You cannot change %1 because the order is associated with one or more purchase orders.';
                Customer: Record Customer;
                ApplicationAreaMgmt: Codeunit "Application Area Mgmt.";
                SkipSellToContact: Boolean;
                SalesCalcDiscountByType: Codeunit "Trans.- Calc Discount By Type";
            begin
                CheckCreditLimitIfLineNotInsertedYet();
                if "No." = '' then
                    InitRecord();
                TestStatusOpen();

                IsHandled := false;
                OnValidateSellToCustomerNoOnAfterTestStatusOpen(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;

                if ("Sell-to Customer No." <> xRec."Sell-to Customer No.") and
                   (xRec."Sell-to Customer No." <> '')
                then begin
                    if ("Opportunity No." <> '') and ("Document Type" in ["Document Type"::Quote, "Document Type"::Order]) then
                        Error(
                          Text062,
                          FieldCaption("Sell-to Customer No."),
                          FieldCaption("Opportunity No."),
                          "Opportunity No.",
                          "Document Type");

                    ShouldSkipConfirmSellToCustomerDialog := GetHideValidationDialog() or not GuiAllowed();
                    ConfirmedShouldBeFalse := false;
                    OnValidateSellToCustomerNoOnAfterCalcShouldSkipConfirmSellToCustomerDialog(Rec, ShouldSkipConfirmSellToCustomerDialog, ConfirmedShouldBeFalse);
                    if ShouldSkipConfirmSellToCustomerDialog then
                        Confirmed := true and not ConfirmedShouldBeFalse
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, SellToCustomerTxt);
                    if Confirmed then begin
                        TransferLine.SetRange("Document Type", "Document Type");
                        TransferLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer No." = '' then begin
                            if TransferLine.FindFirst() then
                                Error(
                                Text005,
                                FieldCaption("Sell-to Customer No."));
                            Init();
                            OnValidateSellToCustomerNoAfterInit(Rec, xRec);
                            GetSalesSetup();
                            "No. Series" := xRec."No. Series";
                            InitRecord();
                            InitNoSeries();
                            exit;
                        end;

                        CheckShipmentInfo(TransferLine, false);
                        CheckPrepmtInfo(TransferLine);
                        CheckReturnInfo(TransferLine, false);

                        TransferLine.Reset();
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
                then begin
                    TransferLine.SetRange("Document Type", TransferLine."Document Type"::Order);
                    TransferLine.SetRange("Document No.", "No.");
                    TransferLine.SetFilter("Purch. Order Line No.", '<>0');
                    if not TransferLine.IsEmpty() then
                        Error(
                          Text006,
                          FieldCaption("Sell-to Customer No."));
                    TransferLine.Reset();
                end;

                OnValidateSellToCustomerNoOnBeforeGetCust(Rec, xRec);
                GetCust("Sell-to Customer No.");
                IsHandled := false;
                OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs(Rec, Customer, IsHandled);
                if not IsHandled then
                    Customer.CheckBlockedCustOnDocs(Customer, "Document Type", false, false);
                if (not ApplicationAreaMgmt.IsSalesTaxEnabled()) and (Customer."No." <> '') then
                    Customer.TestField("Gen. Bus. Posting Group");
                OnAfterCheckSellToCust(Rec, xRec, Customer, CurrFieldNo);

                CopySellToCustomerAddressFieldsFromCustomer(Customer);

                if "Sell-to Customer No." = xRec."Sell-to Customer No." then
                    if ShippedSalesLinesExist() or ReturnReceiptExist() then begin
                        TestField("VAT Bus. Posting Group", xRec."VAT Bus. Posting Group");
                        TestField("Gen. Bus. Posting Group", xRec."Gen. Bus. Posting Group");
                    end;

                "Sell-to IC Partner Code" := Customer."IC Partner Code";
                "Send IC Document" := ("Sell-to IC Partner Code" <> '') and ("IC Direction" = "IC Direction"::Outgoing);

                UpdateShipToCodeFromCust();
                IsHandled := false;
                OnValidateSellToCustomerNoOnBeforeValidateLocationCode(Rec, Customer, IsHandled);
                if not IsHandled then
                    LocationCode := "Location Code";

                SetBillToCustomerNo(Customer);

                Validate("Location Code", LocationCode);
                GetShippingTime(FieldNo("Sell-to Customer No."));

                SetRcvdFromCountry(Customer."Country/Region Code");

                if (xRec."Sell-to Customer No." <> "Sell-to Customer No.") or
                   (xRec."Currency Code" <> "Currency Code") or
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreateSalesLines(SellToCustomerTxt);

                OnValidateSellToCustomerNoOnBeforeUpdateSellToCont(Rec, xRec, Customer, SkipSellToContact);
                if not SkipSellToContact then
                    UpdateSellToCont("Sell-to Customer No.");

                OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(Rec, xRec);
                if (xRec."Sell-to Customer No." <> '') and (xRec."Sell-to Customer No." <> "Sell-to Customer No.") then
                    Rec.RecallModifyAddressNotification(GetModifyCustomerAddressNotificationId());

                if xRec."Sell-to Customer No." <> "Sell-to Customer No." then
                    SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec, true);
            end;

        }
        field(50101; "Customer Name"; Text[250])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
        }
        field(50102; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = "currency";
            DataClassification = ToBeClassified;
        }
        field(50103; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
        }
        field(50104; "Shipping Method Code"; Code[20])
        {
            Caption = 'Shipping Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";
        }
        field(50105; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(50106; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                TestStatusOpen();
                BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";

                IsHandled := false;
                OnValidateBillToCustomerNoOnAfterCheckBilltoCustomerNoChanged(Rec, xRec, CurrFieldNo, IsHandled);

                if BilltoCustomerNoChanged and not IsHandled then
                    if xRec."Bill-to Customer No." = '' then
                        InitRecord()
                    else
                        if ConfirmBillToCustomerChange() then begin
                            OnValidateBillToCustomerNoOnAfterConfirmed(Rec);

                            SalesLine.SetRange("Document Type", "Document Type");
                            SalesLine.SetRange("Document No.", "No.");

                            CheckShipmentInfo(SalesLine, true);
                            CheckPrepmtInfo(SalesLine);
                            CheckReturnInfo(SalesLine, true);

                            SalesLine.Reset();
                        end else
                            "Bill-to Customer No." := xRec."Bill-to Customer No.";

                GetCust("Bill-to Customer No.");
                IsHandled := false;
                OnValidateBillToCustomerNoOnBeforeCheckBlockedCustOnDocs(Rec, Customer, IsHandled);
                if not IsHandled then
                    Customer.CheckBlockedCustOnDocs(Customer, "Document Type", false, false);
                if Customer."No." <> '' then
                    Customer.TestField("Customer Posting Group");
                PostingSetupMgt.CheckCustPostingGroupReceivablesAccount("Customer Posting Group");
                CheckCreditLimit();
                OnAfterCheckBillToCust(Rec, xRec, Customer);

                SetBillToCustomerAddressFieldsFromCustomer(Customer);

                if not BilltoCustomerNoChanged then
                    if ShippedSalesLinesExist() then begin
                        TestField("Customer Disc. Group", xRec."Customer Disc. Group");
                        TestField("Currency Code", xRec."Currency Code");
                    end;

                CreateDimensionsFromValidateBillToCustomerNo();

                Validate("Payment Terms Code");
                Validate("Prepmt. Payment Terms Code");
                Validate("Payment Method Code");
                Validate("Currency Code");
                Validate("Prepayment %");

                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   (xRec."Bill-to Customer No." <> "Bill-to Customer No.")
                then begin
                    RecreateSalesLines(BillToCustomerTxt);
                    BilltoCustomerNoChanged := false;
                end;
                if not SkipBillToContact then
                    UpdateBillToCont("Bill-to Customer No.");

                "Bill-to IC Partner Code" := Customer."IC Partner Code";
                "Send IC Document" := ("Bill-to IC Partner Code" <> '') and ("IC Direction" = "IC Direction"::Outgoing);

                OnValidateBillToCustomerNoOnBeforeRecallModifyAddressNotification(Rec, xRec);
                if (xRec."Bill-to Customer No." <> '') and (xRec."Bill-to Customer No." <> "Bill-to Customer No.") then
                    Rec.RecallModifyAddressNotification(Rec.GetModifyBillToCustomerAddressNotificationId());

                if xRec."Bill-to Customer No." <> "Bill-to Customer No." then
                    SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec, true);

                if Rec."Sell-to Customer No." <> Rec."Bill-to Customer No." then
                    UpdateShipToSalespersonCode();
            end;
        }

        field(50107; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = if ("Document Type" = filter(<> Order)) Opportunity."No." where("Contact No." = field("Sell-to Contact No."),
                                                                                          Closed = const(false))
            else
            if ("Document Type" = const(Order)) Opportunity."No." where("Contact No." = field("Sell-to Contact No."),
                                                                                                                                                          "Sales Document No." = field("No."),
                                                                                                                                                          "Sales Document Type" = const(Order));

            trigger OnValidate()
            begin
                LinkSalesDocWithOpportunity(xRec."Opportunity No.");
            end;
        }

        field(50108; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
                VatFactor: Decimal;
                LineInvDiscAmt: Decimal;
                InvDiscRounding: Decimal;
            begin
                TestStatusOpen();

                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Job Contract Entry No.", '<>%1', 0);
                    if SalesLine.Find('-') then begin
                        SalesLine.TestField("Job No.", '');
                        SalesLine.TestField("Job Contract Entry No.", 0);
                    end;

                    SalesLine.Reset();
                    SalesLine.SetRange("Document Type", "Document Type");
                    SalesLine.SetRange("Document No.", "No.");
                    SalesLine.SetFilter("Unit Price", '<>%1', 0);
                    SalesLine.SetFilter("VAT %", '<>%1', 0);
                    OnValidatePricesIncludingVATOnBeforeSalesLineFindFirst(SalesLine);
                    if SalesLine.FindFirst() then begin
                        RecalculatePrice := ConfirmRecalculatePrice(SalesLine);
                        OnAfterConfirmSalesPrice(Rec, SalesLine, RecalculatePrice);
                        SalesLine.SetSalesHeader(Rec);

                        InitializeRoundingPrecision(Currency);

                        SalesLine.LockTable();
                        LockTable();
                        SalesLine.FindSet();
                        repeat
                            SalesLine.TestField("Quantity Invoiced", 0);
                            SalesLine.TestField("Prepmt. Amt. Inv.", 0);
                            if not RecalculatePrice then begin
                                SalesLine."VAT Difference" := 0;
                                SalesLine.UpdateAmounts();
                            end else begin
                                VatFactor := 1 + SalesLine."VAT %" / 100;
                                if VatFactor = 0 then
                                    VatFactor := 1;
                                if not "Prices Including VAT" then
                                    VatFactor := 1 / VatFactor;
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then
                                    VatFactor := 1;
                                SalesLine."Unit Price" :=
                                  Round(SalesLine."Unit Price" * VatFactor, Currency."Unit-Amount Rounding Precision");
                                SalesLine."Line Discount Amount" :=
                                  Round(
                                    SalesLine.Quantity * SalesLine."Unit Price" * SalesLine."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                                LineInvDiscAmt := InvDiscRounding + SalesLine."Inv. Discount Amount" * VatFactor;
                                SalesLine."Inv. Discount Amount" := Round(LineInvDiscAmt, Currency."Amount Rounding Precision");
                                InvDiscRounding := LineInvDiscAmt - SalesLine."Inv. Discount Amount";
                                if SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT" then
                                    SalesLine."Line Amount" := SalesLine."Amount Including VAT"
                                else
                                    if "Prices Including VAT" then
                                        SalesLine."Line Amount" := SalesLine."Amount Including VAT" + SalesLine."Inv. Discount Amount"
                                    else
                                        SalesLine."Line Amount" := SalesLine.Amount + SalesLine."Inv. Discount Amount";
                                UpdatePrepmtAmounts(SalesLine);
                            end;
                            OnValidatePricesIncludingVATOnBeforeSalesLineModify(Rec, SalesLine, Currency, RecalculatePrice);
                            SalesLine.Modify();
                        until SalesLine.Next() = 0;
                    end;
                    OnAfterChangePricesIncludingVAT(Rec);
                end;
            end;
        }
        field(50109; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen();
                if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then begin
                    RecreateSalesLines(FieldCaption("VAT Bus. Posting Group"));
                    SalesCalcDiscountByType.ApplyDefaultInvoiceDiscount(0, Rec, true);
                end;
            end;
        }
        field(50110; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen();
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then begin
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        OnAfterAssignDefaultVATBusPostingGroup(Rec, xRec, GenBusPostingGrp);
                    end;
                    RecreateSalesLines(FieldCaption("Gen. Bus. Posting Group"));
                end;
            end;
        }
        field(50111; "Sell-to IC Partner Code"; Code[20])
        {
            Caption = 'Sell-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }

        field(50112; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                if "Send IC Document" then begin
                    if "Bill-to IC Partner Code" = '' then
                        TestField("Sell-to IC Partner Code");
                    IsHandled := false;
                    OnValidateSendICDocumentOnBeforeCheckICDirection(Rec, IsHandled);
                    if not IsHandled then
                        TestField("IC Direction", "IC Direction"::Outgoing);
                end;
            end;
        }

        field(50113; "IC Direction"; Enum "IC Direction Type")
        {
            Caption = 'IC Direction';

            trigger OnValidate()
            begin
                if "IC Direction" = "IC Direction"::Incoming then
                    "Send IC Document" := false;
            end;
        }
        field(50114; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateLocationCode(Rec, IsHandled);
                if IsHandled then
                    exit;

                TestStatusOpen();
                if ("Location Code" <> xRec."Location Code") and
                   (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                then
                    MessageIfSalesLinesExist(FieldCaption("Location Code"));

                UpdateShipToAddress();
                UpdateOutboundWhseHandlingTime();
                if "Location Code" <> xRec."Location Code" then
                    CreateDimFromDefaultDim(Rec.FieldNo("Location Code"));
            end;
        }
        field(50115; "Rcvd.-from Count./Region Code"; Code[10])
        {
            Caption = 'Received-from Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(50116; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(50117; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(50118; "Recalculate Invoice Disc."; Boolean)
        {
            CalcFormula = exist("Sales Line" where("Document Type" = field("Document Type"),
                                                    "Document No." = field("No."),
                                                    "Recalculate Invoice Disc." = const(true)));
            Caption = 'Recalculate Invoice Disc.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                OnBeforeValidateVATBaseDiscountPct(Rec, IsHandled);
                if IsHandled then
                    exit;

                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestStatusOpen();
                GLSetup.Get();
                if "VAT Base Discount %" > GLSetup."VAT Tolerance %" then
                    Error(
                      Text007,
                      FieldCaption("VAT Base Discount %"),
                      GLSetup.FieldCaption("VAT Tolerance %"),
                      GLSetup.TableCaption());

                if ("VAT Base Discount %" = xRec."VAT Base Discount %") and (CurrFieldNo <> 0) then
                    exit;

                UpdateSalesLineAmounts();
            end;
        }
        field(50120; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Sales Line"."Inv. Discount Amount" where("Document No." = field("No."),
                                                                         "Document Type" = field("Document Type")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50121; "Invoice Disc. Code"; Code[20])
        {
            AccessByPermission = TableData "Cust. Invoice Disc." = R;
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TestStatusOpen();
                MessageIfSalesLinesExist(FieldCaption("Invoice Disc. Code"));
            end;
        }
        field(50122; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";

            trigger OnValidate()
            begin
                CheckCustomerPostingGroupChange();
            end;
        }
    }
    local procedure CheckCreditLimitIfLineNotInsertedYet()
    var
        IsHandled: Boolean;
        HideCreditCheckDialogue: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckCreditLimitIfLineNotInsertedYet(Rec, IsHandled);
        if IsHandled then
            exit;

        if "No." = '' then begin
            HideCreditCheckDialogue := false;
            Rec.CheckCreditMaxBeforeInsert();
            HideCreditCheckDialogue := true;
        end;
    end;

    procedure CheckCreditMaxBeforeInsert()
    var
        TransferHeader2: Record "Transfer Header";
        ContBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        IsHandled: Boolean;
        HideCreditCheckDialogue: Boolean;
        Customer: Record Customer;
    begin
        IsHandled := false;
        OnBeforeCheckCreditMaxBeforeInsert(Rec, IsHandled, HideCreditCheckDialogue, GetFilterCustNo(), GetFilterContNo());
        if IsHandled then
            exit;

        if HideCreditCheckDialogue then
            exit;

        if (GetFilterCustNo() <> '') or ("Sell-to Customer No." <> '') then begin
            if "Sell-to Customer No." <> '' then
                Customer.Get("Sell-to Customer No.")
            else
                Customer.Get(GetFilterCustNo());
            if Customer."Bill-to Customer No." <> '' then
                TransferHeader2."Bill-to Customer No." := Customer."Bill-to Customer No."
            else
                TransferHeader2."Bill-to Customer No." := Customer."No.";
            OnCheckCreditMaxBeforeInsertOnCaseIfOnBeforeSalesHeaderCheckCase(SalesHeader2, Rec);
            CustCheckCreditLimit.SalesHeaderCheck(SalesHeader2);
        end else
            if GetFilterContNo() <> '' then begin
                Cont.Get(GetFilterContNo());
                if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.") then begin
                    Customer.Get(ContBusinessRelation."No.");
                    if Customer."Bill-to Customer No." <> '' then
                        TransferHeader2."Bill-to Customer No." := Customer."Bill-to Customer No."
                    else
                        TransferHeader2."Bill-to Customer No." := Customer."No.";
                    CustCheckCreditLimit.SalesHeaderCheck(TransferHeader2);
                end;
            end;

        OnAfterCheckCreditMaxBeforeInsert(Rec);
    end;

    procedure RecreateSalesLines(ChangedFieldName: Text[100])
    var
        TempSalesLine: Record "Sales Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        TempInteger: Record "Integer" temporary;
        TempATOLink: Record "Assemble-to-Order Link" temporary;
        SalesCommentLine: Record "Sales Comment Line";
        TempSalesCommentLine: Record "Sales Comment Line" temporary;
        ATOLink: Record "Assemble-to-Order Link";
        ExtendedTextAdded: Boolean;
        ConfirmText: Text;
        IsHandled: Boolean;
    begin
        if not SalesLinesExist() then
            exit;

        IsHandled := false;
        OnBeforeRecreateSalesLinesHandler(Rec, xRec, ChangedFieldName, IsHandled);
        if IsHandled then
            exit;

        IsHandled := false;
        OnRecreateSalesLinesOnBeforeConfirm(Rec, xRec, ChangedFieldName, HideValidationDialog, Confirmed, IsHandled);
        if not IsHandled then
            if GetHideValidationDialog() or not GuiAllowed() then
                Confirmed := true
            else begin
                if HasItemChargeAssignment() then
                    ConfirmText := ResetItemChargeAssignMsg
                else
                    ConfirmText := RecreateSalesLinesMsg;
                Confirmed := Confirm(ConfirmText, false, ChangedFieldName);
            end;

        if Confirmed then begin
            SalesLine.LockTable();
            ItemChargeAssgntSales.LockTable();
            ReservEntry.LockTable();
            Modify();
            OnBeforeRecreateSalesLines(Rec);
            SalesLine.Reset();
            SalesLine.SetRange("Document Type", "Document Type");
            SalesLine.SetRange("Document No.", "No.");
            OnRecreateSalesLinesOnAfterSetSalesLineFilters(SalesLine, Rec);
            if SalesLine.FindSet() then begin
                OnRecreateSalesLinesOnAfterFindSalesLine(Rec, SalesLine, ChangedFieldName);
                TempReservEntry.DeleteAll();
                RecreateReservEntryReqLine(TempSalesLine, TempATOLink, ATOLink);
                StoreSalesCommentLineToTemp(TempSalesCommentLine);
                SalesCommentLine.DeleteComments("Document Type".AsInteger(), "No.");
                TransferItemChargeAssgntSalesToTemp(ItemChargeAssgntSales, TempItemChargeAssgntSales);
                IsHandled := false;
                OnRecreateSalesLinesOnBeforeSalesLineDeleteAll(Rec, SalesLine, CurrFieldNo, IsHandled);
                if not IsHandled then
                    SalesLine.DeleteAll(true);

                SalesLine.Init();
                SalesLine."Line No." := 0;
                OnRecreateSalesLinesOnBeforeTempSalesLineFindSet(TempSalesLine);
                TempSalesLine.FindSet();
                ExtendedTextAdded := false;
                SalesLine.BlockDynamicTracking(true);
                repeat
                    RecreateSalesLinesHandleSupplementTypes(TempSalesLine, ExtendedTextAdded, TempItemChargeAssgntSales, TempInteger);
                    RestoreSalesCommentLine(TempSalesCommentLine, TempSalesLine."Line No.", SalesLine."Line No.");
                    OnRecreateSalesLinesOnBeforeCopyReservEntryFromTemp(SalesLine, TempSalesLine, Rec, xRec, ChangedFieldName);
                    SalesLineReserve.CopyReservEntryFromTemp(TempReservEntry, TempSalesLine, SalesLine."Line No.");
                    RecreateReqLine(TempSalesLine, SalesLine."Line No.", false);
                    SynchronizeForReservations(SalesLine, TempSalesLine);

                    if TempATOLink.AsmExistsForSalesLine(TempSalesLine) then begin
                        ATOLink := TempATOLink;
                        ATOLink."Document Line No." := SalesLine."Line No.";
                        ATOLink.Insert();
                        ATOLink.UpdateAsmFromSalesLineATOExist(SalesLine);
                        TempATOLink.Delete();
                    end;
                until TempSalesLine.Next() = 0;

                OnRecreateSalesLinesOnAfterProcessTempSalesLines(TempSalesLine, Rec, xRec, ChangedFieldName);

                RestoreSalesCommentLine(TempSalesCommentLine, 0, 0);

                CreateItemChargeAssgntSales(TempItemChargeAssgntSales, TempSalesLine, TempInteger);

                TempSalesLine.SetRange(Type);
                TempSalesLine.DeleteAll();
                OnAfterDeleteAllTempSalesLines(Rec);
                ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                TempItemChargeAssgntSales.DeleteAll();
            end;
        end else
            Error(RecreateSalesLinesCancelErr, ChangedFieldName);

        SalesLine.BlockDynamicTracking(false);

        OnAfterRecreateSalesLines(Rec, ChangedFieldName);
    end;

    procedure TestQuantityShippedField(TransferLine: Record "Transfer Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestQuantityShippedField(TransferLine, IsHandled);
        if IsHandled then
            exit;

        TransferLine.TestField("Quantity Shipped", 0);
        OnAfterTestQuantityShippedField(TransferLine);
    end;

    procedure ShippedSalesLinesExist(): Boolean
    var
        TransferLine: record "Transfer Line";
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document Type", "Document Type");
        TransferLine.SetRange("Document No.", "No.");
        TransferLine.SetFilter("Quantity Shipped", '<>0');
        exit(TransferLine.FindFirst());
    end;

    procedure ReturnReceiptExist(): Boolean
    var
        TransferLine: record "Transfer Line";
    begin
        TransferLine.Reset();
        TransferLine.SetRange("Document Type", "Document Type");
        TransferLine.SetRange("Document No.", "No.");
        TransferLine.SetFilter("Return Qty. Received", '<>0');
        exit(TransferLine.FindFirst());
    end;

    procedure GetShippingTime(CalledByFieldNo: Integer)
    var
        ShippingAgentServices: Record "Shipping Agent Services";
        IsHandled: Boolean;
        Customer: Record Customer;
    begin
        IsHandled := false;
        OnBeforeGetShippingTime(Rec, xRec, CalledByFieldNo, IsHandled, CurrFieldNo);
        if IsHandled then
            exit;
        if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

        if ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code") then
            "Shipping Time" := ShippingAgentServices."Shipping Time"
        else begin
            GetCust("Sell-to Customer No.");
            "Shipping Time" := Customer."Shipping Time"
        end;
        if not (CalledByFieldNo in [FieldNo("Shipping Agent Code"), FieldNo("Shipping Agent Service Code")]) then
            Validate("Shipping Time");
    end;

    procedure IsCreditDocType() CreditDocType: Boolean
    begin
        CreditDocType := "Document Type" in ["Document Type"::"Return Order", "Document Type"::"Credit Memo"];
        OnBeforeIsCreditDocType(Rec, CreditDocType);
    end;

    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
        OfficeContact: Record Contact;
        OfficeMgt: Codeunit "Office Management";
    begin
        if OfficeMgt.GetContact(OfficeContact, CustomerNo) then begin
            HideValidationDialog := true;
            UpdateSellToCust(OfficeContact."No.");
            HideValidationDialog := false;
        end else
            if Cust.Get(CustomerNo) then begin
                if Cust."Primary Contact No." <> '' then
                    "Sell-to Contact No." := Cust."Primary Contact No."
                else begin
                    ContBusRel.Reset();
                    ContBusRel.SetCurrentKey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                    ContBusRel.SetRange("No.", "Sell-to Customer No.");
                    if ContBusRel.FindFirst() then
                        "Sell-to Contact No." := ContBusRel."Contact No."
                    else
                        "Sell-to Contact No." := '';
                end;
                "Sell-to Contact" := Cust.Contact;
            end;
        if "Sell-to Contact No." <> '' then
            if OfficeContact.Get("Sell-to Contact No.") then
                OfficeContact.CheckIfPrivacyBlockedGeneric();

        OnAfterUpdateSellToCont(Rec, Cust, OfficeContact, HideValidationDialog);
    end;

    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        Cont: Record Contact;
        CustomerTempl: Record "Customer Templ.";
        SearchContact: Record Contact;
        ContactBusinessRelationFound: Boolean;
        IsHandled: Boolean;
        SkipSellToContact: Boolean;
    begin
        OnBeforeUpdateSellToCust(Rec, Cont, Customer, ContactNo);

        if not Cont.Get(ContactNo) then begin
            "Sell-to Contact" := '';
            exit;
        end;
        "Sell-to Contact No." := Cont."No.";

        IsHandled := false;
        OnUpdateSellToCustOnAfterSetSellToContactNo(Rec, Customer, Cont, IsHandled);
        if IsHandled then
            exit;

        if Cont.Type = Cont.Type::Person then
            ContactBusinessRelationFound := ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."No.");
        if not ContactBusinessRelationFound then begin
            IsHandled := false;
            OnUpdateSellToCustOnBeforeFindContactBusinessRelation(Cont, ContBusinessRelation, ContactBusinessRelationFound, IsHandled);
            if not IsHandled then
                ContactBusinessRelationFound :=
                    ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.");
        end;

        OnUpdateSellToCustOnAfterFindContactBusinessRelation(Rec, Cont, ContBusinessRelation, ContactBusinessRelationFound);

        if ContactBusinessRelationFound then begin
            CheckCustomerContactRelation(Cont, "Sell-to Customer No.", ContBusinessRelation."No.");

            if "Sell-to Customer No." = '' then begin
                SkipSellToContact := true;
                Validate("Sell-to Customer No.", ContBusinessRelation."No.");
                SkipSellToContact := false;
            end;

            UpdateSellToEmail(Cont);
            Validate("Sell-to Phone No.", Cont."Phone No.");
        end else begin
            if "Document Type" = "Document Type"::Quote then begin
                if not GetContactAsCompany(Cont, SearchContact) then
                    SearchContact := Cont;
                "Sell-to Customer Name" := SearchContact."Company Name";
                "Sell-to Customer Name 2" := SearchContact."Name 2";
                "Sell-to Phone No." := SearchContact."Phone No.";
                "Sell-to E-Mail" := SearchContact."E-Mail";
                SetShipToAddress(
                  SearchContact."Company Name", SearchContact."Name 2", SearchContact.Address, SearchContact."Address 2",
                  SearchContact.City, SearchContact."Post Code", SearchContact.County, SearchContact."Country/Region Code");
                OnUpdateSellToCustOnAfterSetShipToAddress(Rec, SearchContact);
                if ("Sell-to Customer Templ. Code" = '') and (not CustomerTempl.IsEmpty) then
                    Validate("Sell-to Customer Templ. Code", Cont.FindNewCustomerTemplate());
                OnUpdateSellToCustOnAfterSetFromSearchContact(Rec, SearchContact);
            end else begin
                IsHandled := false;
                OnUpdateSellToCustOnBeforeContactIsNotRelatedToAnyCostomerErr(Rec, Cont, ContBusinessRelation, IsHandled);
                if not IsHandled then
                    Error(ContactIsNotRelatedToAnyCostomerErr, Cont."No.", Cont.Name);
            end;

            "Sell-to Contact" := Cont.Name;
        end;

        UpdateSellToCustContact(Customer, Cont);

        if "Document Type" = "Document Type"::Quote then begin
            if Customer.Get("Sell-to Customer No.") or Customer.Get(ContBusinessRelation."No.") then begin
                if Customer."Copy Sell-to Addr. to Qte From" = Customer."Copy Sell-to Addr. to Qte From"::Company then
                    GetContactAsCompany(Cont, Cont);
            end else
                GetContactAsCompany(Cont, Cont);
            "Sell-to Address" := Cont.Address;
            "Sell-to Address 2" := Cont."Address 2";
            "Sell-to City" := Cont.City;
            "Sell-to Post Code" := Cont."Post Code";
            "Sell-to County" := Cont.County;
            "Sell-to Country/Region Code" := Cont."Country/Region Code";
        end;
        Clear(IsHandled);
        OnUpdateSellToCustOnBeforeValidateBillToContactNo(Rec, IsHandled);
        if not IsHandled then
            if ("Sell-to Customer No." = "Bill-to Customer No.") or
               ("Bill-to Customer No." = '')
            then
                Validate("Bill-to Contact No.", "Sell-to Contact No.");

        OnAfterUpdateSellToCust(Rec, Cont);
    end;

    procedure RecallModifyAddressNotification(NotificationID: Guid)
    var
        MyNotifications: Record "My Notifications";
        ModifyCustomerAddressNotification: Notification;
    begin
        if IsCreditDocType() or (not MyNotifications.IsEnabled(NotificationID)) then
            exit;

        ModifyCustomerAddressNotification.Id := NotificationID;
        ModifyCustomerAddressNotification.Recall();
    end;

    local procedure GetFilterCustNo(): Code[20]
    var
        MinValue: Code[20];
        MaxValue: Code[20];
    begin
        if GetFilter("Sell-to Customer No.") <> '' then begin
            if TryGetFilterCustNoRange(MinValue, MaxValue) then
                if MinValue = MaxValue then
                    exit(MaxValue);
        end;
    end;

    local procedure GetFilterContNo(): Code[20]
    begin
        if GetFilter("Sell-to Contact No.") <> '' then
            if GetRangeMin("Sell-to Contact No.") = GetRangeMax("Sell-to Contact No.") then
                exit(GetRangeMax("Sell-to Contact No."));
    end;

    local procedure SetRcvdFromCountry(RcvdFromCountryRegionCode: Code[10])
    begin
        if not IsCreditDocType() then
            exit;
        Rec."Rcvd.-from Count./Region Code" := RcvdFromCountryRegionCode;
    end;


    local procedure OnBeforeCheckCreditLimitIfLineNotInsertedYet(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
    end;

    local procedure OnBeforeCheckCreditMaxBeforeInsert(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean; HideCreditCheckDialogue: Boolean; FilterCustNo: Code[20]; FilterContNo: Code[20])
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnAfterTestStatusOpen(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnAfterCalcShouldSkipConfirmSellToCustomerDialog(var TransferHeader: Record "Transfer Header"; var ShouldSkipConfirmSellToCustomerDialog: Boolean; var ConfirmedShouldBeFalse: Boolean)
    begin
    end;

    local procedure OnValidateSellToCustomerNoAfterInit(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header")
    begin
    end;

    local procedure GetSalesSetup()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        OnAfterGetSalesSetup(Rec, SalesSetup, CurrFieldNo);
    end;

    local procedure OnAfterGetSalesSetup(SalesHeader: Record "Transfer Header"; var TransferReceivablesSetup: Record "Sales & Receivables Setup"; CalledByFieldNo: Integer)
    begin
    end;

    local procedure InitNoSeries()
    begin
        if xRec."Shipping No." <> '' then begin
            "Shipping No. Series" := xRec."Shipping No. Series";
            "Shipping No." := xRec."Shipping No.";
        end;
        if xRec."Posting No." <> '' then begin
            "Posting No. Series" := xRec."Posting No. Series";
            "Posting No." := xRec."Posting No.";
        end;
        if xRec."Return Receipt No." <> '' then begin
            "Return Receipt No. Series" := xRec."Return Receipt No. Series";
            "Return Receipt No." := xRec."Return Receipt No.";
        end;
        if xRec."Prepayment No." <> '' then begin
            "Prepayment No. Series" := xRec."Prepayment No. Series";
            "Prepayment No." := xRec."Prepayment No.";
        end;
        if xRec."Prepmt. Cr. Memo No." <> '' then begin
            "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
            "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
        end;
    End;

    local procedure CheckShipmentInfo(var TransferLine: Record "Transfer Line"; BillTo: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckShipmentInfo(Rec, xRec, TransferLine, BillTo, IsHandled);
        if IsHandled then
            exit;

        if "Document Type" = "Document Type"::Order then
            TransferLine.SetFilter("Quantity Shipped", '<>0')
        else
            if "Document Type" = "Document Type"::Invoice then begin
                if not BillTo then
                    TransferLine.SetRange("Sell-to Customer No.", xRec."Sell-to Customer No.");
                TransferLine.SetFilter("Shipment No.", '<>%1', '');
            end;

        if TransferLine.FindFirst() then
            if "Document Type" = "Document Type"::Order then
                TestQuantityShippedField(TransferLine)
            else
                TransferLine.TestField("Shipment No.", '');
        TransferLine.SetRange("Shipment No.");
        TransferLine.SetRange("Quantity Shipped");
    end;

    local procedure OnBeforeCheckShipmentInfo(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; BillTo: Boolean; var IsHandled: Boolean)
    begin
    end;

    local procedure OnBeforeTestQuantityShippedField(TransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    begin
    end;

    local procedure CheckPrepmtInfo(var TransferLine: Record "Transfer Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckPrepmtInfo(Rec, xRec, TransferLine, IsHandled);
        if IsHandled then
            exit;

        if "Document Type" = "Document Type"::Order then begin
            TransferLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
            if TransferLine.Find('-') then
                TransferLine.TestField("Prepmt. Amt. Inv.", 0);
            TransferLine.SetRange("Prepmt. Amt. Inv.");
        end;
    end;

    local procedure SetBillToCustomerNo(var Cust: Record Customer)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetBillToCustomerNo(Rec, Cust, IsHandled, xRec, CurrFieldNo);
        if IsHandled then
            exit;

        if Cust."Bill-to Customer No." <> '' then
            Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
        else begin
            if "Bill-to Customer No." = "Sell-to Customer No." then
                SkipBillToContact := true;
            Rec.Validate("Bill-to Customer No.", Rec."Sell-to Customer No.");
            SkipBillToContact := false;
        end;
    end;

    local procedure OnBeforeCheckPrepmtInfo(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    begin
    end;

    local procedure OnAfterChangePricesIncludingVAT(var TransferHeader: Record "Transfer Header")
    begin
    end;

    local procedure OnAfterSetFieldsBilltoCustomer(var TransferHeader: Record "Transfer Header"; Customer: Record Customer; xTransferHeader: Record "Transfer Header"; SkipBillToContact: Boolean; CUrrentFieldNo: Integer)
    begin
    end;

    local procedure OnValidateBilltoCustomerTemplCodeOnBeforeRecreateTransferLines(var TransferHeader: Record "Transfer Header"; CallingFieldNo: Integer)
    begin
    end;

    local procedure OnBeforeCheckReturnInfo(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean; xTransferHeader: Record "Transfer Header"; BillTo: Boolean)
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnBeforeCheckBlockedCustOnDocs(var TransferHeader: Record "Transfer Header"; var Cust: Record Customer; var IsHandled: Boolean)
    begin
    end;

    local procedure OnAfterCheckSellToCust(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; Customer: Record Customer; CurrentFieldNo: Integer)
    begin
    end;

    local procedure OnBeforeSetBillToCustomerNo(var TransferHeader: Record "Transfer Header"; var Cust: Record Customer; var IsHandled: Boolean; xTransferHeader: Record "Transfer Header"; var CurrentFieldNo: Integer)
    begin
    end;

    local procedure CheckReturnInfo(var TransferLine: Record "Transfer Line"; BillTo: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckReturnInfo(Rec, IsHandled, xRec, BillTo);
        if IsHandled then
            exit;

        if "Document Type" = "Document Type"::"Return Order" then
            TransferLine.SetFilter("Return Qty. Received", '<>0')
        else
            if "Document Type" = "Document Type"::"Credit Memo" then begin
                if not BillTo then
                    TransferLine.SetRange("Sell-to Customer No.", xRec."Sell-to Customer No.");
                TransferLine.SetFilter("Return Receipt No.", '<>%1', '');
            end;

        if TransferLine.FindFirst() then
            if "Document Type" = "Document Type"::"Return Order" then
                TransferLine.TestField("Return Qty. Received", 0)
            else
                TransferLine.TestField("Return Receipt No.", '');
    end;

    local procedure CopySellToCustomerAddressFieldsFromCustomer(var SellToCustomer: Record Customer)
    var
        IsHandled: Boolean;
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopySellToCustomerAddressFieldsFromCustomer(Rec, SellToCustomer, IsHandled);
        if not IsHandled then begin
            "Sell-to Customer Templ. Code" := '';
            "Sell-to Customer Name" := Customer.Name;
            "Sell-to Customer Name 2" := Customer."Name 2";
            "Sell-to Phone No." := Customer."Phone No.";
            "Sell-to E-Mail" := Customer."E-Mail";
            if SellToCustomerIsReplaced() or
                ShouldCopyAddressFromSellToCustomer(SellToCustomer) or
                (HasDifferentSellToAddress(SellToCustomer) and SellToCustomer.HasAddress())
            then begin
                "Sell-to Address" := SellToCustomer.Address;
                "Sell-to Address 2" := SellToCustomer."Address 2";
                "Sell-to City" := SellToCustomer.City;
                "Sell-to Post Code" := SellToCustomer."Post Code";
                "Sell-to County" := SellToCustomer.County;
                "Sell-to Country/Region Code" := SellToCustomer."Country/Region Code";
                OnCopySellToCustomerAddressFieldsFromCustomerOnAfterAssignSellToCustomerAddress(Rec, SellToCustomer);
            end;
            if not SkipSellToContact then
                "Sell-to Contact" := SellToCustomer.Contact;
            "Gen. Bus. Posting Group" := SellToCustomer."Gen. Bus. Posting Group";
            if "VAT Bus. Posting Group" = '' then
                "VAT Bus. Posting Group" := SellToCustomer."VAT Bus. Posting Group"
            else
                Validate("VAT Bus. Posting Group", SellToCustomer."VAT Bus. Posting Group");
            "Tax Area Code" := SellToCustomer."Tax Area Code";
            "Tax Liable" := SellToCustomer."Tax Liable";
            "VAT Registration No." := SellToCustomer."VAT Registration No.";
            "Registration Number" := SellToCustomer."Registration Number";
            "VAT Country/Region Code" := SellToCustomer."Country/Region Code";
            "Shipping Advice" := SellToCustomer."Shipping Advice";
            IsHandled := false;
            OnCopySelltoCustomerAddressFieldsFromCustomerOnBeforeAssignRespCenter(Rec, SellToCustomer, IsHandled);
            if not IsHandled then begin
                "Responsibility Center" := UserSetupMgt.GetRespCenter(0, SellToCustomer."Responsibility Center");
                OnCopySelltoCustomerAddressFieldsFromCustomerOnAfterAssignRespCenter(Rec, SellToCustomer, CurrFieldNo);
            end;
            IsHandled := false;
            OnCopySellToCustomerAddressFieldsFromCustomerOnBeforeUpdateLocation(Rec, SellToCustomer, IsHandled);
            if not IsHandled then
                UpdateLocationCode(SellToCustomer."Location Code");
        end;

        OnAfterCopySellToCustomerAddressFieldsFromCustomer(Rec, SellToCustomer, CurrFieldNo, SkipBillToContact, SkipSellToContact);
    end;

    local procedure UpdateShipToCodeFromCust()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeUpdateShipToCodeFromCust(Rec, Customer, IsHandled);
        if IsHandled then
            exit;

        Rec.Validate("Ship-to Code", Customer."Ship-to Code");
    end;

    local procedure OnValidateSellToCustomerNoOnBeforeGetCust(var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
    begin
    end;

    procedure GetModifyCustomerAddressNotificationId(): Guid
    begin
        exit('509FD112-31EC-4CDC-AEBF-19B8FEBA526F');
    end;

    procedure SetModifyCustomerAddressNotificationDefaultState()
    var
        MyNotifications: Record "My Notifications";
        ModifySellToCustomerAddressNotificationNameTxt: Label 'Update Sell-to Customer Address';
        ModifySellToCustomerAddressNotificationDescriptionTxt: Label 'Warn if the sell-to address on sales documents is different from the customer''s existing address.';
    begin
        MyNotifications.InsertDefault(GetModifyCustomerAddressNotificationId(),
          ModifySellToCustomerAddressNotificationNameTxt, ModifySellToCustomerAddressNotificationDescriptionTxt, true);
    end;

    procedure GetCust(CustNo: Code[20]): Record Customer
    var
        Customer: Record Customer;
    begin
        OnBeforeGetCust(Rec, Customer, CustNo);

        if not (("Document Type" = "Document Type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Customer."No." then
                Customer.Get(CustNo);
        end else
            Clear(Customer);

        exit(Customer);
    end;

    local procedure OnBeforeGetCust(var TransferHeader: Record "Transfer Header"; var Customer: Record Customer; CustNo: Code[20])
    begin
    end;

    local procedure OnBeforeCopySellToCustomerAddressFieldsFromCustomer(var TransferHeader: Record "Transfer Header"; Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;

    local procedure OnAfterTestQuantityShippedField(TransferLine: Record "Transfer Line")
    begin
    end;

    local procedure OnBeforeUpdateShipToCodeFromCust(var TransferHeader: Record "Transfer Header"; var Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;

    local procedure OnBeforeGetShippingTime(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; var CalledByFieldNo: Integer; var IsHandled: Boolean; CurrentFieldNo: Integer)
    begin
    end;

    local procedure OnBeforeSetBillToCustomerAddressFieldsFromCustomer(var TransferHeader: Record "Transfer Header"; var BillToCustomer: Record Customer; var SkipBillToContact: Boolean; var IsHandled: Boolean; xTransferHeader: Record "Transfer Header"; var GLSetup: Record "General Ledger Setup"; CurrentFieldNo: Integer)
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnBeforeUpdateSellToCont(var SalesHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header"; SellToCustomer: Record Customer; var SkipSellToContact: Boolean)
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnBeforeValidateLocationCode(Rec: Record "Transfer Header"; Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;

    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var TransferHeader: Record "Transfer Header"; xTransferHeader: Record "Transfer Header")
    begin
    end;

    [TryFunction]
    local procedure TryGetFilterCustNoRange(var MinValue: Code[20]; var MaxValue: Code[20])
    begin
        MinValue := GetRangeMin("Sell-to Customer No.");
        MaxValue := GetRangeMax("Sell-to Customer No.");
    end;
}