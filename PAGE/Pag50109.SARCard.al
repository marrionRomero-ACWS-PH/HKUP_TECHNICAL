page 50109 "SAR Card"
{
    ApplicationArea = All;
    Caption = 'SAR Card';
    PageType = Card;
    SourceTable = "SAR Header";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("SAR No."; Rec."SAR No.")
                {
                    ShowMandatory = true;
                    DrillDown = true;
                    DrillDownPageId = "SAR List";
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
            part("SAR Lines"; "SAR Line")
            {
                ApplicationArea = all;
                SubPageLink = "SAR No." = FIELD("SAR No.");
            }
        }
    }
}
