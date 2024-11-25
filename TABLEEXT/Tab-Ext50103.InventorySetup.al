tableextension 50118 "Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50100; "SAR NO."; Code[20])
        {
            Caption = 'SAR NO.';
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
        }
    }
}
