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
                    ShowMandatory = true;
                }
                field("SAR Line No."; Rec."SAR Line No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                    Lookup = true;
                    trigger OnValidate()
                    var
                        SAR: Record "SAR Header";
                    begin
                        if SAR.Get(Rec."Item No.") then begin
                            Rec."Item No." := SAR."Item No.";
                        end;
                    end;
                }
                field(Cover; Rec.Cover)
                {

                }
                field(Quantity; Rec.Quantity)
                {

                }
                field(Currency; Rec.Currency)
                {

                }
                field("Currency Factor"; Rec."Currency Factor")
                {

                }
                field(Amount; Rec.Amount)
                {

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {

                }
            }
        }
    }
}
