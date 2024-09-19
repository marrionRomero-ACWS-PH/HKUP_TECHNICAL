table 50102 Royalty
{
    Caption = 'Royalty';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ItemNo."; Code[50])
        {
            Caption = 'Item No.';
        }
        field(2; "Reached Discount"; Decimal)
        {
            Caption = 'Reached Discount';
        }
        field(3; "Cost Essential"; Boolean)
        {
            Caption = 'Cost Essential';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; "Percentage (%)"; Decimal)
        {
            Caption = 'Percentage (%)';
        }
        field(6; Steps; Integer)
        {
            Caption = 'Steps';
        }
    }
    keys
    {
        key(PK; "ItemNo.", "No.")
        {
            Clustered = true;
        }
    }

}


