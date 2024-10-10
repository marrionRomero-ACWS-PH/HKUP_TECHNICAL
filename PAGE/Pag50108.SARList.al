page 50108 "SAR List"
{
    PageType = List;
    SourceTable = "SAR Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'SAR List';
    CardPageID = "SAR Card";
    PromotedActionCategories = 'New,Process,Report,New Document,Vendor,Navigate';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SAR No."; Rec."SAR No.")
                {
                    ShowMandatory = true;
                }
                field("Item No."; Rec."Item No.")
                {
                    ShowMandatory = true;
                }
                field("Date"; Rec."Date")
                {
                    ShowMandatory = true;
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
