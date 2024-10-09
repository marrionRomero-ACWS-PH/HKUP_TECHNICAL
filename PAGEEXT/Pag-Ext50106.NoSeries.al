pageextension 50106 "No Series" extends "No. Series"
{
    layout
    {
        addafter(Implementation)
        {

            field("Ebook"; Rec.Ebook)
            {
                Caption = 'Ebook';
                ApplicationArea = all;
            }
        }
    }
}