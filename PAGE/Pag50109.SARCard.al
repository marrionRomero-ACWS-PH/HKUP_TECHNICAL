page 50109 "SAR Card"
{
    ApplicationArea = All;
    Caption = 'SAR Card';
    PageType = Card;
    SourceTable = "SAR Line";
    AutoSplitKey = true;

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
                }
                field("SAR Line No."; Rec."SAR Line No.")
                {

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
        }
    }
}
