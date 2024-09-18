page 50103 Author
{
    ApplicationArea = All;
    Caption = 'Author';
    PageType = List;
    SourceTable = Author;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Author No."; Rec."Author No.")
                {
                    ApplicationArea = All;
                }
                field("Author Name"; Rec."Author Name")
                {
                    ApplicationArea = All;
                }
                field(Recipient; Rec.Recipient)
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
