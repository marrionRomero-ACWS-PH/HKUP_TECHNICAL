table 50102 Royalty
{
    Caption = 'Royalty';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[50])
        {
            Caption = 'No.';

            // TableRelation = Item."No.";
        }
        field(2; "Reached Discount"; Decimal)
        {
            Caption = 'Reached Discount';
        }
        field(3; "Cost Essential"; Boolean)
        {
            Caption = 'Cost Essential';
        }
        field(4; Steps; Integer)
        {
            Caption = 'Steps';
            // TableRelation = item."Quantity Sold";
        }
        field(5; "Percentage (%)"; Decimal)
        {
            Caption = 'Percentage (%)';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
