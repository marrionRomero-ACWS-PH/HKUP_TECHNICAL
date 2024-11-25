pageextension 50126 "Transfer Orders Extension" extends "Transfer orders"
{
    layout
    {
        addafter("No.")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = all;
            }
            field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
            {
                ApplicationArea = all;
            }
        }
    }
}
