
tableextension 50112 "Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";
            trigger OnValidate()
            var
                Customer: Record "Customer";

            begin
                if Customer.Get("No.") then begin
                    "Sell-to Customer Name" := Customer."Name"
                end;

            end;
        }
        field(50001; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(50002; "Sell-To Customer Name"; Text[20])
        {
            Caption = 'Customer Name';
            TableRelation = Customer;

            trigger OnLookup()
            var
                CustomerName: Text;
            begin
                CustomerName := "Sell-to Customer Name";
                LookupSellToCustomerName(CustomerName);
                "Sell-to Customer Name" := CopyStr(CustomerName, 1, MaxStrLen("Sell-to Customer Name"));
            end;

        }
        field(50003; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

        }

        field(50004; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(50005; "Ship-to"; Enum "Sales Ship-to Options")
        {
            Caption = 'Ship-to';
        }
        field(50006; "Ship-to Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(50007; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }

        field(50008; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(50009; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(50010; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(50011; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(50012; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = if ("Ship-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("Ship-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Ship-to Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // OnBeforeLookupShipToCity(Rec, PostCode);

                PostCode.LookupPostCode("Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code");

                // OnAfterLookupShipToCity(Rec, PostCode, xRec);
            end;

            trigger OnValidate()
            var
            // IsHandled: Boolean;
            begin
                // IsHandled := false;
                // OnBeforeValidateShipToCity(Rec, PostCode, CurrFieldNo, IsHandled);
                // if not IsHandled then
                PostCode.ValidateCity(
                    "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50013; "Ship-to County"; Text[30])
        {
            CaptionClass = '5,4,' + "Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(50014; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = if ("Ship-to Country/Region Code" = const('')) "Post Code"
            else
            if ("Ship-to Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Ship-to Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // OnBeforeLookupShipToPostCode(Rec, PostCode);

                PostCode.LookupPostCode("Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code");

                // OnAfterLookupShipToPostCode(Rec, PostCode, xRec);
            end;

            trigger OnValidate()
            var
            // IsHandled: Boolean;
            begin
                // IsHandled := false;
                // OnBeforeValidateShipToPostCode(Rec, PostCode, CurrFieldNo, IsHandled);
                // if not IsHandled then
                PostCode.ValidatePostCode(
                    "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(50015; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }

        field(81; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';

            trigger OnValidate()
            begin
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Address"));
                // ModifyCustomerAddress();
            end;
        }

        field(50016; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';

            trigger OnValidate()
            begin
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Address 2"));
                // ModifyCustomerAddress();
            end;
        }

        field(50017; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
            TableRelation = if ("Sell-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("Sell-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Sell-to Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // OnBeforeLookupSellToCity(Rec, PostCode);

                PostCode.LookupPostCode("Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code");

                // OnAfterLookupSellToCity(Rec, PostCode, xRec);
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                // OnBeforeValidateSellToCity(Rec, PostCode, CurrFieldNo, IsHandled);
                if not IsHandled then
                    PostCode.ValidateCity(
                        "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to City"));
                // ModifyCustomerAddress();
            end;
        }

        field(50018; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';

            trigger OnLookup()
            var
                Contact: Record Contact;
                IsHandled: Boolean;
            begin
                IsHandled := false;
                // OnBeforeLookupSelltoContact(Rec, xRec, IsHandled);
                if IsHandled then
                    exit;

                if "Document Type" <> "Document Type"::Quote then
                    if "Sell-to Customer No." = '' then
                        exit;

                Contact.FilterGroup(2);
                // LookupContact("Sell-to Customer No.", "Sell-to Contact No.", Contact);
                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("Sell-to Contact No.", Contact."No.");
                Contact.FilterGroup(0);
            end;

            trigger OnValidate()
            begin
                if "Sell-to Contact" = '' then
                    Validate("Sell-to Contact No.", '');
                // ModifyCustomerAddress();
            end;
        }

        field(50019; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                FormatAddress: Codeunit "Format Address";
            begin
                if not FormatAddress.UseCounty(Rec."Sell-to Country/Region Code") then
                    "Sell-to County" := '';
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Country/Region Code"));
                // ModifyCustomerAddress();
                Validate("Ship-to Country/Region Code");
            end;
        }

        field(50020; "Sell-to County"; Text[30])
        {
            CaptionClass = '5,2,' + "Sell-to Country/Region Code";
            Caption = 'Sell-to County';

            trigger OnValidate()
            begin
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to County"));
                // ModifyCustomerAddress();
            end;
        }

        field(50021; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = if ("Sell-to Country/Region Code" = const('')) "Post Code"
            else
            if ("Sell-to Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Sell-to Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                // OnBeforeLookupSellToPostCode(Rec, PostCode);

                PostCode.LookupPostCode("Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code");

                // OnAfterLookupSellToPostCode(Rec, PostCode, xRec);
            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
                DoExit: Boolean;
            begin
                IsHandled := false;
                // OnBeforeValidateSellToPostCode(Rec, PostCode, CurrFieldNo, IsHandled, DoExit);
                if DoExit then
                    exit;

                if not IsHandled then
                    PostCode.ValidatePostCode(
                        "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                // UpdateShipToAddressFromSellToAddress(FieldNo("Ship-to Post Code"));
                // ModifyCustomerAddress();
            end;
        }

        field(50022; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            begin
                // SelltoContactLookup();
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                Opportunity: Record Opportunity;
                IsHandled: Boolean;
                ShouldUpdateOpportunity: Boolean;
            begin
                // TestStatusOpen();

                // if "Sell-to Contact No." <> '' then
                //     if Cont.Get("Sell-to Contact No.") then
                //         Cont.CheckIfPrivacyBlockedGeneric();

                // IsHandled := false;
                // OnValidateSellToContactNoOnAfterContCheckIfPrivacyBlockedGeneric(Rec, xRec, IsHandled);
                // if IsHandled then
                //     exit;

                // if ("Sell-to Contact No." <> xRec."Sell-to Contact No.") and
                //    (xRec."Sell-to Contact No." <> '')
                // then begin
                //     if ("Sell-to Contact No." = '') and ("Opportunity No." <> '') then
                //         Error(Text049, FieldCaption("Sell-to Contact No."));
                //     IsHandled := false;
                //     OnBeforeConfirmSellToContactNoChange(Rec, xRec, CurrFieldNo, Confirmed, IsHandled);
                //     if not IsHandled then
                //         if GetHideValidationDialog() or not GuiAllowed then
                //             Confirmed := true
                //         else
                //             Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Sell-to Contact No."));
                //     if Confirmed then begin
                //         if InitFromContact("Sell-to Contact No.", "Sell-to Customer No.", FieldCaption("Sell-to Contact No.")) then
                //             exit;
                //         ShouldUpdateOpportunity := "Opportunity No." <> '';
                //         OnValidateSelltoContactNoOnAfterCalcShouldUpdateOpportunity(Rec, ShouldUpdateOpportunity);
                //         if ShouldUpdateOpportunity then begin
                //             Opportunity.Get("Opportunity No.");
                //             if Opportunity."Contact No." <> "Sell-to Contact No." then begin
                //                 Modify();
                //                 Opportunity.Validate("Contact No.", "Sell-to Contact No.");
                //                 Opportunity.Modify();
                //             end
                //         end;
                //     end else begin
                //         Rec := xRec;
                //         exit;
                //     end;
                // end;

                // if ("Sell-to Customer No." <> '') and ("Sell-to Contact No." <> '') then
                //     CheckContactRelatedToCustomerCompany("Sell-to Contact No.", "Sell-to Customer No.", CurrFieldNo);

                // IsHandled := false;
                // OnValidateSelltoContactNoOnBeforeValidateSalespersonCode(Rec, Cont, IsHandled);
                // if not IsHandled then
                //     if "Sell-to Contact No." <> '' then
                //         if Cont.Get("Sell-to Contact No.") then
                //             if ("Salesperson Code" = '') and (Cont."Salesperson Code" <> '') then
                //                 Validate("Salesperson Code", Cont."Salesperson Code");

                // if ("Sell-to Contact No." <> xRec."Sell-to Contact No.") then
                //     UpdateSellToCust("Sell-to Contact No.");
                // UpdateSellToCustTemplateCode();
                // UpdateShipToContact();
                // GetShippingTime(FieldNo("Sell-to Contact No."));
            end;
        }
        field(50023; "Total Excl.VAT"; Decimal)
        {
            Caption = 'Total Excl.VAT';
        }
        field(50024; "Payment Terms Code"; Code[500])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }

    }
    var
        SalesHeader: Record "Sales Header";
        ShipToOptions: Enum "Sales Ship-to Options";
        PostCode: Record "Post Code";

    procedure CopySellToAddressToShipToAddressInTransfer()
    var
        TransferHeader: Record "Transfer Header";
    begin
        TransferHeader.Get("No.");
        "Ship-to Address" := "Sell-to Address";
        "Ship-to Address 2" := "Sell-to Address 2";
        "Ship-to City" := "Sell-to City";
        "Ship-to Contact" := "Sell-to Contact";
        "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
        "Ship-to County" := "Sell-to County";
        "Ship-to Post Code" := "Sell-to Post Code";

    end;

    procedure LookupSellToCustomerName(var CustomerName: Text): Boolean
    var
        Customer: Record Customer;
        LookupStateManager: Codeunit "Lookup State Manager";
        RecVariant: Variant;
        SearchCustomerName: Text;
    begin
        SearchCustomerName := CustomerName;
        Customer.SetFilter("Date Filter", GetFilter("Date Filter"));
        if "Sell-to Customer No." <> '' then
            Customer.Get("Sell-to Customer No.");

        if Customer.SelectCustomer(Customer) then begin
            if Rec."Sell-to Customer Name" = Customer.Name then
                CustomerName := SearchCustomerName
            else
                CustomerName := Customer.Name;
            RecVariant := Customer;
            LookupStateManager.SaveRecord(RecVariant);
            exit(true);
        end;
    end;

    local procedure OnAfterValidateShippingOptions(var TransferHeader: Record "Transfer Header"; ShipToOptions: Option "Default (Sell-to Address)","Alternate Shipping Address","Custom Address")
    begin
    end;

}
