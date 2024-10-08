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
            field("Full Name"; Rec."Name")
            {
                Caption='Full Name';
                ShowMandatory=true;
                ApplicationArea = All;
            }
            field("Sales Area"; Rec."Sales Area")
            {
                ApplicationArea = All;
            }
            field("Restricted Area"; Rec."Restricted Area")
            {
                ApplicationArea = All;
            }
            field("Remarks"; Rec."Remarks")
            {
                MultiLine=true;
                ApplicationArea = All;
            }
            field("ID/Passport No."; Rec."ID/Passport No.")
            {
                ApplicationArea = All;
                ExtendedDatatype=Masked;
            }   
        }
    }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin;
        if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
            Error(' The Vendor Type (Supplier, Publisher, Recipient) has not been assigned to the current vendor yet. Do you confirm close the page without the setting?.');
            exit(false); // Prevents the page from closing
        end;
       
        exit(true); // Allows the page to close
    end;

    

}

    

