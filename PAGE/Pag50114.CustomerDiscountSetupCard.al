page 50114 "Customer Discount Setup Card"
{
    ApplicationArea = All;
    Caption = 'Customer Discount Setup Card';
    PageType = Card;
    SourceTable = "Customer Discount Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Customer; Rec.Customer)
                {
                }
                field(Title; Rec.Title)
                {

                }
                field("Percentage %"; Rec."Percentage %")
                {
                }
            }
        }
    }
}
