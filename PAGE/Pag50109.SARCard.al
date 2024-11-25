page 50109 "SAR Card"
{
    ApplicationArea = All;
    Caption = 'SAR Card';
    PageType = Card;
<<<<<<< HEAD
    SourceTable = "SAR Header";

=======
    SourceTable = "SAR Line";
    AutoSplitKey = true;
>>>>>>> parent of 372841d (Oct 9, 2024)

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
<<<<<<< HEAD
                    DrillDown = true;
                    DrillDownPageId = "SAR List";
=======
                }
                field("SAR Line No."; Rec."SAR Line No.")
                {

>>>>>>> parent of 372841d (Oct 9, 2024)
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
<<<<<<< HEAD
            }
            part("SAR Lines"; "SAR Line")
            {
                ApplicationArea = all;
                SubPageLink = "SAR No." = FIELD("SAR No.");
=======
>>>>>>> parent of 372841d (Oct 9, 2024)
            }
        }
    }
}
