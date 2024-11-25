// page 50104 "Author Card"
// {
//     Caption = 'Author Card';
//     PageType = Card;
//     SourceTable = Authors;
//     ApplicationArea = All;

//     layout
//     {
//         area(Content)
//         {
//             group(General)
//             {
//                 Caption = 'General';

//                 field("Author No."; Rec."Author No.")
//                 {
//                     ApplicationArea = All;
//                     Visible = g_NoFieldVisible;
//                     ShowMandatory = true;

//                     trigger OnAssistEdit()
//                     var
//                         l_recSalesSetup: Record "Sales & Receivables Setup";
//                         l_recAuthor: Record Authors;
//                         NoSeries: Codeunit "No. Series";

//                     begin
//                         l_recAuthor := Rec;
//                         l_recSalesSetup.Get();
//                         l_recSalesSetup.TestField("Author No.'s");
//                         if NoSeries.LookupRelatedNoSeries(l_recSalesSetup."Author No.'s", l_recAuthor."No. Series", l_recAuthor."No. Series") then begin
//                             l_recAuthor."Author No." := NoSeries.GetNextNo(l_recAuthor."No. Series");
//                             Rec := l_recAuthor;
//                             CurrPage.Update();
//                         end;
//                     end;
//                 }
//                 field("Author Name"; Rec."Author Name")
//                 {
//                     ShowMandatory = true;
//                     ApplicationArea = All;
//                 }
//                 field("Author Name 2"; Rec."Author Name 2")
//                 {
//                     ApplicationArea = All;
//                     MultiLine = true;
//                     Visible = false;
//                 }
//                 field("Recipient No."; Rec."Recipient No.")
//                 {
//                     ApplicationArea = all;
//                     TableRelation = Vendor."No." WHERE("Recipient" = FILTER(true));
//                     trigger OnValidate()
//                     var
//                         l_recVendor: Record Vendor;
//                     begin
//                         if l_recVendor.Get(Rec."Recipient No.") then begin
//                             Rec."Recipient Name" := l_recVendor.Name;
//                         end;
//                     end;
//                 }
//                 field("Recipient Name"; Rec."Recipient Name")
//                 {
//                 }
//                 field("No. Series"; Rec."No. Series")
//                 {
//                     Visible = false;
//                 }
//             }

//             group("Address&Contact")
//             {
//                 Caption = 'Address & Contact';
//                 field(Address; Rec.Address)
//                 {
//                 }
//                 field("Address 2"; Rec."Address 2")
//                 {
//                 }
//             }
//         }
//     }

//     trigger OnOpenPage()
//     var
//         l_recDocNoVisibility: Codeunit "Event Procedure";
//     begin
//         if GuiAllowed() then
//             g_NoFieldVisible := l_recDocNoVisibility.AuthorNoIsVisible();
//     end;

//     var
//         g_NoFieldVisible: Boolean;

// }