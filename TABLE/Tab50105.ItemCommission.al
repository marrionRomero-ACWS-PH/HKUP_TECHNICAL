table 50105 "Item Commission"
{
    Caption = 'Item Commission';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(3; "Commission Method"; Option)
        {
            Caption = 'Commission Method';
            OptionMembers = "Net Price","List Price";
        }
        field(4; "Commission %"; Decimal)
        {
            Caption = 'Commission %';
            DataClassification = ToBeClassified;
            MinValue = 0;
            MaxValue = 100;
        }
        field(5; "Commission Effective Start Date"; Date)
        {
            Caption = 'Commission Effective Start Date';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(6; "Commission Effective End Date"; Date)
        {
            Caption = 'Commission Effective End Date';
            DataClassification = ToBeClassified;
            NotBlank = true;

            trigger OnValidate()
            begin
                if "Commission Effective End Date" <= "Commission Effective Start Date" then begin
                    Message('The "Commission Effective End Date" must be greater than the "Commission Effective Start Date".');
                    "Commission Effective End Date" := 0D; // Reset to blank if validation fails
                end;
            end;

        }
    }
    keys
    {
        key(PK; "Item No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
