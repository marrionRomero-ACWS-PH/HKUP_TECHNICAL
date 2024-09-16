page 50102 Royalties
{
    ApplicationArea = All;
    Caption = 'Royalties';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Royalty;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("No."; Rec."No.")
                {
                }
                field(Steps; Rec.Steps)
                {

                }
                field("Reached Discount"; Rec."Reached Discount")
                {

                }
                field("Cost Essential"; Rec."Cost Essential")
                {

                }
                field("Percentage (%)"; Rec."Percentage (%)")
                {

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Percentage")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    Steps: Record Royalty;

                begin
                    if Steps.FindSet() then
                        repeat
                            if Steps.Steps > 501 then
                                steps."Percentage (%)" := 5
                            else
                                Steps."Percentage (%)" := 0;
                            steps.Modify();
                        until Steps.Next() = 0;
                end;
            }
        }
    }

    // procedure SetParameters(ItemNo: Code[20]; Percentage: Decimal)
    // var
    //     Rec: Record "Royalty"; // Replace with the actual table
    // begin
    //     Rec.Reset();
    //     Rec.SetRange("No.", ItemNo);
    //     Rec.FindFirst();
    //     Rec."Percentage (%)" := Percentage;
    //     Rec.Modify();
    // end;
}