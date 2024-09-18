table 50100 "Series Master"
{
    Caption = 'Series Master';
    LookupPageId = 50100;
    DrillDownPageId = 50100;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Name; Code[50])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}
