tableextension 50104 "Sales Header Extension" extends "Sales Header"
{
    fields
    {
        field(50100; "Gratis Invoice"; Boolean)
        {
            Caption = 'Gratis Invoice';
            DataClassification = ToBeClassified;

            trigger OnValidate()
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
        field(50101; "Consignment Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Ebook"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Item Discount Tracking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Warehouse Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Ready to Pick",Shipped;
        }
        field(50105; "Bulk Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    trigger OnModify()
    var
        NoSeriesRec: Record "No. Series";
        CustomerRec: Record Customer;
    begin
        // Check if the No. Series used is flagged for Consignment
        if "No. Series" <> '' then begin
            NoSeriesRec.Get("No. Series");
            // If the No. Series is for Consignment
            if NoSeriesRec."Consignment(Distributor)" then begin
                // Retrieve the Customer Record
                if CustomerRec.Get("Sell-to Customer No.") then begin
                    // Check if the Customer's Consignment A/C is set to false
                    if not CustomerRec."Consignment Account" then begin
                        // Error and prompt the user
                        Error('This is a Consignment (Distributor) Invoice, please select Consignment A/C.');
                    end;
                end;
            end;
        end;
    end;
}
