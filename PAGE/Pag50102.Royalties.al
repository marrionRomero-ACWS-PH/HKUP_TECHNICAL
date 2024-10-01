page 50102 Royalties
{
    ApplicationArea = All;
    Caption = 'Royalty';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Royalty;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("ItemNo."; Rec."ItemNo.")
                {
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                }
                field("Reached Discount"; Rec."Reached Discount")
                {
                }
                field("Cost Essential"; Rec."Cost Essential")
                {
                }
                field(Number; Rec.Steps)
                {
                }
                field("Percentage (%)"; Rec."Percentage (%)")
                {

                }
            }
        }
    }
}