pageextension 50111 "Customer Discount Groups" extends "Customer Disc. Groups"
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
