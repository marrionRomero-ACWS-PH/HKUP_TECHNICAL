tableextension 50100 Item extends Item
{
    fields
    {
        field(50100; "Full Title"; Text[100])
        {
            Caption = 'Full Title';
            DataClassification = ToBeClassified;
        }
        field(50101; "Pub Code"; Option)
        {
            Caption = 'Pub Code';
            OptionMembers = "A - Academic Title","C - Commission Title","G - General Title","X - Agency Title","Q – Ebook","S – Service Charge";
            trigger OnValidate()
            begin
                case "Pub Code" of
                    0, 1: // A - Academic Title, C - Commission Title
                        Rec."Disount (%)" := 30;
                    2, 3: // G - General Title, X - Agency Title
                        Rec."Disount (%)" := 35;
                    4: // Q – E-book
                        Rec."Disount (%)" := 0;
                end;
            end;
        }
        field(50102; Publisher; Code[20])
        {
            Caption = 'Publisher';
            // TableRelation = Vendor WHERE(Type = FILTER(Publisher));
            // TableRelation = Vendor."No." WHERE("Publisher" = FILTER(true));
            TableRelation = Vendor where(Publisher = const(true));
        }
        field(50103; Series; Code[50])
        {
            Caption = 'Series';
            TableRelation = "Series Master";
        }
        field(50104; Supplier; Code[20])
        {
            Caption = 'Supplier';
            // TableRelation = Vendor WHERE(Type = FILTER(Supplier));
            // TableRelation = Vendor."No." WHERE("Supplier" = FILTER(true));
            TableRelation = Vendor where(Supplier = const(true));
        }
        field(50105; "Published Date"; Date)
        {
            Caption = 'Published Date';
            DataClassification = ToBeClassified;
        }
        field(50106; "Actual Pages"; Integer)
        {
            Caption = 'Actual Pages';
            MinValue = 0;
            MaxValue = 9999;
            DataClassification = ToBeClassified;
        }
        field(50118; "Format"; Code[50])
        {
            Caption = 'Format';
            DataClassification = ToBeClassified;
            TableRelation = "Format Master";
        }
        field(50107; "Disount (%)"; Integer)
        {
            Caption = 'Discount (%)';
            DataClassification = ToBeClassified;
        }
        field(50108; "Warning Level"; Integer)
        {
            Caption = 'Warning Level';
            DataClassification = ToBeClassified;
            InitValue = 10;
        }
        field(50109; Restriction; Text[250])
        {
            Caption = 'Restriction';
            DataClassification = ToBeClassified;

        }
        field(50110; Status; Text[250])
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(50111; "Reprint History"; Text[250])
        {
            Caption = 'Reprint History';
            DataClassification = ToBeClassified;
        }
        field(50112; Remarks; Text[250])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
        }
        field(50113; "Sales Right"; Text[100])
        {
            Caption = 'Sales Right';
            DataClassification = ToBeClassified;
        }
        field(50114; "Royalty Method"; Option)
        {
            Caption = 'Royalty Method';
            DataClassification = ToBeClassified;
            OptionCaption = 'Published Price,Net Income';
            OptionMembers = "Published Price","Net Income";
        }
        field(50115; "Commission Method"; Option)
        {
            Caption = 'Commission Method';
            DataClassification = ToBeClassified;
            OptionCaption = 'Net Price,List Price';
            OptionMembers = "Net Price","List Price";
        }
        field(50116; "Quantity Sold"; Integer)
        {
            Caption = 'Quantity Sold';
            DataClassification = ToBeClassified;
        }
        field(50117; "Created On"; Date)
        {
            Caption = 'Created On';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(50119; "No Calculation for Commission"; Boolean)
        {
            Caption = 'No Calculation for Commission';
            DataClassification = ToBeClassified;
        }
        field(50120; "Royalty Method Description"; Text[250])
        {
            Caption = 'Royalty Method Calculation Description';
            DataClassification = ToBeClassified;
        }
        field(50121; "Parent Item No."; Code[20])
        {
            Caption = 'Parent Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(50122; "No. of Authors"; Integer)
        {
            Caption = 'No. of Authors';
            // FieldClass = FlowField;
            // CalcFormula = Count("Item Author" where("Item No." = Field("No.")));
        }
        field(50123; "No. of SAR Documents"; Integer)
        {
            Caption = 'No. of SAR Documents';
            FieldClass = FlowField;
            CalcFormula = Count("SAR Header" where("Item No." = Field("No.")));
            // trigger OnLookup()
            // var
            //     SARRec: Record "SAR Header";
            // begin
            //     // Logic to count the number of SAR Documents for the current item.
            //     SARRec.SetRange("Item No.", Rec."No.");
            //     Rec."No. of SAR Documents" := SARRec.Count;
            // end;
        }
    }

    trigger OnInsert()
    begin
        "Created On" := Today;
    end;
}