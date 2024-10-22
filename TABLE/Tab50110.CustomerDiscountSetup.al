table 50110 "Customer Discount Setup"
{
    Caption = 'Customer Discount Setup';
    DataClassification = ToBeClassified;
    DrillDownPageID = "Customer Discount Setup list";
    LookupPageID = "Customer Discount Setup list";



    fields
    {
        field(1; Customer; Code[20])
        {
            Caption = 'Customer';
            TableRelation = Customer."No.";
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Title; Text[20])
        {
            Caption = 'Title';
            // FieldClass = FlowField;
            // CalcFormula = Lookup("Discount Title Setup"."Disc. Line No." WHERE(Title = Field(Title)));
            TableRelation = "Discount Title Setup".Title;
            // TableRelation = "Discount Title Setup"."Line No." Where(Title = field(Title));
        }
        field(4; "Percentage %"; Decimal)
        {
            Caption = 'Percentage %';
            MinValue = 0;
            MaxValue = 100;
        }

    }
    keys
    {
        key(PK; Customer, "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(Dropdown; "Line No.", Title)
        {
        }
    }
}