page 50103 "Author List"
{
    PageType = List;
    SourceTable = Authors;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Authors';
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
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Name2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field("Recipient"; Rec."Recipient")
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
