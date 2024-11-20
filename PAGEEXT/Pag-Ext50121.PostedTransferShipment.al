pageextension 50121 "Posted Transfer Shipment" extends "Posted Transfer Shipment"
{
    layout
    {
        addafter("No.")
        {
            field("Sell-To Customer No."; Rec."Sell-To Customer No.")
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
