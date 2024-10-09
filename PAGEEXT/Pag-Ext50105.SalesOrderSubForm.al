pageextension 50105 "Sales Line" extends "Sales Order Subform"
{
    layout
    {
        modify(Description)
        {
            // Insert Pub Code after Description
            ApplicationArea = All;
            Editable = false;
        }
        addafter(Description)
        {
            field("FEO Code"; Rec."FEO Code")
            {
                Caption = 'FEO Code';
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
