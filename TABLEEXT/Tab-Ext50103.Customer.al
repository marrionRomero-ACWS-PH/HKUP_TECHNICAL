tableextension 50103 Customer extends Customer
{
    fields
    {
        field(50113; Remarks; Text[500])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50114; "Sales Area"; Text[20])
        {
            Caption = 'Sales Area';
            DataClassification = ToBeClassified;
        }
        field(50115; "Payment Term"; Code[20])
        {
            Caption = 'Payment Term';
            DataClassification = ToBeClassified;
        }
        field(50116; "Consignment A/C"; Boolean)
        {
            Caption = 'Consignment A/C';
            DataClassification = ToBeClassified;
        }

        field(50118; "Author No."; Code[20])
        {
            Caption = 'Author No.';
            DataClassification = ToBeClassified;
            TableRelation = Authors;
        }
        field(50119; "Author Name"; Code[100])
        {
            Caption = 'Author Name';
            DataClassification = ToBeClassified;
        }
        field(50120; "Discount %"; Integer)
        {
            Caption = 'Discount %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }

    }

}
