codeunit 50100 "Event Procedure"
{
    SingleInstance = false;
    ///////------AUTHOR NO. VISIBILITTY START------\\\\\\\
    procedure AuthorNoIsVisible(): Boolean
    var
        NoSeriesCode: Code[20];
        IsHandled: Boolean;
        IsVisible: Boolean;
        AuthNoVisible: Boolean;
        IsAuthNoInitialized: boolean;
    begin
        IsHandled := false;
        IsVisible := false;
        OnBeforeAuthorNoIsVisible(IsVisible, IsHandled);
        if IsHandled then
            exit(IsVisible);

        if IsAuthNoInitialized then
            exit(AuthNoVisible);
        IsAuthNoInitialized := true;

        NoSeriesCode := DetermineAuthorSeriesNo();
        AuthNoVisible := ForceShowNoSeriesForDocNo(NoSeriesCode);
        exit(AuthNoVisible);
    end;

    local procedure DetermineAuthorSeriesNo(): Code[20]
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.SetLoadFields("Author No.'s");
        SalesReceivablesSetup.Get();
        exit(SalesReceivablesSetup."Author No.'s");
    end;

    procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        NoSeriesRelationship: Record "No. Series Relationship";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        SeriesDate: Date;
    begin
        if not NoSeries.Get(NoSeriesCode) then
            exit(true);

        SeriesDate := WorkDate();
        NoSeriesRelationship.SetRange(Code, NoSeriesCode);
        if not NoSeriesRelationship.IsEmpty() then
            exit(true);

        if NoSeries."Manual Nos." or (NoSeries."Default Nos." = false) then
            exit(true);

        exit(NoSeriesBatch.GetNextNo(NoSeriesCode, SeriesDate, true) = '');
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAuthorNoIsVisible(var IsVisible: Boolean; var IsHandled: Boolean)
    begin
    end;
    ///////------AUTHOR NO. VISIBILITTY END------\\\\\\\



    ///////------AUTHOR NO. CALCULATION START------\\\\\\\
    procedure CalculateNoOfAuthors(var ItemRec: Record Item)
    var
        ItemAuthorRec: Record "Item Author";
    begin
        ItemAuthorRec.SetRange("Item No.", ItemRec."No.");
        ItemRec."No. of Authors" := ItemAuthorRec.Count;
        ItemRec.Modify();
    end;
}