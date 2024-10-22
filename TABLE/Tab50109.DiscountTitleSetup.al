table 50109 "Discount Title Setup"
{
    Caption = 'Discount Title Setup';
    LookupPageId = "Discount Title Setup List";
    DrillDownPageId = "Discount Title Setup List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            TableRelation = "Customer Discount Setup"."Line No.";

        }
        field(2; "Disc. Line No."; Code[20])
        {
            Caption = 'Line No.';
        }
        field(3; Title; Text[20])
        {
            Caption = 'Title';
        }
        field(4; "Pub Code"; Option)
        {
            Caption = 'Pub Code';
            OptionMembers = "","A - Academic Title","C - Commission Title","G - General Title","X - Agency Title","Q – Ebook","S – Service Charge";
        }
    }
    keys
    {
        key(PK; "Line No.", Title)//"Disc. Line No." 
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        Fieldgroup(Dropdown; Title, "Pub Code") // Display both fields in the lookup
        {
        }
    }
}


