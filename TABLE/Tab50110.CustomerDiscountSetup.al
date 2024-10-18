table 50110 "Customer Discount Setup"
{
    Caption = 'Customer Discount Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Customer; Integer)
        {
            Caption = 'Customer';
            TableRelation = Customer;
        }
        field(2; Title; Text[50])
        {
            Caption = 'Title';
            TableRelation = "Discount Title Setup".Title;
        }
        field(3; "Percentage %"; Decimal)
        {
            Caption = 'Percentage %';
        }
    }
    keys
    {
        key(PK; Customer)
        {
            Clustered = true;
        }
    }
}
