pageextension 50104 Customer extends "Customer Card"
{
    layout
    {
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
            field("Consignment A/C  "; Rec."Consignment A/C")
            {
                ApplicationArea = All;

            }
            field("Author No."; Rec."Author No.")
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
    var
        myInt: Integer;
}
