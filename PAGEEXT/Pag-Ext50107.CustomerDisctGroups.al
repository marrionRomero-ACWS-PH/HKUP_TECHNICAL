pageextension 50107 "Customer Discount Groups" extends "Customer Disc. Groups"
{
    layout
    {
        addlast(content)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = All;
            }
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Title"; Rec."Title")
            {
                ApplicationArea = All;
            }
            field("Discount %"; Rec."Discount %")
            {
                ApplicationArea = All;
            }
        }
    }

}
