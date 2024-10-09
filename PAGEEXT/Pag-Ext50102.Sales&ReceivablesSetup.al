pageextension 50102 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Author No's"; Rec."Author No.'s")
            {
                ApplicationArea = All;
            }
        }
    }
}
