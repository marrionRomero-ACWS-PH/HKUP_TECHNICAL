page 50108 "SAR List"
{
    ApplicationArea = All;
    Caption = 'SAR List';
    PageType = List;
    SourceTable = "SAR Header";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field("SAR No."; Rec."SAR No.")
                {
<<<<<<< HEAD
                    // ShowMandatory = true;
=======
                    DrillDown = true;
                    ShowMandatory = true;
                    // DrillDownPageId = "SAR List";

                    trigger OnDrillDown()
                    var
                        Cust: Record "SAR Header";
                    begin
                        Cust.Get(Rec."SAR No.");
                        Page.Run(Page::"SAR List", Cust);
                    end;
>>>>>>> parent of 372841d (Oct 9, 2024)
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
