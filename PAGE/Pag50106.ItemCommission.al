page 50106 "Item Commission"
{
    ApplicationArea = All;
    Caption = 'Item Commission';
    PageType = List;
    SourceTable = "Item Commission";
    UsageCategory = Lists;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Commission Method"; Rec."Commission Method")
                {
                }
                field("Commission %"; Rec."Commission %")
                {
                }
                field("Commission Effective Start Date"; Rec."Commission Start Date")
                {
                    NotBlank = true;
                }
                field("Commission Effective End Date"; Rec."Commission Effective End Date")
                {
                }
            }
        }
    }
}
