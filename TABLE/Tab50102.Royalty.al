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
        field(4; Steps; Code[20])
        {
            Caption = 'Steps';
        }
        field(5; "Percentage (%)"; Decimal)
        {
            Caption = 'Percentage (%)';
        }
        field(6; "Number"; Integer)
        {
            Caption = 'Number';
        }
    }
    keys
    {
        key(PK; "ItemNo.", Steps)
        {
            Clustered = true;
        }
    }

}


