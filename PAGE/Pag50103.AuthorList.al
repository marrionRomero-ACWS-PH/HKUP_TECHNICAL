page 50103 Author
{
    PageType = List;
    SourceTable = Author;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Author';
    CardPageID = "Author Card";
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,New Document,Vendor,Navigate';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Author No."; Rec."Author No.")
                {
                    ApplicationArea = All;
                }
                field("Author Name"; Rec."Author Name")
                {
                    ApplicationArea = All;
                }
                field("Recipient No.s"; Rec."Recipient No.")
                {
                    ApplicationArea = All;
                }
                field("Recipient Name"; Rec."Recipient Name")
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
