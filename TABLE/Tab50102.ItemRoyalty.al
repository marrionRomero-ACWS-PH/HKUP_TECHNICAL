table 50102 "Item Royalty"
{
    Caption = 'Item Royalty';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(2; "Reached Discount %"; Decimal)
        {
            Caption = 'Reached Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(3; "Exclude Royalty if Unit Cost Exceeds Sales Price"; Boolean)
        {
            Caption = 'Exclude Royalty if Unit Cost Exceeds Sales Price';
        }
        field(4; "Line No."; Code[20])
        {
            Caption = 'Line No.';
        }
        field(5; "Percentage %"; Decimal)
        {
            Caption = 'Percentage %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(6; Steps; Integer)
        {
            Caption = 'Steps';
            MinValue = 1;
        }
    }
    keys
    {
        key(PK; "Item No.", "Line No.")
        {
            Clustered = true;
        }
    }

}


