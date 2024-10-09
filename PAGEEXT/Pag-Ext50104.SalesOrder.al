pageextension 50104 "Sales Order" extends "Sales Order"
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