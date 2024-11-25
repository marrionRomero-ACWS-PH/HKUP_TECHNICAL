table 50108 "SAR Line"
{
    Caption = 'SAR Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SAR No."; Code[20])
        {
            Caption = 'SAR No.';
<<<<<<< HEAD
            TableRelation = "SAR Header"."SAR No.";
=======
            TableRelation = "SAR Header";
>>>>>>> parent of 372841d (Oct 9, 2024)
        }
        field(2; "SAR Line No."; Integer)
        {
            Caption = 'SAR Line No.';
            AutoIncrement = true;
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
<<<<<<< HEAD
            Editable = false;
            TableRelation = Item;
=======
>>>>>>> parent of 372841d (Oct 9, 2024)
        }
        field(4; Cover; Option)
        {
            Caption = 'Cover';
            DataClassification = ToBeClassified;
            OptionMembers = Printing,Binding;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(6; Currency; Code[20])
        {
            Caption = 'Currency';
            TableRelation = Currency;
        }
        field(7; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(9; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
    }
    keys
    {
        key(PK; "SAR No.", "SAR Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        SARHeader: Record "SAR Header";
    begin
        if SARHeader.Get("SAR No.") then begin
            "Item No." := SARHeader."Item No.";
        end;
    end;
}
