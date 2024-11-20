pageextension 50118 "Posted Transfer Receipts" extends "Posted Transfer Receipts"
{
    layout
    {
        addafter("No.")
        {
            field("Customer No."; Rec."Sell-To Customer No.")
            {
                applicationArea = all;
            }
            field("Customer Name"; Rec."Sell-To Customer Name")
            {
                applicationArea = all;
            }
        }
    }
}
