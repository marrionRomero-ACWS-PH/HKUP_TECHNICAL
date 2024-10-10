tableextension 50110 "Sales Inv. Header" extends "Sales Invoice Header"
{
    fields
    {
        field(50100; "Gratis Invoice"; Boolean)
        {
            Caption = 'Gratis Invoice';
            DataClassification = ToBeClassified;
        }
        field(50101; "Consignment Invoice"; Boolean)
        {
            Caption = 'Consignment Invoice';
            DataClassification = ToBeClassified;
        }
        field(50102; Ebook; Boolean)
        {
            Caption = 'Ebook';
            DataClassification = ToBeClassified;
        }
        field(50103; "Item Discount Tracking"; Boolean)
        {
            Caption = 'Item Discount Tracking';
            DataClassification = ToBeClassified;
        }
    }
}
