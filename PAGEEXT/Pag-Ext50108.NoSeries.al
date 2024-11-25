pageextension 50108 NoSeries extends "No. Series"
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