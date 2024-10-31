pageextension 50118 "Posted Transfer Receipts" extends "Posted Transfer Receipts"
{
    layout
    {
        addlast(content)
        {
            field("Customer No."; Rec."Customer No.")
            {
                applicationArea = all;
            }
            field("Customer Name"; Rec."Customer Name")
            {
                applicationArea = all;
            }
        }
    }
}
