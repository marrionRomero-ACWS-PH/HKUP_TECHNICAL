page 50105 "Item Author"
{
    ApplicationArea = All;
    Caption = 'Item Author';
    PageType = List;
    UsageCategory = Lists;
    SourceTable = "Item Author";
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;

                }
                field("Author Code"; Rec."Author Code")
                {
                    DrillDown = true;
                    DrillDownPageId = "Author Card";

                    trigger OnValidate()
                    var
                        AuthorRec: Record Authors;
                    begin
                        // When Author No. is selected, auto-fill Author Name
                        if AuthorRec.Get(Rec."Author Code") then begin
                            Rec."Author Name" := AuthorRec."Author Name";
                        end;
                    end;
                }
                field("Author Name"; Rec."Author Name")
                {
                }
                field("Royalty Fee %"; Rec."Royalty Fee %")
                {
                }
            }
        }
    }
}
