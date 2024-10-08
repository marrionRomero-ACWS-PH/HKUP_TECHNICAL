pageextension 50101 Royalties extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Item Royalty")
            {
                ApplicationArea = all;
                Caption = 'Item Royalty';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Item Royalty";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
}


