pageextension 50105 "SalesOrder-GratisInvoice" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Gratis Invoice"; Rec."Gratis Invoice")
            {
                Caption = 'Gratis Invoice';
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SalesRec: record "Sales Line";
    begin
        if Rec."Gratis Invoice" then begin
            Rec.Reset();
            SalesRec."Unit Price" := 0;
            salesRec.Quantity := 0;
        end;
    end;
}