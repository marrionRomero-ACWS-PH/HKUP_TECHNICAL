page 50104 "Author Card"
{
    PageType = Card;
    SourceTable = Author;
    ApplicationArea = All;
    Caption = 'Author Card';



    layout
    {
        area(Content)
        {
            group(Group)
            {
                Caption = 'General';

                field("Author No."; Rec."Author No.")
                {

                }
                field("Author Name"; Rec."Author Name")
                {
                }
                field("Recipient No."; Rec."Recipient No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
                    begin
                        // When Recipient No. is selected, auto-fill Recipient Name
                        if VendorRec.Get(Rec."Recipient No.") then begin
                            Rec."Recipient Name" := VendorRec.Name;
                        end;
                    end;
                }
                field("Recipient Name"; Rec."Recipient Name")
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
            }
        }
    }
}