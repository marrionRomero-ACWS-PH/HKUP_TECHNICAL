pageextension 50109 "Sales Inv. List" extends "Sales Invoice List"
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