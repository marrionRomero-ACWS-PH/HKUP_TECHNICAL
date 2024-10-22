pageextension 50103 Customer extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name two"; Rec."Name 2")
            {
                Caption = 'Name 2';
                ApplicationArea = all;
            }
        }
        addlast(General)
        {
            field("Sales Area"; Rec."Sales Area")
            {
                ApplicationArea = All;
            }
            field("Consignment Account  "; Rec."Consignment Account")
            {
                ApplicationArea = All;
            }
            field("Sales Area  "; Rec."Sales Area")
            {
                ApplicationArea = All;
            }
            field("Discount %"; Rec."Discount %")
            {
                ApplicationArea = All;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Author"; Rec."Author No.")
            {
                Lookup = true;
                LookupPageId = "Author List";
                ApplicationArea = All;
                trigger OnValidate()
                var
                    AuthorRec: Record Authors;
                begin
                    if AuthorRec.Get(Rec."Author No.") then begin
                        Rec."Author Name" := AuthorRec."Author Name";
                    end;
                end;
            }
            field("Author Name"; Rec."Author Name")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addLast(processing)
        {
            action("Discount Title Setup")
            {
                ApplicationArea = all;
                Caption = 'Discount Title Setup';
                Image = Discount;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Discount Title Setup List";
                RunPageLink = "Disc. Line No." = field("No.");
            }

            action("Customer Discount Setup")
            {
                ApplicationArea = all;
                Caption = 'Customer Discount Setup';
                Image = Discount;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                RunObject = Page "Customer Discount Setup list";
                RunPageLink = "Customer" = field("No.");
            }
        }
    }
}
