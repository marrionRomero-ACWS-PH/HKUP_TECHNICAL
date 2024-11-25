pageextension 50126 "Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addafter(Corrective)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                ApplicationArea = all;
            }
        }
    }
}
