pageextension 50107 VendorCard extends "Vendor Card"
{
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
            Error(' Please select at least one type of vendor (i.e. Supplier/Publisher/ Recipient).');
            exit(false); // Prevents the page from closing
        end;
        exit(true); // Allows the page to close
    end;
}


