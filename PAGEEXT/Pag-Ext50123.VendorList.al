pageextension 50123 "Vendor List" extends "Vendor List"
{
    layout
    {
        addafter("Payments (LCY)")
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
            // field("Full Name"; Rec."Name")
            // {
            //     Caption = 'Full Name';
            //     ShowMandatory = true;
            //     ApplicationArea = All;
            // }
            // field("Sales Area"; Rec."Sales Area")
            // {
            //     ApplicationArea = All;
            // }
            // field("Restricted Area"; Rec."Restricted Area")
            // {
            //     ApplicationArea = All;
            // }
            // field("Remarks"; Rec."Remarks")
            // {
            //     MultiLine = true;
            //     ApplicationArea = All;
            // }
            // field("ID/Passport No."; Rec."ID/Passport No.")
            // {
            //     ApplicationArea = All;
            //     ExtendedDatatype = Masked;
            // }
        }
    }
}
