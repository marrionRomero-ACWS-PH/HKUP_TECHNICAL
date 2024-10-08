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

            field("FEO Code"; Rec."FEO Code")
            {
                ApplicationArea = All;
            }
            field("Print Title"; Rec."Print Title")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field(Publisher; Rec.Publisher)
            {
                ApplicationArea = All;
                ShowMandatory = true;

            }
            field(Supplier; Rec.Supplier)
            {
                ApplicationArea = All;
                ShowMandatory = true;

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
                MultiLine = true;
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
            // field("Commision Method"; Rec."Commission Method")
            // {
            //     ApplicationArea = All;
            // }
            field("CRoyalty Method Calculation Description"; Rec."Royalty Method Calculation Description")
            {
                ApplicationArea = All;
            }
            field("Quantity Sold"; Rec."Quantity Sold")
            {
                ApplicationArea = All;
            }
            field("Parent Item No"; Rec."Parent Item No.")
            {
                ApplicationArea = All;
            }
            field("No. of Authors"; Rec."No. of Authors")
            {
                ApplicationArea = All;
            }
            field("No. of SAR Documents "; Rec."No. of SAR Documents")
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
    trigger OnOpenPage()
    var
        AuthorCalc: Codeunit "Event Procedure";
    begin
        AuthorCalc.CalculateNoOfAuthors(Rec);
    end;

}
