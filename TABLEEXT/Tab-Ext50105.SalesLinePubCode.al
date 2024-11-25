tableextension 50105 "SalesLine(Pub Code)" extends "Sales Line"
{
    fields
    {
        field(50100; "Pub Code"; Code[20])
        {
            Caption = 'Pub Code';
            Editable = false;
            TableRelation = Item."Pub Code";
        }
        field(50101; "Bulk Purchase"; Boolean)
        {
            Caption = 'Bulk Purchase';
        }
    }

    trigger OnModify()
    var
        recItem: Record Item;
        SalesHeader: Record "Sales Header";
        NoSeries: Record "No. Series";
    begin
        if ("Type" = "Type"::Item) then begin
            if recItem.Get("No.") then
                "Pub Code" := Format(recItem."Pub Code");
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
                    if recItem.Get("No.") then begin
                        if (recItem."Type" <> recItem."Type"::Service) and
                           (recItem."Type" <> recItem."Type"::"Non-Inventory") and
                           (recItem."Type" = recItem."Type"::Inventory) and
                           (recItem."Pub Code" <> recItem."Pub Code"::"Q – Ebook") then
                            Error('This is an Ebook invoice, please select an Ebook item.');
                    end;
                end
                else begin
                    if recItem.Get("No.") then begin
                        if (recItem."Pub Code" = recItem."Pub Code"::"Q – Ebook") then
                            Error('This is not an Ebook invoice, please select a non-Ebook item.');
                    end;
                end;
            end;
        end;
    end;


    trigger OnDelete()
    begin
        if ("Type" = "Type"::Item) then
            Validate("Pub Code", '');
    end;


}