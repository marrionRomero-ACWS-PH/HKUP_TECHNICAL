// table 50104 "Item Author"
// {
//     Caption = 'Item Author';
//     DataClassification = ToBeClassified;

//     fields
//     {
//         field(1; "Item No."; Code[20])
//         {
//             Caption = 'Item No.';
//             TableRelation = Item;
//         }
//         field(2; "Line No."; Integer)
//         {
//             Caption = 'Line No.';
//         }
//         field(3; "Author Code"; Code[20])
//         {
//             Caption = 'Author Code';
//             TableRelation = Authors;
//         }
//         field(4; "Author Name"; Text[250])
//         {
//             Caption = 'Author Name';
//         }
//         field(5; "Royalty Fee %"; Decimal)
//         {
//             Caption = 'Royalty Fee %';
//             MinValue = 0;
//             MaxValue = 100;
//         }
//     }
//     keys
//     {
//         key(PK; "Item No.", "Line No.")
//         {
//             Clustered = true;
//         }
//     }
// }
