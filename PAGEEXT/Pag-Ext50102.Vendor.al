pageextension 50102 Vendor extends "Vendor Card"

{
    layout
    {
        addlast(General)
        {
            field("Type"; Rec.Type)
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;

}
