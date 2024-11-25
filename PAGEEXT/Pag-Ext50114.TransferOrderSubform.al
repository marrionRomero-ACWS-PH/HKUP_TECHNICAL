pageextension 50114 "Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Pub Code"; Rec."Pub Code")
            {
                ApplicationArea = all;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
            field("Line Discount"; Rec."Line Discount %")
            {
                ApplicationArea = all;
            }

            field("Line Amount"; Rec."Line Amount")
            {
                ApplicationArea = all;
                BlankZero = true;
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = all;
            }
        }
    }
}
