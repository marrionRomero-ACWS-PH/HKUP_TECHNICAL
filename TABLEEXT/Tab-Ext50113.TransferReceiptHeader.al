tableextension 50113 "Transfer Receipt Header" extends "Transfer Receipt Header"
{
    fields
    {
        field(50100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CustRec: Record Customer;

            begin
                Reset();
                if CustRec.Get("Customer Name") then begin
                    "Customer Name" := CustRec.Name;
                end;
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
    }
}
