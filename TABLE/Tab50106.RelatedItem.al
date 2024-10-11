table 50106 "Related Item"
{
    Caption = 'Related Item';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Related Item No."; Code[20])
        {
            Caption = 'Related Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Item Description"; Text[250])
        {
            Caption = 'Item Description';
        }
        field(4; "Related Item Description"; Text[250])
        {
            Caption = 'Related Item Description';
        }
    }
    keys
    {
        key(PK; "Item No.", "Related Item No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {

    }
}
