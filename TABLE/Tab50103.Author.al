table 50103 Author
{
    Caption = 'Author';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Author No."; Code[20])
        {
            Caption = 'Author No.';
            TableRelation = "No. Series";
        }
        field(2; "Author Name"; Text[100])
        {
            Caption = 'Author Name';
        }
        field(3; "Recipient No."; Code[20])
        {
            Caption = 'Recipient No.';
            TableRelation = Vendor."No." WHERE("Recipient" = FILTER(true));
            // TableRelation = Vendor where(Recipient = const(true));
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(6; "Recipient Name"; Text[50])
        {
            Caption = 'Recipient Name';

        }
    }
    keys
    {
        key(PK; "Author No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        PurchSetup.Get();
        Rec."Author No." := NoSeries.GetNextNo(PurchSetup."Author No.'s", WorkDate, true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateNo(var Author: Record Author; xAuthor: Record Author)
    begin
    end;
}
