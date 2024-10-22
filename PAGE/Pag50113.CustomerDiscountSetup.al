page 50113 "Customer Discount Setup list"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Customer Discount Setup';
    PageType = List;
    SourceTable = "Customer Discount Setup";
    UsageCategory = Lists;
    // CardPageId = "Customer Discount Setup Card";
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Customer; Rec.Customer)
                {
                }
                field(Title; Rec.Title)
                {
                }
                field("Percentage %"; Rec."Percentage %")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
            }
        }
    }
}
