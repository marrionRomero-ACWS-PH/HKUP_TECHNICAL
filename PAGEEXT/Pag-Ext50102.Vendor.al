pageextension 50102 Vendor extends "Vendor Card"

{
    layout
    {
        addlast(General)
        {

            field(Publisher; Rec.Publisher)
            {
                ApplicationArea = All;
            }
            field(Supplier; Rec.Supplier)
            {
                ApplicationArea = All;
            }

            field(Recipient; Rec.Recipient)
            {
                ApplicationArea = All;
            }
        }
    }




    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
            Error(' Please select at least one type of vendor (i.e. Supplier/Publisher/ Recipient).');
            exit(false); // Prevents the page from closing
        end;
       
        exit(true); // Allows the page to close
    end;

}

    

