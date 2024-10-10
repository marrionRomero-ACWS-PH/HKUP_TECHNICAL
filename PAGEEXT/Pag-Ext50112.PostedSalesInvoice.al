pageextension 50112 "Posted Sales Invoice" extends "Posted Sales Invoice"
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
