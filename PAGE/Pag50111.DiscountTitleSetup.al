page 50111 "Discount Title Setup List"
{
    ApplicationArea = All;
    Caption = 'Discount Title Setup';
    PageType = List;
    SourceTable = "Discount Title Setup";
    UsageCategory = Lists;
    // CardPageID = "Discount Title Setup Card";
    // PromotedActionCategories = 'New,Process,Report,New Document,Vendor,Navigate';
    RefreshOnActivate = true;
    // AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Title; Rec.Title)
                {
                    ApplicationArea = All;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Pub Code"; Rec."Pub Code")
                {
                    ApplicationArea = All;
                }
                field("Disc. Line No."; Rec."Disc. Line No.")
                {
                    Visible = false;
                }
            }
        }

    }
}
