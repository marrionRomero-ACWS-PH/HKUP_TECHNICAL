pageextension 50125 "Location List" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
            field("HKUP Warehouse"; Rec."HKUP Warehouse")
            {
                ApplicationArea = all;
            }
            field("Item Discount Tracking"; Rec."Item Discount Tracking")
            {
                ApplicationArea = all;
            }
        }
    }
}
