table 50103 Author
{
    Caption = 'Author';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Author No."; Code[20])
        {
            Caption = 'Author No.';
            TableRelation = "No. Series".Code;
        }
        field(2; "Author Name"; Text[100])
        {
            Caption = 'Author Name';
        }
        field(3; Recipient; Code[20])
        {
            Caption = 'Recipient';
            TableRelation = Vendor WHERE(Type = FILTER(Recipient));
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
    }
    keys
    {
        key(PK; "Author No.")
        {
            Clustered = true;
        }
    }
}
