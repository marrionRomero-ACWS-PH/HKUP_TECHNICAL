pageextension 50105 "SalesOrder-GratisInvoice" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                Caption = 'Gratis Invoice';
                ApplicationArea = all;
            }
        }
    }
}