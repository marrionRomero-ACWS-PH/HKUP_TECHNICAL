pageextension 50101 Royalties extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Royalties")
            {
                ApplicationArea = all;
                Caption = 'Royalty';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page Royalties;
                RunPageLink = "ItemNo." = field("No.");
            }
        }
    }
}


