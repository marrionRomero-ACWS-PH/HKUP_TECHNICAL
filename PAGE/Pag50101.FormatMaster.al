page 50101 "Format Master"
{
    ApplicationArea = All;
    Caption = 'Format Master';
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
