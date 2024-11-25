pageextension 50109 "Item Commission" extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Item Commission")
            {
                ApplicationArea = all;
                Caption = 'Item Commission';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Item Commission";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
}
