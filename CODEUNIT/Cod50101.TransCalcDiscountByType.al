codeunit 50101 "Trans.- Calc Discount By Type"
{
    TableNo = "Transfer Line";

    trigger OnRun()
    var
        TransferLine: Record "Transfer Line";
        TransferHeader: Record "Transfer Header";
    begin
        TransferLine.Copy(Rec);

        if TransferHeader.Get(Rec."Document Type", Rec."Document No.") then begin
            ApplyDefaultInvoiceDiscount(TransferHeader."Invoice Discount Value", TransferHeader);
            // on new order might be no line
            if Rec.Get(TransferLine."Document Type", TransferLine."Document No.", TransferLine."Line No.") then;
        end;
    end;

    var
        InvDiscBaseAmountIsZeroErr: Label 'Cannot apply an invoice discount because the document does not include lines where the Allow Invoice Disc. field is selected. To add a discount, specify a line discount in the Line Discount % field for the relevant lines, or add a line of type Item where the Allow Invoice Disc. field is selected.';
        CalcInvoiceDiscountOnTransferLine: Boolean;

    procedure ApplyDefaultInvoiceDiscount(InvoiceDiscountAmount: Decimal; var TransferHeader: Record "Transfer Header")
    begin
        ApplyDefaultInvoiceDiscount(InvoiceDiscountAmount, TransferHeader, false);
    end;

    internal procedure ApplyDefaultInvoiceDiscount(InvoiceDiscountAmount: Decimal; var TransferHeader: Record "Transfer Header"; ModifyBeforeApplying: Boolean)
    var
        IsHandled: Boolean;
    begin
        if not ShouldRedistributeInvoiceDiscountAmount(TransferHeader) then
            exit;

        IsHandled := false;
        OnBeforeApplyDefaultInvoiceDiscount(TransferHeader, IsHandled, InvoiceDiscountAmount);
        if not IsHandled then begin
            if ModifyBeforeApplying then
                TransferHeader.Modify();

            if TransferHeader."Invoice Discount Calculation" = TransferHeader."Invoice Discount Calculation"::Amount then
                ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, TransferHeader)
            else
                ApplyInvDiscBasedOnPct(TransferHeader);
        end;

        ResetRecalculateInvoiceDisc(TransferHeader);
    end;

    procedure ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount: Decimal; var TransferHeader: Record "Transfer Header")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TransferLine: Record "Transfer Line";
        SalesSetup: Record "Sales & Receivables Setup";
        DiscountNotificationMgt: Codeunit "Discount Notification Mgt.";
        InvDiscBaseAmount: Decimal;
    begin
        OnBeforeApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, TransferHeader);

        SalesSetup.Get();
        DiscountNotificationMgt.NotifyAboutMissingSetup(
            SalesSetup.RecordId, TransferHeader."Gen. Bus. Posting Group",
            SalesSetup."Discount Posting", SalesSetup."Discount Posting"::"Line Discounts");

        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Document Type", TransferHeader."Document Type");

        TransferLine.CalcVATAmountLines(0, TransferHeader, TransferLine, TempVATAmountLine);

        InvDiscBaseAmount := TempVATAmountLine.GetTotalInvDiscBaseAmount(false, TransferHeader."Currency Code");

        if (InvDiscBaseAmount = 0) and (InvoiceDiscountAmount > 0) then
            Error(InvDiscBaseAmountIsZeroErr);

        TempVATAmountLine.SetInvoiceDiscountAmount(InvoiceDiscountAmount, TransferHeader."Currency Code",
          TransferHeader."Prices Including VAT", TransferHeader."VAT Base Discount %");

        TransferLine.UpdateVATOnLines(0, TransferHeader, TransferLine, TempVATAmountLine);

        TransferHeader."Invoice Discount Calculation" := TransferHeader."Invoice Discount Calculation"::Amount;
        TransferHeader."Invoice Discount Value" := InvoiceDiscountAmount;

        ResetRecalculateInvoiceDisc(TransferHeader);

        TransferHeader.Modify();
    end;

    local procedure ApplyInvDiscBasedOnPct(var TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
        TransferCalcDiscount: Codeunit "Trans.- Calc Discount By Type";
    begin
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Document Type", TransferHeader."Document Type");
        if TransferLine.FindFirst() then begin
            if CalcInvoiceDiscountOnTransferLine then
                TransferCalcDiscount.CalculateInvoiceDiscountOnLine(TransferLine)
            else
                CODEUNIT.Run(CODEUNIT::"Sales-Calc. Discount", TransferLine);
            TransferHeader.Get(TransferHeader."Document Type", TransferHeader."No.");
        end;
    end;

    procedure GetCustInvoiceDiscountPct(TransferLine: Record "Transfer Line"): Decimal
    var
        TransferHeader: Record "Transfer Header";
        InvoiceDiscountValue: Decimal;
        AmountIncludingVATDiscountAllowed: Decimal;
        AmountDiscountAllowed: Decimal;
        SkipCustInvDiscCheck: Boolean;
    begin
        if not TransferHeader.Get(TransferLine."Document Type", TransferLine."Document No.") then
            exit(0);

        TransferHeader.CalcFields("Invoice Discount Amount");
        if TransferHeader."Invoice Discount Amount" = 0 then
            exit(0);

        case TransferHeader."Invoice Discount Calculation" of
            TransferHeader."Invoice Discount Calculation"::"%":
                begin
                    SkipCustInvDiscCheck := false;
                    OnGetCustInvoiceDiscountPctOnCaseInvDiscCalcPercent(SkipCustInvDiscCheck);
                    if not SkipCustInvDiscCheck then
                        // Only if CustInvDisc table is empty header is not updated
                        if not CustInvDiscRecExists(TransferHeader."Invoice Disc. Code") then
                            exit(0);

                    exit(TransferHeader."Invoice Discount Value");
                end;
            TransferHeader."Invoice Discount Calculation"::None,
            TransferHeader."Invoice Discount Calculation"::Amount:
                begin
                    InvoiceDiscountValue := TransferHeader."Invoice Discount Amount";

                    CalcAmountWithDiscountAllowed(TransferHeader, AmountIncludingVATDiscountAllowed, AmountDiscountAllowed);

                    if AmountDiscountAllowed + InvoiceDiscountValue = 0 then
                        exit(0);

                    if TransferHeader."Prices Including VAT" then
                        exit(Round(InvoiceDiscountValue / (AmountIncludingVATDiscountAllowed + InvoiceDiscountValue) * 100, 0.01));

                    exit(Round(InvoiceDiscountValue / AmountDiscountAllowed * 100, 0.01));
                end;
        end;

        exit(0);
    end;

    procedure CalculateInvoiceDiscountOnLine(var TransferLineToUpdate: Record "Transfer Line")
    Var
        TransferLine: Record "Transfer Line";
        TempTransferHeader: Record "Transfer Header";
        UpdateHeader: Boolean;
    begin
        TransferLine.Copy(TransferLineToUpdate);

        TempTransferHeader.Get(TransferLine."Document Type", TransferLine."Document No.");
        UpdateHeader := false;
        CalculateInvoiceDiscount(TempTransferHeader, TransferLine);

        if TransferLineToUpdate.Get(TransferLineToUpdate."Document Type", TransferLineToUpdate."Document No.", TransferLineToUpdate."Line No.") then;
    end;


    procedure ShouldRedistributeInvoiceDiscountAmount(var TransferHeader: Record "Transfer Header"): Boolean
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        IsHandled: Boolean;
        ShouldRedistributeInvDiscAmt: Boolean;
    begin
        IsHandled := false;
        OnBeforeShouldRedistributeInvoiceDiscountAmount(TransferHeader, IsHandled);
        if IsHandled then
            exit(true);

        TransferHeader.CalcFields("Recalculate Invoice Disc.");
        if not TransferHeader."Recalculate Invoice Disc." then
            exit(false);

        case TransferHeader."Invoice Discount Calculation" of
            TransferHeader."Invoice Discount Calculation"::Amount:
                exit(TransferHeader."Invoice Discount Value" <> 0);
            TransferHeader."Invoice Discount Calculation"::"%":
                exit(true);
            TransferHeader."Invoice Discount Calculation"::None:
                begin
                    if ApplicationAreaMgmtFacade.IsFoundationEnabled() then
                        exit(true);

                    ShouldRedistributeInvDiscAmt := not InvoiceDiscIsAllowed(TransferHeader."Invoice Disc. Code");
                    OnShouldRedistributeInvoiceDiscountAmountOnCaseInvDiscCalculationNone(TransferHeader, ShouldRedistributeInvDiscAmt);
                    exit(ShouldRedistributeInvDiscAmt);
                end;
            else
                exit(true);
        end;
    end;

    local procedure CalculateInvoiceDiscount(var TransferHeader: Record "Transfer Header"; var TransferLine2: Record "Transfer Line")
    var
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        SalesSetup: Record "Sales & Receivables Setup";
        TempServiceChargeLine: Record "Transfer Line" temporary;
        TransferCalcDiscountByType: Codeunit "Trans.- Calc Discount By Type";
        DiscountNotificationMgt: Codeunit "Discount Notification Mgt.";
        ShouldGetCustInvDisc: Boolean;
        IsHandled: Boolean;
        UpdateHeader: Boolean;
        TransferLine: Record "Transfer Line";
        CustPostingGr: Record "Customer Posting Group";
    begin
        OnBeforeCalculateInvoiceDiscount(TransferHeader, TransferLine2, UpdateHeader);

        SalesSetup.Get();
        if UpdateHeader then
            TransferHeader.Find(); // To ensure we have the latest - otherwise update fails.

        IsHandled := false;
        OnBeforeCalcSalesDiscount(TransferHeader, IsHandled, TransferLine2, UpdateHeader);
        if IsHandled then
            exit;

        TransferLine.LockTable();
        TransferHeader.TestField("Customer Posting Group");
        CustPostingGr.Get(TransferHeader."Customer Posting Group");

        TransferLine2.Reset();
        TransferLine2.SetRange("Document Type", TransferLine."Document Type");
        TransferLine2.SetRange("Document No.", TransferLine."Document No.");
        TransferLine2.SetRange("System-Created Entry", true);
        TransferLine2.SetRange(Type, TransferLine2.Type::"G/L Account");
        TransferLine2.SetRange("No.", CustPostingGr."Service Charge Acc.");
        TransferLine2.SetLoadFields("Unit Price", "Shipment No.", "Qty. Shipped Not Invoiced");
        if TransferLine2.FindSet(true) then
            repeat
                TransferLine2."Unit Price" := 0;
                TransferLine2.Modify();
                TempServiceChargeLine := TransferLine2;
                TempServiceChargeLine.Insert();
            until TransferLine2.Next() = 0;

        TransferLine2.Reset();
        TransferLine2.SetLoadFields();
        TransferLine2.SetRange("Document Type", TransferLine."Document Type");
        TransferLine2.SetRange("Document No.", TransferLine."Document No.");
        TransferLine2.SetFilter(Type, '<>0');
        OnCalculateInvoiceDiscountOnBeforeTransferLine2FindFirst(TransferLine2);
        if TransferLine2.FindFirst() then;
        TransferLine2.CalcVATAmountLines(0, TransferHeader, TransferLine2, TempVATAmountLine);
        InvDiscBase :=
          TempVATAmountLine.GetTotalInvDiscBaseAmount(
            TransferHeader."Prices Including VAT", TransferHeader."Currency Code");
        ChargeBase :=
          TempVATAmountLine.GetTotalLineAmount(
            TransferHeader."Prices Including VAT", TransferHeader."Currency Code");

        if UpdateHeader then
            TransferHeader.Modify();

        if TransferHeader."Posting Date" = 0D then
            CurrencyDate := WorkDate()
        else
            CurrencyDate := TransferHeader."Posting Date";

        CustInvDisc.GetRec(
          TransferHeader."Invoice Disc. Code", TransferHeader."Currency Code", CurrencyDate, ChargeBase);

        OnCalculateInvoiceDiscountOnBeforeCheckCustInvDiscServiceCharge(CustInvDisc, TransferHeader, CurrencyDate, ChargeBase);
        if CustInvDisc."Service Charge" <> 0 then begin
            OnCalculateInvoiceDiscountOnBeforeCurrencyInitialize(CustPostingGr);
            Currency.Initialize(TransferHeader."Currency Code");
            if not UpdateHeader then
                TransferLine2.SetTransferHeader(TransferHeader);
            if not TempServiceChargeLine.IsEmpty() then begin
                TempServiceChargeLine.FindLast();
                TransferLine2.Get(TransferLine."Document Type", TransferLine."Document No.", TempServiceChargeLine."Line No.");
                SetTransferLineServiceCharge(TransferHeader, TransferLine2);
                TransferLine2.Modify();
            end else begin
                IsHandled := false;
                OnCalculateInvoiceDiscountOnBeforeUpdateTransferLine2(TransferHeader, TransferLine2, UpdateHeader, CustInvDisc, IsHandled);
                if not IsHandled then begin
                    TransferLine2.Reset();
                    TransferLine2.SetRange("Document Type", TransferLine."Document Type");
                    TransferLine2.SetRange("Document No.", TransferLine."Document No.");
                    TransferLine2.FindLast();
                    TransferLine2.Init();
                    if not UpdateHeader then
                        TransferLine2.SetTransferHeader(TransferHeader);
                    TransferLine2."Line No." := TransferLine2."Line No." + 10000;
                    TransferLine2."System-Created Entry" := true;
                    TransferLine2.Type := TransferLine2.Type::"G/L Account";
                    TransferLine2.Validate("No.", CustPostingGr.GetServiceChargeAccount());
                    TransferLine2.Description := Text000;
                    TransferLine2.Validate(Quantity, 1);

                    OnAfterValidateTransferLine2Quantity(TransferHeader, TransferLine2, CustInvDisc);

                    if TransferLine2."Document Type" in
                        [TransferLine2."Document Type"::"Return Order", TransferLine2."Document Type"::"Credit Memo"]
                    then
                        TransferLine2.Validate("Return Qty. to Receive", TransferLine2.Quantity)
                    else
                        TransferLine2.Validate("Qty. to Ship", TransferLine2.Quantity);
                    SetTransferLineServiceCharge(TransferHeader, TransferLine2);
                    OnCalculateInvoiceDiscountOnBeforeTransferLineInsert(TransferLine2, TransferHeader);
                    TransferLine2.Insert();
                end;
            end;
            TransferLine2.CalcVATAmountLines(0, TransferHeader, TransferLine2, TempVATAmountLine);
        end else
            if TempServiceChargeLine.FindSet(false) then
                repeat
                    if (TempServiceChargeLine."Shipment No." = '') and (TempServiceChargeLine."Qty. Shipped Not Invoiced" = 0) then begin
                        TransferLine2.Get(TransferLine."Document Type", TransferLine."Document No.", TempServiceChargeLine."Line No.");
                        IsHandled := false;
                        OnCalculateInvoiceDiscountOnBeforeTransferLine2DeleteTrue(UpdateHeader, TransferLine2, IsHandled);
                        if not IsHandled then
                            TransferLine2.Delete(true);
                    end;
                until TempServiceChargeLine.Next() = 0;

        IsHandled := false;
        OnCalculateInvoiceDiscountOnBeforeCustInvDiscRecExists(TransferHeader, TransferLine2, UpdateHeader, InvDiscBase, ChargeBase, TempVATAmountLine, IsHandled);
        if IsHandled then
            exit;

        if CustInvDiscRecExists(TransferHeader."Invoice Disc. Code") then begin
            ShouldGetCustInvDisc := InvDiscBase <> ChargeBase;
            OnAfterCustInvDiscRecExists(TransferHeader, CustInvDisc, InvDiscBase, ChargeBase, ShouldGetCustInvDisc);
            if ShouldGetCustInvDisc then
                CustInvDisc.GetRec(
                  TransferHeader."Invoice Disc. Code", TransferHeader."Currency Code", CurrencyDate, InvDiscBase);

            DiscountNotificationMgt.NotifyAboutMissingSetup(
              SalesSetup.RecordId, TransferHeader."Gen. Bus. Posting Group", TransferLine2."Gen. Prod. Posting Group",
              SalesSetup."Discount Posting", SalesSetup."Discount Posting"::"Line Discounts");

            UpdateTransferHeaderInvoiceDiscount(TransferHeader, TempVATAmountLine, SalesSetup."Calc. Inv. Disc. per VAT ID");

            TransferLine2.SetTransferHeader(TransferHeader);
            TransferLine2.UpdateVATOnLines(0, TransferHeader, TransferLine2, TempVATAmountLine);
            UpdatePrepmtLineAmount(TransferHeader);
        end;

        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(TransferHeader);
        OnAfterCalcSalesDiscount(TransferHeader, TempVATAmountLine, TransferLine2);
    end;

    procedure ResetRecalculateInvoiceDisc(TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document Type", TransferHeader."Document Type");
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Recalculate Invoice Disc.", true);
        TransferLine.ModifyAll("Recalculate Invoice Disc.", false);

        OnAfterResetRecalculateInvoiceDisc(TransferHeader);
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "Cust. Invoice Disc.";
    begin
        CustInvDisc.SetRange(Code, InvDiscCode);
        exit(not CustInvDisc.IsEmpty);
    end;

    procedure InvoiceDiscIsAllowed(InvDiscCode: Code[20]): Boolean
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."Calc. Inv. Discount" then
            exit(true);

        exit(not CustInvDiscRecExists(InvDiscCode));
    end;

    local procedure CalcAmountWithDiscountAllowed(TransferHeader: Record "Transfer Header"; var AmountIncludingVATDiscountAllowed: Decimal; var AmountDiscountAllowed: Decimal)
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.SetRange("Document Type", TransferHeader."Document Type");
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Allow Invoice Disc.", true);
        TransferLine.CalcSums(Amount, "Amount Including VAT", "Inv. Discount Amount");
        AmountIncludingVATDiscountAllowed := TransferLine."Amount Including VAT";
        AmountDiscountAllowed := TransferLine.Amount + TransferLine."Inv. Discount Amount";
    end;

    local procedure OnAfterResetRecalculateInvoiceDisc(var TransferHeader: Record "Transfer Header")
    begin
    end;

    procedure CalcInvoiceDiscOnLine(CalcInvoiceDiscountOnLine: Boolean)
    begin
        CalcInvoiceDiscountOnTransferLine := CalcInvoiceDiscountOnLine;
    end;

    local procedure OnBeforeApplyDefaultInvoiceDiscount(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean; InvoiceDiscountAmount: Decimal)
    begin
    end;

    local procedure OnBeforeApplyInvDiscBasedOnAmt(InvoiceDiscountAmount: Decimal; var TransferHeader: Record "Transfer Header")
    begin
    end;

    local procedure OnBeforeShouldRedistributeInvoiceDiscountAmount(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean)
    begin
    end;

    local procedure OnGetCustInvoiceDiscountPctOnCaseInvDiscCalcPercent(var SkipCustInvDiscCheck: Boolean)
    begin
    end;

    local procedure OnShouldRedistributeInvoiceDiscountAmountOnCaseInvDiscCalculationNone(TransferHeader: Record "Transfer Header"; var ShouldRedistributeInvDiscAmt: Boolean)
    begin
    end;

    local procedure OnBeforeCalculateInvoiceDiscount(var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; var UpdateHeader: Boolean)
    begin
    end;

    local procedure OnBeforeCalcSalesDiscount(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferLine: Record "Transfer Line"; var UpdateHeader: Boolean)
    begin
    end;

}
