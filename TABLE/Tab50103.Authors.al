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
                SalesSetup: Record "Sales & Receivables Setup";
                NoSeries: Codeunit "No. Series";

            begin
                if "Author No." <> xRec."Author No." then begin
                    SalesSetup.Get();
                    NoSeries.TestManual(SalesSetup."Author No.'s");
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
            // TableRelation = Vendor."No." WHERE("Recipient" = FILTER(true));
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

    // Define a FieldGroup for the lookup
    fieldgroups
    {
        fieldgroup(DropDown; "Author No.", "Author Name") // Display both fields in the lookup
        {
        }
    }
    procedure AssistEdit(OldAuth: Record Authors): Boolean
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Auth: Record Authors;
        NoSeries: Codeunit "No. Series";

    begin
        Auth := Rec;
        SalesSetup.Get();
        SalesSetup.TestField("Author No.'s");
        if NoSeries.LookupRelatedNoSeries(SalesSetup."Author No.'s", OldAuth."No. Series", Auth."No. Series") then begin
            Auth."Author No." := NoSeries.GetNextNo(Auth."No. Series");
            Rec := Auth;
            OnAssistEditOnBeforeExit(Rec);
            exit(true);
        end;
    end;

    trigger OnInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Author: Record Authors;
        NoSeries: Codeunit "No. Series";
        NoSeriesMgt: Codeunit "Event Procedure";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "Author No." = '' then begin
            SalesSetup.Get();
            SalesSetup.TestField("Author No.'s");
            NoSeriesMgt.RaiseObsoleteOnBeforeInitSeries(SalesSetup."Author No.'s", xRec."No. Series", 0D, "Author No.", "No. Series", IsHandled);

            if not IsHandled then begin
                "No. Series" := SalesSetup."Author No.'s";
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "Author No." := NoSeries.GetNextNo("No. Series");
                Author.ReadIsolation(IsolationLevel::ReadUncommitted);
                Author.SetLoadFields("Author No.");
                while Author.Get("Author No.") do
                    "Author No." := NoSeries.GetNextNo("No. Series");

                NoSeriesMgt.RaiseObsoleteOnAfterInitSeries("No. Series", SalesSetup."Author No.'s", 0D, "Author No.");
            end;
        end;
    end;

    local procedure OnBeforeOnInsert(var Author: Record Authors; var IsHandled: Boolean)
    begin
    end;

    local procedure OnAssistEditOnBeforeExit(var Auth: Record Authors)
    begin
    end;



}


