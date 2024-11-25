codeunit 50100 "Event Procedure"
{
    procedure AuthorNoIsVisible(): Boolean
    var
        l_codNoSeriesCode: Code[20];
        l_bolAuthNoVisible: Boolean;
    begin
        l_codNoSeriesCode := DetermineAuthorSeriesNo();
        l_bolAuthNoVisible := ForceShowNoSeriesForDocNo(l_codNoSeriesCode);
        exit(l_bolAuthNoVisible);
    end;

    procedure DetermineAuthorSeriesNo(): Code[20]
    var
        l_recPurchaseSetup: Record "Purchases & Payables Setup";
    begin
        l_recPurchaseSetup.SetLoadFields("Author No.'s");
        l_recPurchaseSetup.Get();
        exit(l_recPurchaseSetup."Author No.'s");
    end;

    procedure ForceShowNoSeriesForDocNo(NoSeriesCode: Code[20]): Boolean
    var
        l_recNoSeries: Record "No. Series";
        l_recNoSeriesRelationship: Record "No. Series Relationship";
        l_cuNoSeriesBatch: Codeunit "No. Series - Batch";
        l_dateSeriesDate: Date;
    begin
        if not l_recNoSeries.Get(NoSeriesCode) then
            exit(true);

        l_dateSeriesDate := WorkDate();
        l_recNoSeriesRelationship.SetRange(Code, NoSeriesCode);
        if not l_recNoSeriesRelationship.IsEmpty() then
            exit(true);

        if l_recNoSeries."Manual Nos." or (l_recNoSeries."Default Nos." = false) then
            exit(true);

        exit(l_cuNoSeriesBatch.GetNextNo(NoSeriesCode, l_dateSeriesDate, true) = '');
    end;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    procedure RelatedNoSeries(): Code[20]
    var
        l_recPurchaseSetup: Record "Purchases & Payables Setup";
        l_recAuthor: Record Authors;
        l_cuNoSeries: Codeunit "No. Series";
    begin
        l_recAuthor := g_recAuthor;
        l_recPurchaseSetup.Get();
        l_recPurchaseSetup.TestField("Author No.'s");
        if l_cuNoSeries.LookupRelatedNoSeries(l_recPurchaseSetup."Author No.'s", l_recAuthor."No. Series", l_recAuthor."No. Series") then begin
            l_recAuthor."Author No." := l_cuNoSeries.GetNextNo(l_recAuthor."No. Series");
            g_recAuthor := l_recAuthor;
        end;
    end;

    var
        g_recAuthor: Record Authors;
}