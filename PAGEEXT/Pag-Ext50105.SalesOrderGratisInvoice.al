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
    actions
    {
        addlast(Processing)
        {
            action("Warehouse Shipped")
            {
                Caption = 'Warehouse Shipped';
                Promoted = true;
                Image = Shipment;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    Confirmed: Boolean;
                begin
                    // Confirm action
                    Confirmed := Confirm('Do you confirm to update the warehouse status?', false);
                    if Confirmed then begin
                        Rec."Warehouse Status" := Rec."Warehouse Status"::Shipped;
                        Rec.Modify(true);  // Modify and commit the record
                        Message('Warehouse status updated to "Shipped" for Sales Order %1.', Rec."No.");
                    end;
                end;
            }
        }
    }
}