pageextension 50111 "Related Items" extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Related Item")
            {
                ApplicationArea = all;
                Caption = 'Related Item';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Related Item";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
}
