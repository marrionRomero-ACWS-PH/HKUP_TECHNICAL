pageextension 50104 Customer extends "Customer Card"
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
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Sales Area"; Rec."Sales Area")
            {
                ApplicationArea = All;
            }
            field("Consignment A/C  "; Rec."Consignment Account")
            {
                ApplicationArea = All;
            }
            field("Author No."; Rec."Author")
            {
                Lookup = true;
                LookupPageId = "Author List";
                ApplicationArea = All;
                trigger OnValidate()
                var
                    AuthorRec: Record Authors;
                begin
                    if AuthorRec.Get(Rec."Author") then begin
                        Rec."Author Name" := AuthorRec."Author Name";
                        Rec."Author Address" := AuthorRec.Address;
                        Rec."Author Address 2" := AuthorRec."Address 2";
                    end;
                end;
            }
            field("Author name"; Rec."Author Name")
            {
                ApplicationArea = All;
            }
            field("Discount %"; Rec."Discount %")
            {
                ApplicationArea = All;
            }
        }
    }
}
