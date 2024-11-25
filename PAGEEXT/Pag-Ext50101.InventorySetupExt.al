pageextension 50101 "Inventory Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addfirst(Numbering)
        {
            field("SAR NO."; Rec."SAR NO.")
            {
                ApplicationArea = all;
            }
        }
    }
}
