tableextension 50105 "SalesLine(Pub Code)" extends "Sales Line"
{
    fields
    {
        field(50102; "FEO Code"; Code[20])
        {
            Caption = 'FEO Code';
            Editable = false;
            TableRelation = Item."FEO Code";
        }
    }

    trigger OnModify()
    var
        ItemRecord: Record Item;
        SalesHeader: Record "Sales Header";
        NoSeries: Record "No. Series";
    begin
        if ("Type" = "Type"::Item) then begin
            if ItemRecord.Get("No.") then
                "FEO Code" := Format(ItemRecord."FEO Code");
        end;

        begin
            if SalesHeader.Get("Document Type", "Document No.") then
                if (SalesHeader."Gratis Invoice" = true) and (("Unit Price" <> 0) or ("Quantity" <> 0)) then begin
                    SalesHeader.Validate("Gratis Invoice", false);
                    SalesHeader.Modify();
                end;
        end;
        ///////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        begin
            // Get the related Sales Header
            if not SalesHeader.Get("Document Type", "Document No.") then
                exit;

            // Check if No. Series is an Ebook Invoice series
            if NoSeries.Get(SalesHeader."No. Series") then begin
                if NoSeries."Ebook" then begin
                    if ItemRecord.Get("No.") then begin
                        if (ItemRecord."Type" <> ItemRecord."Type"::Service) and
                           (ItemRecord."Type" <> ItemRecord."Type"::"Non-Inventory") and
                           (ItemRecord."Type" = ItemRecord."Type"::Inventory) and
                           (ItemRecord."FEO Code" <> ItemRecord."FEO Code"::"Q") then
                            Error('This is an Ebook invoice, please select an Ebook item.');
                    end;
                end
                else begin
                    if ItemRecord.Get("No.") then begin
                        if (ItemRecord."FEO Code" = ItemRecord."FEO Code"::"Q") then
                            Error('This is not an Ebook invoice, please select a non-Ebook item.');
                    end;
                end;
            end;
        end;
    end;

    trigger OnDelete()
    begin
        if ("Type" = "Type"::Item) then
            Validate("FEO Code", '');
    end;


}
