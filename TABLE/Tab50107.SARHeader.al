table 50107 "SAR Header"
{
    Caption = 'SAR Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SAR No."; Code[20])
        {
            Caption = 'SAR No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(5; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(6; "Average Cost"; Decimal)
        {
            Caption = 'Average Cost';
        }
    }
    keys
    {
        key(PK; "SAR No.")
        {
            Clustered = true;
        }
    }
}
