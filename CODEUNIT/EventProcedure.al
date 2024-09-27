codeunit 50100 "Event Procedure"
{
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
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.SetLoadFields("Author No.'s");
        PurchasesPayablesSetup.Get();
        exit(PurchasesPayablesSetup."Author No.'s");
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
}