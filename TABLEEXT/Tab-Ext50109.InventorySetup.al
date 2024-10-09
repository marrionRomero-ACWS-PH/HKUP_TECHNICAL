tableextension 50109 "Inventory Setup" extends "Inventory Setup"
{
    fields
    {
        field(50100; "SAR No."; Code[20])
        {
            Caption = 'SAR No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
