page 50100 "Series Master"
{
    ApplicationArea = All;
    Caption = 'Series Master';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Series Master";

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}