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
                SARHeader: Record "SAR Header";
                NoSeries: Codeunit "No. Series";

            begin
                if "SAR No." <> xRec."SAR No." then
                    if not "SARHeader".Get(Rec."SAR No.") then begin
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
        field(7; "No. Series"; code[20])
        {

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
    trigger OnInsert()
    var
        SARSetup: Record "Inventory Setup";
        SAR: Record "SAR Header";
        NoSeries: Codeunit "No. Series";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if "SAR No." = '' then begin
            SARSetup.Get();
            SARSetup.TestField("SAR No.");
            "No. Series" := SARSetup."SAR No.";
            if NoSeries.AreRelated(SARSetup."SAR No.", xRec."SAR No.") then begin
                "No. Series" := xRec."No. Series";
                "SAR No." := NoSeries.GetNextNo(SAR."No. Series");
                Rec := SAR;
            end;

            if not IsHandled then begin
                "No. Series" := SARSetup."SAR No.";
                if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "SAR No." := NoSeries.GetNextNo("No. Series");
                SAR.ReadIsolation(IsolationLevel::ReadUncommitted);
                SAR.SetLoadFields("SAR No.");
                while SAR.Get("SAR No.") do
                    "SAR No." := NoSeries.GetNextNo("No. Series");
            end;
        end;
    end;


}
