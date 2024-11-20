pageextension 50115 "Posted Transfer Rcpt. Subform" extends "Posted Transfer Rcpt. Subform"
{
    layout
    {
        addafter("Item No.")
        {
            field("List Price"; Rec."List Price")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
            field("Discount %"; Rec."Discount %")
            {
                ApplicationArea = all;
            }
            field("Currency"; Rec."Currency")
            {
                ApplicationArea = all;
                DrillDown = true;
                DrillDownPageId = Currencies;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
            field("Amount"; Rec."Amount")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
            field("Amount (LCY)"; Rec."Amount (LCY)")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
        }
    }
}
