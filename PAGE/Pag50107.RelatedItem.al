page 50107 "Related Item"
{
    ApplicationArea = All;
    Caption = 'Related Item';
    PageType = List;
    SourceTable = "Related Item";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Related Item No."; Rec."Related Item No.")
                {
                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                    begin
                        // When "Related Item No." is selected, auto-fill "Related Item Description" and "Item Description"
                        if ItemRec.Get(Rec."Related Item No.") then begin
                            Rec."Item Description" := ItemRec.Description;
                            Rec."Related Item Description" := ItemRec.Description;
                        end;
                    end;
                }
                field("Related Item Description"; Rec."Related Item Description")
                {
                }
            }
        }
    }
}
