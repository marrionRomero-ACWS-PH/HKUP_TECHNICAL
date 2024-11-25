table 50103 Authors
{
    Caption = 'Authors';
    DataCaptionFields = "Author No.", "Author Name";
    DataClassification = ToBeClassified;
    DrillDownPageID = "Author List";
    LookupPageID = "Author List";

    fields
    {
        field(1; "Author No."; Code[20])
        {
            Caption = 'Author No.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                l_recSalesSetup: Record "Purchases & Payables Setup";
                l_recNoSeries: Codeunit "No. Series";

            begin
                if "Author No." <> xRec."Author No." then begin
                    l_recSalesSetup.Get();
                    l_recNoSeries.TestManual(l_recSalesSetup."Author No.'s");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Author Name"; Text[250])
        {
            Caption = 'Author Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Recipient No."; Code[50])
        {
            Caption = 'Recipient No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor where(Recipient = const(true));
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(5; "Address 2"; Text[100])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(6; "Recipient Name"; Text[100])
        {
            Caption = 'Recipient Name';
            DataClassification = ToBeClassified;
        }
        field(7; "Author Name 2"; Text[250])
        {
            Caption = 'Author Name 2';
        }
        field(8; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Author No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Author No.", "Author Name")
        {
        }
    }

    trigger OnInsert()
    var
        l_recSalesSetup: Record "Purchases & Payables Setup";
        l_recAuthor: Record Authors;
        l_recNoSeries: Codeunit "No. Series";
        l_recNoSeriesMgt: Codeunit "Event Procedure";
    begin

        if "Author No." = '' then begin
            l_recSalesSetup.Get();
            l_recSalesSetup.TestField("Author No.'s");
            "No. Series" := l_recSalesSetup."Author No.'s";
            if l_recNoSeries.AreRelated(l_recSalesSetup."Author No.'s", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "Author No." := l_recNoSeries.GetNextNo("No. Series");
        end;
    end;
}


