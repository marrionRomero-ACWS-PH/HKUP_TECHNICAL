pageextension 50119 "Posted Transfer Receipt" extends "Posted Transfer Receipt"
{
    layout
    {
        addafter("No.")
        {
            field("Customer No."; Rec."Sell-To Customer No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Customer Name"; Rec."Sell-To Customer Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
