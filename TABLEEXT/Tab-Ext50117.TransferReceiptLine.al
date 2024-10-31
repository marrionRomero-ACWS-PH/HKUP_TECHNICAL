tableextension 50117 "Transfer Receipt Line" extends "Transfer Receipt Line"
{
    fields
    {
        field(50100; "List Price"; Decimal)
        {
            Caption = 'List Price';
            DataClassification = ToBeClassified;
        }
        field(50101; "Discount %"; Decimal)
        {
            Caption = 'Discount %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
        field(50102; Currency; Code[20])
        {
            Caption = 'Currency';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50103; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
        }
        field(50104; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(50105; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
            DataClassification = ToBeClassified;
        }
        field(50106; "Your Reference"; Text[250])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
    }
}
