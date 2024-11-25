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
            field("CRoyalty Method Calculation Description"; Rec."Royalty Method Description")
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
<<<<<<< HEAD:PAGEEXT/Pag-Ext50100.ItemCard.al

    }
    actions
    {
        addfirst(processing)
        {
            action("Item Author")
            {
                ApplicationArea = all;
                Caption = 'Item Author';
                Image = LedgerBook;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Item Author";
                RunPageLink = "Item No." = field("No.");
            }
        }

        addafter("Item Author")
        {
            action("Item Royalty")
            {
                ApplicationArea = all;
                Caption = 'Item Royalty';
                Image = ItemLedger;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Item Royalty";
                RunPageLink = "Item No." = field("No.");
            }

            action("Item Commission")
            {
                ApplicationArea = all;
                Caption = 'Item Commission';
                Image = ItemCosts;
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Commission";
                RunPageLink = "Item No." = field("No.");
            }

            action("Related Items")
            {
                ApplicationArea = all;
                Caption = 'Related Items';
                Image = Item;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Related Item";
                RunPageLink = "Item No." = field("No.");
            }

            action("SAR List")
            {
                ApplicationArea = all;
                Caption = 'SAR List';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "SAR List";
                RunPageLink = "SAR No." = field("No.");
            }
        }
=======
>>>>>>> parent of 372841d (Oct 9, 2024):PAGEEXT/Pag-Ext50100.Item.al
    }
}
