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
    begin
        SalesLine.SetRange("Document Type", "Document Type");
        SalesLine.SetRange("Document No.", "No.");
        if SalesLine.FindSet() then
            repeat
                // SalesLine.Validate(Quantity, 0);
                SalesLine.Validate("Unit Price", 0);
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;
}
