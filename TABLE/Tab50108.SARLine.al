table 50108 "SAR Line"
{
    Caption = 'SAR Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SAR No."; Code[20])
        {
            Caption = 'SAR No.';
            TableRelation = "SAR Header";
        }
        field(2; "SAR Line No."; Code[20])
        {
            Caption = 'SAR Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(4; Cover; Option)
        {
            Caption = 'Cover';
            DataClassification = ToBeClassified;
            OptionMembers = Printing,Binding;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(6; Currency; Code[20])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(7; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(9; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
    }
    keys
    {
        key(PK; "SAR No.", "SAR Line No.")
        {
            Clustered = true;
        }
    }
}