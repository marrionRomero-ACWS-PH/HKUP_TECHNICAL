page 50101 "Format Master"
{
    ApplicationArea = All;
    Caption = 'Format Master';
    PageType = List;
    SourceTable = "Format Master";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
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
