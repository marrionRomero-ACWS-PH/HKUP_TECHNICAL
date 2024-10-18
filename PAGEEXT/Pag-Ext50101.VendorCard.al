pageextension 50101 Vendor extends "Vendor Card"

{
    layout
    {
        addafter(Name)
        {
            field("Name2";Rec."Name 2")
            {
            ApplicationArea=all;
            }
        }
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
            field("Vendor Type";Rec."Vendor Type") 
            {
                ApplicationArea=all;
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

    

