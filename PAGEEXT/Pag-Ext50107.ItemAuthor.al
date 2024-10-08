pageextension 50107 "Item Author" extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("Item Author")
            {
                ApplicationArea = all;
                Caption = 'Item Author';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Item Author";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
}
