table 50109 "Discount Title Setup"
{
    Caption = 'Discount Title Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Title; Text[50])
        {
            Caption = 'Title';
        }
        field(2; "Pub Code"; Option)
        {
            Caption = 'Pub Code';
            OptionMembers = "A - Academic Title","C - Commission Title","G - General Title","X - Agency Title","Q – Ebook","S – Service Charge";
        }
    }
    keys
    {
        key(PK; Title)
        {
            Clustered = true;
        }
    }
}


