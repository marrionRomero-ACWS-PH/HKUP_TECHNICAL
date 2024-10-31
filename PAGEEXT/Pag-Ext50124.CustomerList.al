pageextension 50124 "Customer List" extends "Customer List"
{
    layout
    {
        addafter("Payments (LCY)")
        {
            field("Consignment Account"; Rec."Consignment Account")
            {
                ApplicationArea = all;
            }
            field("Sales Area"; Rec."Sales Area")
            {
                ApplicationArea = all;
            }
            field(Remarks; Rec.Remarks)
            {
                ApplicationArea = all;
            }
            field(Author; Rec."Author No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
