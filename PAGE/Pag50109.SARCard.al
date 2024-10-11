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
                    DrillDown = true;
                    ShowMandatory = true;

                    trigger OnAssistEdit()
                    begin

                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Item No."; Rec."Item No.")
                {
                    ShowMandatory = true;
                    Lookup = true;
                    // trigger OnValidate()
                    // var
                    //     SAR: Record "SAR Header";
                    // begin
                    //     if SAR.Get(Rec."Item No.") then begin
                    //         Rec."Item No." := SAR."Item No.";
                    //     end;
                    // end;

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
