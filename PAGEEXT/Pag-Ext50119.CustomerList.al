pageextension 50119 "Customer List" extends "Customer List"
{
    layout
    {
        addafter("Payments (LCY)")
        {
            field("Consignment Account"; Rec."Consignment Account")
            {
            }
            field("Sales Area"; Rec."Sales Area")
            {
            }
            field(Remarks; Rec.Remarks)
            {
            }
            field(Author; Rec."Author No.")
            {
            }
        }
    }
}
