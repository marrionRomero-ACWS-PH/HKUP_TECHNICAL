// page 50103 "Author List"
// {
//     PageType = List;
//     SourceTable = Authors;
//     ApplicationArea = All;
//     UsageCategory = Lists;
//     Caption = 'Authors';
//     CardPageID = "Author Card";
//     Editable = false;
//     PromotedActionCategories = 'New,Process,Report,New Document,Vendor,Navigate';
//     RefreshOnActivate = true;

//     layout
//     {
//         area(Content)
//         {
//             repeater(Group)
//             {
//                 field("No."; Rec."Author No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Name"; Rec."Author Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Author Name 2"; Rec."Author Name 2")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Recipient"; Rec."Recipient No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Recipient Name"; Rec."Recipient Name")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field(Address; Rec.Address)
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("Address 2"; Rec."Address 2")
//                 {
//                     ApplicationArea = All;
//                 }
//             }
//         }
//     }
// }
