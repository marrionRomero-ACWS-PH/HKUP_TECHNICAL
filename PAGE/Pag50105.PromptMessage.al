page 50105 "Prompt Message"
{
    ApplicationArea = All;
    Caption = 'Prompt Message';
    PageType = NavigatePage;
    SourceTable = Vendor;

    trigger OnNextRecord(Steps: Integer): Integer

    begin
        if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
            Error(' Please select at least one type of vendor (i.e. Supplier/Publisher/ Recipient).');
            exit(1); // Prevents the page from closing
            exit(-1); // Prevents the page from closing
        end;
        exit(Steps); // Allows the page to close
    end;

    // Handle the "Next" button navigation
    // trigger OnNextRecord(Steps: Integer): Integer
    // begin
    //     if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
    //         Error('Please select at least one type of vendor (i.e. Supplier/Publisher/Recipient).');
    //         exit(0); // Prevent navigation

    //     end;
    //     exit(Steps); // Allow navigation
    // end;

    // // Handle the "Previous" button navigation
    // trigger OnPreviousRecord(Steps: Integer): Integer
    // begin
    //     if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
    //         Error('Please select at least one type of vendor (i.e. Supplier/Publisher/Recipient).');
    //         exit(0); // Prevent navigation
    //     end;
    //     exit(Steps); // Allow navigation
    // end;



}
