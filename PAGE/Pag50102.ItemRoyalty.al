page 50102 "Item Royalty"
{
    ApplicationArea = All;
    Caption = 'Item Royalty';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Item Royalty";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Reached Discount %"; Rec."Reached Discount %")
                {
                }
                field(Number; Rec.Steps)
                {
                }
                field("Percentage %"; Rec."Percentage %")
                {
                }
<<<<<<< HEAD
                field("Exclude Royalty if Unit Cost Exceeds Sales Price"; Rec."Exclude Royalty")
=======
                field("Cost Essential"; Rec."Exclude Royalty if Unit Cost Exceeds Sales Price")
>>>>>>> parent of 372841d (Oct 9, 2024)
                {
                }
            }
        }
    }
}