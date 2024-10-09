page 50101 "Item Format"
{
    ApplicationArea = All;
    Caption = 'Item Format';
    PageType = List;
    SourceTable = "Item Format";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
