pageextension 50122 "Posted Transfer Shpt. Subform" extends "Posted Transfer Shpt. Subform"
{
    layout
    {
        addlast(content)
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
