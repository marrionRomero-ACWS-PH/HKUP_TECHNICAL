pageextension 50112 "Posted Sales Invoice" extends "Posted Sales Invoice"
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
