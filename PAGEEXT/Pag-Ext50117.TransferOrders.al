pageextension 50117 "Transfer Orders" extends "Transfer Orders"
{
    layout
    {
        addafter("No.")
        {
            field("Customer No."; Rec."Sell-To Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; Rec."Sell-To Customer Name")
            {
                ApplicationArea = all;

            }
        }
    }
}
