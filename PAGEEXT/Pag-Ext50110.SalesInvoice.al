pageextension 50110 "Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                ApplicationArea = all;
            }
        }
    }
}
