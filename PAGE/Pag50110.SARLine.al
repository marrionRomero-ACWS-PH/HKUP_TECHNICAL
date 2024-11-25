page 50110 "SAR Line"
{
    ApplicationArea = All;
    Caption = 'SAR Line';
    PageType = ListPart;
    SourceTable = "SAR Line";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SAR No."; Rec."SAR No.")
                {
                    Visible = false;
                }
                field("SAR Line No."; Rec."SAR Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Cover; Rec.Cover)
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;

                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;

                }
                field("Currency Factor"; Rec."Currency Factor")
                {
                    ApplicationArea = All;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
}
