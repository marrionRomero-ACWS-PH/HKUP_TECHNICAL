page 50112 "Discount Title Setup Card"
{
    ApplicationArea = All;
    Caption = 'Discount Title Setup Card';
    PageType = Card;
    SourceTable = "Discount Title Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Title; Rec.Title)
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Pub Code"; Rec."Pub Code")
                {
                }
            }
        }
    }
    // actions
    // {
    //     area(processing)
    //     {
    //         action(System)
    //         {
    //             ApplicationArea = all;
    //             Caption = 'Discount Title Setup Card';
    //             RunObject = Page "Discount Title Setup Card";
    //             RunPageLink = Title = field(Title);
    //         }
    //     }
    // }
}
