pageextension 50111 "Posted Sales Inv.'s" extends "Posted Sales Invoices"
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
