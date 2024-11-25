tableextension 50115 "Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50100; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatExpression = 'Currency Code';
            AutoFormatType = 2;
        }
        field(50101; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
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
