tableextension 50112 "Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";


            trigger OnValidate()
            var
                Customer: Record "Customer";
            begin
                if Customer.Get("No.") then begin
                    "Sell-to Customer Name" := Customer."Name"
                end;

            end;
        }
        field(50001; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(50002; "Sell-To Customer Name"; Text[20])
        {
            Caption = 'Customer Name';
            DataClassification = ToBeClassified;
            TableRelation = Customer.Name;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
                if "Sell-to Customer No." <> '' then
                    Customer.Get("Sell-to Customer No.");

                if Customer.SelectCustomer(Customer) then begin
                    xRec := Rec;
                    "Sell-to Customer Name" := Customer.Name;
                    Validate("Sell-to Customer No.", Customer."No.");
                end;
            end;


        }
        field(50003; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }
}


