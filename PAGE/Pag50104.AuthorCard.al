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

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(" No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
                    begin
                        // When Recipient No. is selected, auto-fill Recipient Name
                        if VendorRec.Get(Rec."Recipient") then begin
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