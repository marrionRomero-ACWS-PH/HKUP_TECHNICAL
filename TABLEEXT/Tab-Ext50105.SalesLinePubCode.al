tableextension 50105 "SalesLine(Pub Code)" extends "Sales Line"
{
    fields
    {
        field(50102; "Pub Code"; Code[20])
        {
            Caption = 'Pub Code';
            Editable = false;
            TableRelation = Item."Pub Code";
        }
    }

    trigger OnModify()
    var
        ItemRecord: Record Item;
        SalesHeader: Record "Sales Header";
    begin
        if ("Type" = "Type"::Item) then begin
            if ItemRecord.Get("No.") then
                "Pub Code" := Format(ItemRecord."Pub Code");
        end;

        begin
            if SalesHeader.Get("Document Type", "Document No.") then
                if (SalesHeader."Gratis Invoice" = true) and (("Unit Price" <> 0) or ("Quantity" <> 0)) then begin
                    SalesHeader.Validate("Gratis Invoice", false);
                    SalesHeader.Modify();
                end;
        end;
    end;

    trigger OnDelete()
    begin
        if ("Type" = "Type"::Item) then
            Validate("Pub Code", '');
    end;


}
