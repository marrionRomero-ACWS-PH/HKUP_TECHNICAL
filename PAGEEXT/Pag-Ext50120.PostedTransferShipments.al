pageextension 50120 "Posted Transfer Shipments" extends "Posted Transfer Shipments"
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
