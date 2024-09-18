pageextension 50100 Item extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Full Title"; Rec."Full Title")
            {
                ApplicationArea = All;
            }

            field("Pub Code"; Rec."Pub Code")
            {
                ApplicationArea = All;
            }
            field(Publisher; Rec.Publisher)
            {
                ApplicationArea = All;

            }
            field(Supplier; Rec.Supplier)
            {
                ApplicationArea = All;

            }
            field(Series; Rec.Series)
            {
                ApplicationArea = All;
                Lookup = true;
                LookupPageId = "Series Master";

            }
            field("Published Date"; Rec."Published Date")
            {
                ApplicationArea = All;
            }
            field("Actual Pages"; Rec."Actual Pages")
            {
                ApplicationArea = All;
            }
            field("Format"; Rec."Format")
            {
                ApplicationArea = All;
                Lookup = true;
                LookupPageId = "Format Master";

            }
            field("Discount (%)"; Rec."Disount (%)")
            {
                ApplicationArea = All;
            }
            field("Warning Level"; Rec."Warning Level")
            {
                ApplicationArea = All;
            }
            field("Restriction"; Rec."Restriction")
            {
                ApplicationArea = All;

            }
            field("Status"; Rec."Status")
            {
                ApplicationArea = All;

            }
            field("Reprint History"; Rec."Reprint History")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

            field("Sales Right"; Rec."Sales Right")
            {
                ApplicationArea = All;
            }
            field("Royalty Method"; Rec."Royalty Method")
            {
                ApplicationArea = All;
            }
            field("Commision Method"; Rec."Commission Method")
            {
                ApplicationArea = All;
            }
            field("Quantity Sold"; Rec."Quantity Sold")
            {
                ApplicationArea = All;
            }
            field("Created On"; Rec."Created On")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}
