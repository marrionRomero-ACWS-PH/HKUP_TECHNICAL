tableextension 50115 "Transfer Line" extends "Transfer Line"
{
    fields
    {
        field(50100; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatExpression = 'Currency Code';
            AutoFormatType = 2;
        }
        field(50101; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MinValue = 0;
            MaxValue = 100;
        }
        field(50102; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(50103; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
        }
        field(50104; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(50105; "Your Reference"; Text[250])
        {
            Caption = 'Your Reference';
        }

        field(50106; "Pub Code"; Code[20])
        {
            Caption = 'Pub Code';
            Editable = false;

            TableRelation = Item."Pub Code";
            trigger OnValidate()
            var

            begin
                if g_recItem.Get("Item No.") then begin
                    // Convert the Pub Code option value to Text
                    "Pub Code" := Format(g_recItem."Pub Code");
                end;
            end;
        }
    }
    var
        g_recTransferHeader: Record "Transfer Header";
        g_NoSeries: Record "No. Series";
        g_recItem: Record Item;

}