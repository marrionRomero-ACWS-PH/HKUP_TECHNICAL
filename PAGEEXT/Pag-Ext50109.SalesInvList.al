pageextension 50110 "Sales Inv. List" extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                ApplicationArea = all;
            }
        }
    }
}