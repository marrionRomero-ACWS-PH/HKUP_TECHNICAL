tableextension 50106 "No. Series Extension" extends "No. Series"
{
    fields
    {
        field(50100; Ebook; Boolean)
        {
            Caption = 'Ebook';
            DataClassification = ToBeClassified;
        }
        field(50101; "Consignment(Distributor)"; Boolean)
        {
            Caption = 'Consignment (Distributor)';
            DataClassification = ToBeClassified;
        }
    }
}
