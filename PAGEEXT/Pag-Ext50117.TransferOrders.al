<<<<<<< HEAD
// pageextension 50117 "Transfer Orders" extends "Transfer Orders"
// {
//     layout
//     {
//         addafter("No.")
//         {
//             field("Customer No."; Rec."Sell-To Customer No.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Customer Name"; Rec."Customer Name")
//             {
//                 ApplicationArea = all;
=======
pageextension 50117 "Transfer Orders" extends "Transfer ORders"
{
    layout
    {
        addlast(content)
        {
            field("Customer No."; Rec."Sell-To Customer Name")
            {

            }
            field("Customer Name"; Rec."Sell-To Customer Name")
            {
>>>>>>> parent of 06dbf32 (Marrion Update)

//             }
//         }
//     }
// }
