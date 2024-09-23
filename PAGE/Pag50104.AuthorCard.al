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
    // trigger OnOpenPage()
    // var
    //     PurchSetup: Record "Purchases & Payables Setup";
    //     NoSeriesMgt: Codeunit "No. Series";
    // begin
    //     // Check if Author No. is empty when the page opens
    //     if Rec."Author No." = '' then begin
    //         PurchSetup.Get();
    //         if PurchSetup."Author No.'s" = '' then
    //             Error('No Author Number Series is set up in Purchase & Payables Setup.');

    //         // Generate the next available Author No. and assign it
    //         Rec."Author No." := NoSeriesMgt.GetNextNo(PurchSetup."Author No.'s", WorkDate, true);
    //         // Modify(true); // Save the new Author No.
    //     end;
    // end;
    // procedure AssistEdit(OldAuth: Record Author): Boolean 
    // var
    //     Auth: Record Author;
    //     PurchSetup: Record "Purchases & Payables Setup";
    //     NoSeries: Codeunit "No. Series";

    // begin
    //     Auth := Rec;
    //     PurchSetup.Get();
    //     PurchSetup.TestField("Author No.'s");
    //     if NoSeries.LookupRelatedNoSeries(PurchSetup."Author No.'s", OldAuth."Author No.", Auth."Author No.") then begin
    //         Auth."Author No." := NoSeries.GetNextNo(Auth."Author No.");
    //         Rec := Auth;
    //         OnAssistEditOnBeforeExit(Rec);
    //         exit(true);
    //     end;
    // end;


    // [IntegrationEvent(false, false)]
    // local procedure OnAssistEditOnBeforeExit(var Author: Record Author)
    // begin
    // end;
}