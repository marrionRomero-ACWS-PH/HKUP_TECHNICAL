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
                recItem: Record Item;
            begin

                if ("Direct Transfer" = true) then
                    if "Pub Code" = '' then
                        if recItem.Get("Item No.") then begin
                            // Description := recItem.Description;
                            "Pub Code" := Format(recItem."Pub Code");
                            // Validate("Pub Code");
                            Modify();
                        end;
            end;

        }
    }

    // trigger OnModify()
    // var
    //     recItem: Record Item;
    // begin

    //     "Pub Code" := '';
    //     if recItem.Get("Item No.") then begin
    //         // Description := recItem.Description;
    //         "Pub Code" := Format(recItem."Pub Code");
    //         // Validate("Pub Code");
    //         Modify();
    //     end;
    // end;

}