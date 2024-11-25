pageextension 50103 "Author No.'s" extends "Purchases & Payables Setup"
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
