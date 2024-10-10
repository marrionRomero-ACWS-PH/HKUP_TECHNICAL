pageextension 50110 "Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addlast(content)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                ApplicationArea = all;
            }
        }
    }
}
