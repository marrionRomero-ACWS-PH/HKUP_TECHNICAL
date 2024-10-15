tableextension 50107 "Customer Discount Groups" extends "Customer Discount Group"
{
    fields
    {
        field(50100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = ToBeClassified;

        }
        field(50102; Title; Option)
        {
            Caption = 'Title';
            DataClassification = ToBeClassified;
            OptionMembers = HKUP,Distributed;
        }
        field(50103; "Discount %"; Integer)
        {
            Caption = 'Discount %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
    }
    keys
    {
        key(PK; "Customer No.", "Line No.")
        {
        }
    }
}
