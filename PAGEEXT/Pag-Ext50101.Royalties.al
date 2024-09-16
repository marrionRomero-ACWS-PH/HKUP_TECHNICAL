pageextension 50101 Royalties extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Royalties")
            {
                ApplicationArea = all;
                Caption = 'Royalties';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Royalties: Page Royalties;
                // QtySold: Integer;
                // Percentage: Decimal;
                // Steps: Record Royalty;

                begin
                    // QtySold := Rec."Quantity Sold";
                    // if QtySold <= 500 then
                    //     Percentage := 0
                    // else
                    //     Percentage := 5;
                    // // Royalties.SetRecord(rec);
                    // // Royalties.SetParameters(Rec."No.", Percentage);
                    // Royalties.Run();

                    // if Steps.FindSet() then
                    //     repeat
                    //         if Steps.Steps >= 501 then
                    //             steps."Percentage (%)" := 5
                    //         else
                    //             Steps."Percentage (%)" := 0;
                    //         steps.Modify();
                    //     until Steps.Next() = 0;
                    Royalties.Run();

                end;
            }
        }


    }

}


