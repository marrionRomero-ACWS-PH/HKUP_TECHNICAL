pageextension 50100 Item extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Full Title"; Rec."Full Title")
            {
                ApplicationArea = All;
            }
            // field("Product Number"; Rec."No.")
            // {
            //     ApplicationArea = All;
            // }

            field("Pub Code"; Rec."Pub Code")
            {
                ApplicationArea = All;
            }
            // field("Print Title"; Rec.Description)
            // {
            //     ApplicationArea = All;
            // }
            field(Publisher; Rec.Publisher)
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    VendorRec: Record Vendor;
                    IsHandled: Boolean;
                begin
                    IsHandled := false;
                    VendorRec.SetRange("Type", VendorRec."Type"::Publisher);
                    if Page.RunModal(Page::"Vendor List", VendorRec) = Action::LookupOK then begin
                        Rec."Publisher" := VendorRec."No.";
                        IsHandled := true;
                    end;
                    exit(IsHandled);
                end;
            }
            field(Supplier; Rec.Supplier)
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    VendorRec: Record Vendor;
                    IsHandled: Boolean;
                begin
                    IsHandled := false;
                    VendorRec.SetRange("Type", VendorRec."Type"::Supplier);
                    if Page.RunModal(Page::"Vendor List", VendorRec) = Action::LookupOK then begin
                        Rec."Supplier" := VendorRec."No.";
                        IsHandled := true;
                    end;
                    exit(IsHandled);
                end;
                // TableRelation = Vendor.Type;
            }
            field(Series; Rec.Series)
            {
                ApplicationArea = All;
            }
            field("Publish Date"; Rec."Published Date")
            {
                ApplicationArea = All;
            }
            field("Format"; Rec."Format")
            {
                ApplicationArea = All;
            }
            field("Discount (%)"; Rec."Disount (%)")
            {
                ApplicationArea = All;
            }
            field("Warning Level"; Rec."Warning Level")
            {
                ApplicationArea = All;
            }
            field("Restriction"; Rec."Restriction")
            {
                ApplicationArea = All;

            }
            field("Status"; Rec."Status")
            {
                ApplicationArea = All;

            }
            field("Reprint History"; Rec."Reprint History")
            {
                ApplicationArea = All;
                MultiLine = true;
            }
            field("Remarks"; Rec."Remarks")
            {
                ApplicationArea = All;
                MultiLine = true;
            }

            field("Sales Right"; Rec."Sales Right")
            {
                ApplicationArea = All;
            }
            field("Royalty Method"; Rec."Royalty Method")
            {
                ApplicationArea = All;
            }
            // field("Category"; Rec."Item Category Code")
            // {
            //     ApplicationArea = All;
            // }
            field("Commision Method"; Rec."Commission Method")
            {
                ApplicationArea = All;
            }
            field("Quantity Sold"; Rec."Quantity Sold")
            {
                ApplicationArea = All;
            }
            field("Created On"; Rec."Created On")
            {
                ApplicationArea = All;
            }

            // field("Weight (kg)"; Rec."Net Weight")
            // {
            //     ApplicationArea = All;
            // }
            // field("Trim Size(WxH)"; Rec."Unit Volume")
            // {
            //     ApplicationArea = All;
            // }
            // field("Stock, Consign. Stock, DN Stock"; Rec."Safety Stock Quantity")
            // {
            //     ApplicationArea = All;
            // }

        }
    }
    var
        myInt: Integer;
}
