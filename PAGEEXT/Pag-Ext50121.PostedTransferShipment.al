pageextension 50121 "Posted Transfer Shipment" extends "Posted Transfer Shipment"
{
    layout
    {
        addlast(content)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                ApplicationArea = all;
            }
        }
    }
}
