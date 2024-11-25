tableextension 50102 "Author No.'s" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "Author No.'s"; Code[20])
        {
            Caption = 'Author Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
