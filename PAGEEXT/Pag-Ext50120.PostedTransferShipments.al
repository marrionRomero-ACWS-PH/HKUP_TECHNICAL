pageextension 50120 "Posted Transfer Shipments" extends "Posted Transfer Shipments"
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
