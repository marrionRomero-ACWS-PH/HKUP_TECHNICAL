tableextension 50104 "SalesOrder-GratisInvoice" extends "Sales Header"
{
    fields
    {
        field(50100; "Gratis Invoice"; Boolean)
        {
            Caption = 'Gratis Invoice';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Gratis Invoice" then
                    SetSalesLineValuesToZero();
            end;
        }
    }

    local procedure SetSalesLineValuesToZero()
    var
        SalesLine: Record "Sales Line";
        IsConfirmed: Boolean;
    begin
        IsConfirmed := Confirm('If the Gratis Invoice is confirmed, all prices and amounts will be set to zero. Are you sure you want to proceed?');
        if IsConfirmed then begin
            SalesLine.SetRange("Document Type", "Document Type");
            SalesLine.SetRange("Document No.", "No.");
            if SalesLine.FindSet() then begin

                repeat
                    SalesLine.Validate("Unit Price", 0);
                    SalesLine."Line Amount" := 0;
                    SalesLine.Modify();
                until SalesLine.Next() = 0;
            end;
        end else begin
            Validate("Gratis Invoice", false);
        end;
    end;
}
