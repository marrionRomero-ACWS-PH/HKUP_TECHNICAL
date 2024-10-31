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
            field("PUB Code"; Rec."Pub Code")
            {
                Caption = 'Pub Code';
                ApplicationArea = all;
                Editable = false;
            }
        }
    }
}
