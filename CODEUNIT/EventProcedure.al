codeunit 50100 "Event Procedure"
{
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

    local procedure OnBeforeAuthorNoIsVisible(var IsVisible: Boolean; var IsHandled: Boolean)
    begin
    end;
    ///////------AUTHOR NO. VISIBILITTY END------\\\\\\\

    ///////------CUSTOM "No.SERIESMGT"  START------\\\\\\\
    /////////////////////////////BEFORE\\\\\\\\\\\\\\\\\\\\\\\\\\
    procedure RaiseObsoleteOnBeforeInitSeries(var DefaultNoSeriesCode: Code[20]; OldNoSeriesCode: Code[20]; NewDate: Date; var NewNo: Code[20]; var NewNoSeriesCode: Code[20]; var IsHandled: Boolean)
    var
        GlobalNoSeries: Record "No. Series";
        GlobalNoSeriesCode: Code[20];
    begin
        OnBeforeInitSeries(DefaultNoSeriesCode, OldNoSeriesCode, NewDate, NewNo, NewNoSeriesCode, GlobalNoSeries, IsHandled, GlobalNoSeriesCode);
    end;

    local procedure OnBeforeInitSeries(var DefaultNoSeriesCode: Code[20]; OldNoSeriesCode: Code[20]; NewDate: Date; var NewNo: Code[20]; var NewNoSeriesCode: Code[20]; var NoSeries: Record "No. Series"; var IsHandled: Boolean; var NoSeriesCode: Code[20])
    begin
    end;
    /////////////////////////////AFTER\\\\\\\\\\\\\\\\\\\\\\\\\\/// 
    procedure RaiseObsoleteOnAfterInitSeries(NoSeriesCode: Code[20]; DefaultNoSeriesCode: Code[20]; NewDate: Date; var NewNo: Code[20])
    var
        NoSeries: Record "No. Series";
    begin
        if NoSeries.Get(NoSeriesCode) then;
        OnAfterInitSeries(NoSeries, DefaultNoSeriesCode, NewDate, NewNo);
    end;

    local procedure OnAfterInitSeries(var NoSeries: Record "No. Series"; DefaultNoSeriesCode: Code[20]; NewDate: Date; var NewNo: Code[20])
    begin
    end;
<<<<<<< Updated upstream
    ///////------CUSTOM "No.SERIESMGT"  END------\\\\\\\
=======

>>>>>>> Stashed changes
}