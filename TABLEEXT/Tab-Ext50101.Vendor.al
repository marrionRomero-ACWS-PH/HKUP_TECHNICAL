tableextension 50101 Vendor extends Vendor
{
    fields
    {
        field(50100; "Type"; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Publisher,Supplier';
            OptionMembers = "Publisher","Supplier";
        }
    }
}
