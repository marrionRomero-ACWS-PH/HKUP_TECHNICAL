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
                    // DrillDown = true;
                    // DrillDownPageId = "SAR List";
                }
                field("Item No."; Rec."Item No.")
                {

                    ApplicationArea = all;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = all;

                }
                field("Average COst"; Rec."Average COst")
                {
                    ApplicationArea = all;
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
