pageextension 50116 "Transfer Order" extends "Transfer Order"
{
    layout
    {
        addafter("No.")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                ApplicationArea = All;
            }
            field("Sell-To Customer Name"; Rec."Sell-To Customer Name")
            {
                ApplicationArea = All;

//                 trigger OnValidate()
//                 begin
//                     SelltoCustomerNoOnAfterValidate(Rec, xRec);
//                     CurrPage.Update();
//                 end;
//             }
//         }

                //         addlast(General)
                //         {
                //             field("Currency Code"; Rec."Currency Code")
                //             {
                //                 ApplicationArea = all;

                //                 trigger OnAssistEdit()
                //                 begin
                //                     Clear(ChangeExchangeRate);
                //                     if Rec."Posting Date" <> 0D then
                //                         ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date")
                //                     else
                //                         ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate());
                //                     if ChangeExchangeRate.RunModal() = ACTION::OK then begin
                //                         Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());
                //                         // SaveInvoiceDiscountAmount();
                //                     end;
                //                     Clear(ChangeExchangeRate);
                //                 end;

                //                 trigger OnValidate()
                //                 begin
                //                     CurrPage.Update();
                //                 end;
                //             }

            field("Total Excl.VAT"; Rec."Total Excl.VAT")
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = Currency.Code;
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Editable = false;
            }
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = All;
            }
        }
        addfirst(Shipment)
        {
            group(ShipToOptions)
            {
                ShowCaption = false;
                field("Ship-to"; ShipToOptions)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        ShipToAddress: Record "Ship-to Address";
                        ShipToAddressList: Page "Ship-to Address List";
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeValidateShipToOptions(Rec, ShipToOptions.AsInteger(), IsHandled);
                        if IsHandled then
                            exit;

                        //                         case ShipToOptions of
                        //                             ShipToOptions::"Default (Sell-to Address)":
                        //                                 begin
                        //                                     Rec.Validate("Ship-to Code", '');

                        //                                     Rec.CopySellToAddressToShipToAddressinTransfer();
                        //                                 end;
                        //                             ShipToOptions::"Alternate Shipping Address":
                        //                                 begin
                        //                                     ShipToAddress.SetRange("Customer No.", Rec."Sell-to Customer No.");
                        //                                     ShipToAddressList.LookupMode := true;
                        //                                     ShipToAddressList.SetTableView(ShipToAddress);

                        if ShipToAddressList.RunModal() = ACTION::LookupOK then begin
                            ShipToAddressList.GetRecord(ShipToAddress);
                            OnValidateShipToOptionsOnAfterShipToAddressListGetRecord(ShipToAddress, Rec);
                            // Rec.Validate("Ship-to Code", ShipToAddress.Code);
                            IsShipToCountyVisible := FormatAddress.UseCounty(ShipToAddress."Country/Region Code");
                        end else
                            ShipToOptions := ShipToOptions::"Custom Address";
                    end;
                            ShipToOptions::"Custom Address":
                                begin
                                    Rec.Validate("Ship-to Code", '');
                                    IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                                end;
                        end;

//                         OnAfterValidateShippingOptions(Rec, ShipToOptions.AsInteger());
//                     end;
//                 }
//             }


//             group("Shipping Method")
//             {
//                 ShowCaption = false;
//                 Visible = not (ShipToOptions = ShipToOptions::"Default (Sell-to Address)");
//                 field("Ship-to Code"; Rec."Ship-to Code")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Code';
//                     Editable = ShipToOptions = ShipToOptions::"Alternate Shipping Address";
//                     Importance = Promoted;

//                     trigger OnValidate()
//                     var
//                         ShipToAddress: Record "Ship-to Address";
//                     begin
//                         if (xRec."Ship-to Code" <> '') and (Rec."Ship-to Code" = '') then
//                             Error('The Code field can only be empty if you select Custom Address in the Ship-to field.');
//                         if Rec."Ship-to Code" <> '' then begin
//                             ShipToAddress.Get(Rec."Sell-to Customer No.", Rec."Ship-to Code");
//                             IsShipToCountyVisible := FormatAddress.UseCounty(ShipToAddress."Country/Region Code");
//                         end else
//                             IsShipToCountyVisible := false;
//                     end;
//                 }
//                 field("Ship-to Name"; Rec."Ship-to Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Name';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                 }
//                 field("Ship-to Address"; Rec."Ship-to Address")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Address';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                     QuickEntry = false;
//                 }
//                 field("Ship-to Address 2"; Rec."Ship-to Address 2")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Address 2';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                     QuickEntry = false;
//                 }
//                 field("Ship-to City"; Rec."Ship-to City")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'City';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                     QuickEntry = false;
//                 }
//                 group(Control297)
//                 {
//                     ShowCaption = false;
//                     Visible = IsShipToCountyVisible;
//                     field("Ship-to County"; Rec."Ship-to County")
//                     {
//                         ApplicationArea = All;
//                         Caption = 'County';
//                         Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                         QuickEntry = false;
//                     }
//                 }
//                 field("Ship-to Post Code"; Rec."Ship-to Post Code")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Post Code';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                     QuickEntry = false;
//                 }
//                 field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Country/Region';
//                     Editable = ShipToOptions = ShipToOptions::"Custom Address";
//                     Importance = Additional;
//                     QuickEntry = false;

                    trigger OnValidate()
                    begin
                        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
                    end;
                }
            }
            field("Ship-to Contact"; Rec."Ship-to Contact")
            {
                ApplicationArea = All;
                Caption = 'Contact';
            }

        }
    }

//     var
//         IsSalesLinesEditable: Boolean;
//         SalesHeader: Record "Sales Header";
//         TransferHeader: Record "Transfer Header";
//         SalesOrder: Page "Sales Order";
//         CustRec: Record Customer;
//         ChangeExchangeRate: Page "Change Exchange Rate";
//         ShipToOptions: Enum "Sales Ship-to Options";
//         ShipToAddressList: Page "Ship-to Address List";
//         ShipToAddress: Record "Ship-to Address";
//         IsShipToCountyVisible: Boolean;
//         FormatAddress: Codeunit "Format Address";
//         Currency: record Currency;
//         DocumentTotals: Codeunit "Document Totals";

//     local procedure SelltoCustomerNoOnAfterValidate(var TransferHeader: Record "Transfer Header"; var xTransferHeader: Record "Transfer Header")
//     begin

//         if SalesHeader.GetFilter("Sell-to Customer No.") = xTransferHeader."Sell-to Customer No." then
//             if SalesHeader."Sell-to Customer No." <> xTransferHeader."Sell-to Customer No." then
//                 SalesHeader.SetRange("Sell-to Customer No.");

//         OnAfterSelltoCustomerNoOnAfterValidate(Rec, xRec);
//     end;

//     local procedure OnBeforeSelltoCustomerNoOnAfterValidate(Rec: Record "Transfer Header"; xRec: Record "Transfer Header"; var IsHandled: Boolean)
//     begin
//     end;

//     local procedure OnAfterSelltoCustomerNoOnAfterValidate(Rec: Record "Transfer Header"; xRec: Record "Transfer Header")
//     begin
//     end;

//     local procedure OnAfterValidateShippingOptions(var TransferHeader: Record "Transfer Header"; ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address")
//     begin
//     end;

//     local procedure OnBeforeValidateShipToOptions(var TransferHeader: Record "Transfer Header"; ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address"; var IsHandled: Boolean)
//     begin
//     end;

    local procedure OnValidateShipToOptionsOnAfterShipToAddressListGetRecord(var ShipToAddress: Record "Ship-to Address"; var SalesHeader: Record "Transfer Header")
    begin
    end;

}