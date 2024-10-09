tableextension 50108 Locations extends Location
{
    fields
    {
        field(50100; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "HKUP Warehouse"; Boolean)
        {
            Caption = 'HKUP Warehouse';
            DataClassification = ToBeClassified;
        }
        field(50102; "Item Discount Tracking"; Boolean)
        {
            Caption = 'Item Discount Tracking';
            DataClassification = ToBeClassified;
        }
    }
}
