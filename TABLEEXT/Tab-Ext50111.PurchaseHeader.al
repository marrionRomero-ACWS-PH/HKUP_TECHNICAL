tableextension 50111 "Purchase Header" extends "Purchase Header"
{
    fields
    {
        field(50100; "Receipt No."; Text[50])
        {
            Caption = 'Receipt No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "Invoice Type"; Option)
        {
            Caption = 'Invoice Type';
            OptionMembers = "Letter to Share Incomed","Subsidiary Rights Expense or Other Expense","Royalty and Commission";
            DataClassification = ToBeClassified;
        }

    }
}
