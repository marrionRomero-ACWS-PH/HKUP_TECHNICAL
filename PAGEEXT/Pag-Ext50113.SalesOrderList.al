pageextension 50113 "Sales Orders" extends "Sales Order List"
{
    actions
    {
        addlast("&Order Confirmation")
        {
            action("Warehouse Shipped")
            {
                Caption = 'Warehouse Shipped';
                Promoted = true;
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
