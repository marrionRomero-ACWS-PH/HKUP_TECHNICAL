pageextension 50112 "SAR List" extends "Item Card"
{
    actions
    {
        addfirst(processing)
        {
            action("SAR List")
            {
                ApplicationArea = all;
                Caption = 'SAR List';
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "SAR List";
                RunPageLink = "SAR No." = field("No.");
            }
        }
    }
}
