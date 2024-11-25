page 50108 "SAR List"
{
    ApplicationArea = All;
    Caption = 'SAR List';
    PageType = List;
    SourceTable = "SAR Header";
    UsageCategory = Lists;
    CardPageID = "SAR Card";
    PromotedActionCategories = 'New,Process,Report,New Document,Vendor,Navigate';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("SAR No."; Rec."SAR No.")
                {
                    // ShowMandatory = true;
                }
                field("Item No."; Rec."Item No.")
                {
                    // ShowMandatory = true;
                }
                field("Date"; Rec."Date")
                {
                    // ShowMandatory = true;
                }
                field(Quantity; Rec.Quantity)
                {

                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Average Cost"; Rec."Average Cost")
                {
                }
            }
        }
    }
}
