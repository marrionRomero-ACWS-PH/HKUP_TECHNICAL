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
                PurchSetup: Record "Purchases & Payables Setup";
                NoSeries: Codeunit "No. Series";

            begin
                if "Author No." <> xRec."Author No." then begin
                    PurchSetup.Get();
                    NoSeries.TestManual(PurchSetup."Author No.'s");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Author Name"; Text[100])
        {
            Caption = 'Author Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Recipient No."; Code[20])
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
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(6; "Recipient Name"; Text[50])
        {
            Caption = 'Recipient Name';
            DataClassification = ToBeClassified;
        }
        field(7; "No. Series"; Code[20])
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
        PurchSetup: Record "Purchases & Payables Setup";
        Auth: Record Authors;
        NoSeries: Codeunit "No. Series";

    begin
        Auth := Rec;
        PurchSetup.Get();
        PurchSetup.TestField("Author No.'s");
        if NoSeries.LookupRelatedNoSeries(PurchSetup."Author No.'s", OldAuth."No. Series", Auth."No. Series") then begin
            Auth."Author No." := NoSeries.GetNextNo(Auth."No. Series");
            Rec := Auth;
            OnAssistEditOnBeforeExit(Rec);
            exit(true);
        end;
    end;

    trigger OnInsert()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        Author: Record Authors;
        NoSeries: Codeunit "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "Author No." = '' then begin
            PurchSetup.Get();
            PurchSetup.TestField("Author No.'s");
            NoSeriesMgt.RaiseObsoleteOnBeforeInitSeries(PurchSetup."Vendor Nos.", xRec."No. Series", 0D, "Author No.", "No. Series", IsHandled);

            if not IsHandled then begin
                "No. Series" := PurchSetup."Author No.'s";
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "Author No." := NoSeries.GetNextNo("No. Series");
                Author.ReadIsolation(IsolationLevel::ReadUncommitted);
                Author.SetLoadFields("Author No.");
                while Author.Get("Author No.") do
                    "Author No." := NoSeries.GetNextNo("No. Series");

                NoSeriesMgt.RaiseObsoleteOnAfterInitSeries("No. Series", PurchSetup."Vendor Nos.", 0D, "Author No.");
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var Author: Record Authors; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAssistEditOnBeforeExit(var Auth: Record Authors)
    begin
    end;

}


