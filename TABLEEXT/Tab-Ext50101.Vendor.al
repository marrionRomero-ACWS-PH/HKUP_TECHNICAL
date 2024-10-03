tableextension 50101 Vendor extends Vendor
{
    fields
    {
        field(50101; Publisher; Boolean)
        {
            Caption = 'Publisher';
            DataClassification = ToBeClassified;

        }
        field(50102; Supplier; Boolean)
        {
            Caption = 'Supplier';
            DataClassification = ToBeClassified;
        }
        field(50103; Recipient; Boolean)
        {
            Caption = 'Recipient';
            DataClassification = ToBeClassified;
        }
    }

    // local procedure ValidateVendorTypes(): Boolean
    // begin
    //     if not Rec."Publisher" and not Rec."Supplier" and not Rec."Recipient" then begin
    //         Error('Please select at least one type of vendor (i.e. Supplier/Publisher/Recipient).');
    //         exit(false);
    //     end;
    //     exit(true);
    // end;
}
