table 50101 "Item Format"
{
    Caption = 'Item Format';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[50])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
