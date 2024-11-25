pageextension 50116 "Transfer Order" extends "Transfer Order"
{
    layout
    {

        addafter("No.")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;

            }
            field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
            {

                ApplicationArea = All;
                Caption = 'Contact';
            }
        }
    }
}

