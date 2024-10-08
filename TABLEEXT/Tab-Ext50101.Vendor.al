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
        field(501034; "Restricted Area"; Text[250])
        {
            Caption = 'Restricted Area';
            DataClassification = ToBeClassified;
        }
        field(50105; "Sales Area"; Text[250])
        {
            Caption = 'Sales Area';
            DataClassification = ToBeClassified;
        }
        field(50106; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50107; "ID/Passport No."; Text[100])
        {
            Caption = 'ID/Passport No.';
            DataClassification = ToBeClassified;
        }
        field(50108; "Share Commission"; Text[250])
        {
            Caption = 'Share Commission';
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
