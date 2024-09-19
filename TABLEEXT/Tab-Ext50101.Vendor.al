tableextension 50101 Vendor extends Vendor
{
    fields
    {
        field(50100; "Type"; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Publisher,Supplier,Recipient';
            OptionMembers = "Publisher","Supplier","Recipient";
        }
        // field(50101; Publisher; Boolean)
        // {
        //     Caption = 'Publisher';
        //     DataClassification = ToBeClassified;

        // }
        // field(50102; Supplier; Boolean)
        // {
        //     Caption = 'Supplier';
        //     DataClassification = ToBeClassified;

        // }
        // field(50103; Recipient; Boolean)
        // {
        //     Caption = 'Recipient';
        //     DataClassification = ToBeClassified;

        // }
    }
}
