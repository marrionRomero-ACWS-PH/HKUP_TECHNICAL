// pageextension 50104 Customer extends "Customer Card"
// {
//     layout
//     {
//         addafter(Name)
//         {
//             field("Name two"; Rec."Name 2")
//             {
//                 Caption = 'Name 2';
//                 ApplicationArea = all;
//             }
//         }
//         addlast(General)
//         {
//             field("Sales Area"; Rec."Sales Area")
//             {
//                 ApplicationArea = All;
//             }
//             field("Consignment Account  "; Rec."Consignment Account")
//             {
//                 ApplicationArea = All;
//             }
//             field("Sales Area  "; Rec."Sales Area")
//             {
//                 ApplicationArea = All;
//             }
//             field("Discount %"; Rec."Discount %")
//             {
//                 ApplicationArea = All;
//             }
//             field("Remarks"; Rec."Remarks")
//             {
//                 ApplicationArea = All;
//                 MultiLine = true;
//             }
//             field("Author"; Rec."Author No.")
//             {
//                 Lookup = true;
//                 LookupPageId = "Author List";
//                 ApplicationArea = All;
//                 trigger OnValidate()
//                 var
//                     AuthorRec: Record Authors;
//                 begin
//                     if AuthorRec.Get(Rec."Author No.") then begin
//                         Rec."Author Name" := AuthorRec."Author Name";
//                     end;
//                 end;
//             }
//             field("Author Name"; Rec."Author Name")
//             {
//                 ApplicationArea = all;
//             }
//         }
//     }
// }
