pageextension 50119 "Posted Transfer Receipt" extends "Posted Transfer Receipt"
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
