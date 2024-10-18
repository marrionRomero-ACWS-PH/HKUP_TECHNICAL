page 50104 "Author Card"
{
    Caption = 'Author Card';
    PageType = Card;
    SourceTable = Authors;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Author No."; Rec."Author No.")
                {
                    ApplicationArea = All;
                    Visible = NoFieldVisible;
                    ShowMandatory = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Author Name"; Rec."Author Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Author Name 2"; Rec."Author Name 2")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Visible = false;
                }
                field("Recipient No."; Rec."Recipient No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    TableRelation = Vendor."No." WHERE("Recipient" = FILTER(true));
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
                    begin
                        // When Recipient No. is selected, auto-fill Recipient Name
                        if VendorRec.Get(Rec."Recipient No.") then begin
                            Rec."Recipient Name" := VendorRec.Name;
                        end;
                    end;
                }
                field("Recipient Name"; Rec."Recipient Name")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                    Visible = false;
                }
            }

            group(AddressDetails)
            {
                Caption = 'Address & Contact';
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if GuiAllowed() then
            OnOpenPageFunc();
    end;

    local procedure OnOpenPageFunc()
    begin
        SetNoFieldVisible();
    end;

    var
        NoFieldVisible: Boolean;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit "Event Procedure";
    begin
        NoFieldVisible := DocumentNoVisibility.AuthorNoIsVisible();
    end;

}