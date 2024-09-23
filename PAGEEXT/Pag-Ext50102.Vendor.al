pageextension 50102 Vendor extends "Vendor Card"

{
    layout
    {
        addlast(General)
        {

            field(Publisher; Rec.Publisher)
            {
                ApplicationArea = All;
            }
            field(Supplier; Rec.Supplier)
            {
                ApplicationArea = All;
            }

            field(Recipient; Rec.Recipient)
            {
                ApplicationArea = All;
            }
        }
    }
    var
        myInt: Integer;

}
