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

                }
                field(Cover; Rec.Cover)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                }
                field(Currency; Rec.Currency)
                {
                    TableRelation = Currency;
                }
                field("Currency Factor"; Rec."Currency Factor")
                {

                }
                field(Amount; Rec.Amount)
                {
                    BlankZero = true;

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    BlankZero = true;

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
