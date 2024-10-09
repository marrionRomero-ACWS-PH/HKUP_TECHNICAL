pageextension 50108 "Inventory List" extends "Inventory Setup"
{
    layout
    {
        addfirst(Numbering)
        {
            field("SAR No."; Rec."SAR No.")
            {
                ApplicationArea = all;

            }
        }
    }
}
