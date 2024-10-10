table 50107 "SAR Header"
{
    Caption = 'SAR Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "SAR No."; Code[20])
        {
            Caption = 'SAR No.';
            trigger OnValidate()
            var
                SARSetup: Record "Inventory Setup";
                NoSeries: Codeunit "No. Series";

            begin
                Reset();
                if "SAR No." <> xRec."SAR No." then begin
                    SARSetup.Get();
                    NoSeries.TestManual(SARSetup."SAR No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(4; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(5; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(6; "Average Cost"; Decimal)
        {
            Caption = 'Average Cost';
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
        key(PK; "SAR No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "SAR No.", "Item No.", Date)
        {
        }
    }

    procedure AssistEdit(OldSAR: Record "SAR Header"): Boolean
    var
        SARSetup: Record "Inventory Setup";
        SAR: Record "SAR Header";
        NoSeries: Codeunit "No. Series";

    begin
        SAR := Rec;
        SARSetup.Get();
        SARSetup.TestField("SAR No.");
        if NoSeries.LookupRelatedNoSeries(SARSetup."SAR No.", OldSAR."No. Series", SAR."No. Series") then begin
            SAR."SAR no." := NoSeries.GetNextNo(SAR."No. Series");
            Rec := SAR;
            OnAssistEditOnBeforeExit(Rec);
            exit(true);
        end;
    end;

    trigger OnInsert()
    var
        SARSetup: Record "Inventory Setup";
        SAR: Record "SAR Header";
        NoSeries: Codeunit "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeOnInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "SAR No." = '' then begin
            SARSetup.Get();
            SARSetup.TestField("SAR No.");
            NoSeriesMgt.RaiseObsoleteOnBeforeInitSeries(SARSetup."SAR No.", xRec."No. Series", 0D, "SAR No.", "No. Series", IsHandled);

            if not IsHandled then begin
                "No. Series" := SARSetup."SAR No.";
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "SAR No." := NoSeries.GetNextNo("No. Series");
                SAR.ReadIsolation(IsolationLevel::ReadUncommitted);
                SAR.SetLoadFields("SAR No.");
                while SAR.Get("SAR No.") do
                    "SAR No." := NoSeries.GetNextNo("No. Series");

                NoSeriesMgt.RaiseObsoleteOnAfterInitSeries("No. Series", SARSetup."SAR No.", 0D, "SAR No.");
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAssistEditOnBeforeExit(var SAR: Record "SAR Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOnInsert(var SAR: Record "SAR Header"; var IsHandled: Boolean)
    begin
    end;
}
