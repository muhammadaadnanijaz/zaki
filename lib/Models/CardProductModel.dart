// To parse this JSON data, do
//
//     final cardProductModel = cardProductModelFromMap(jsonString);

import 'dart:convert';

CardProductModel cardProductModelFromMap(String str) => CardProductModel.fromMap(json.decode(str));

String cardProductModelToMap(CardProductModel data) => json.encode(data.toMap());

class CardProductModel {
    String token;
    String name;
    bool active;
    DateTime startDate;
    Config config;
    DateTime createdTime;
    DateTime lastModifiedTime;

    CardProductModel({
        required this.token,
        required this.name,
        required this.active,
        required this.startDate,
        required this.config,
        required this.createdTime,
        required this.lastModifiedTime,
    });

    factory CardProductModel.fromMap(Map<String, dynamic> json) => CardProductModel(
        token: json["token"],
        name: json["name"],
        active: json["active"],
        startDate: DateTime.parse(json["start_date"]),
        config: Config.fromMap(json["config"]),
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.parse(json["last_modified_time"]),
    );

    Map<String, dynamic> toMap() => {
        "token": token,
        "name": name,
        "active": active,
        "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "config": config.toMap(),
        "created_time": createdTime.toIso8601String(),
        "last_modified_time": lastModifiedTime.toIso8601String(),
    };
}

class Config {
    Poi poi;
    TransactionControls transactionControls;
    SelectiveAuth selectiveAuth;
    Special special;
    CardLifeCycle cardLifeCycle;
    ClearingAndSettlement clearingAndSettlement;
    JitFunding jitFunding;
    DigitalWalletTokenization digitalWalletTokenization;
    Fulfillment fulfillment;

    Config({
        required this.poi,
        required this.transactionControls,
        required this.selectiveAuth,
        required this.special,
        required this.cardLifeCycle,
        required this.clearingAndSettlement,
        required this.jitFunding,
        required this.digitalWalletTokenization,
        required this.fulfillment,
    });

    factory Config.fromMap(Map<String, dynamic> json) => Config(
        poi: Poi.fromMap(json["poi"]),
        transactionControls: TransactionControls.fromMap(json["transaction_controls"]),
        selectiveAuth: SelectiveAuth.fromMap(json["selective_auth"]),
        special: Special.fromMap(json["special"]),
        cardLifeCycle: CardLifeCycle.fromMap(json["card_life_cycle"]),
        clearingAndSettlement: ClearingAndSettlement.fromMap(json["clearing_and_settlement"]),
        jitFunding: JitFunding.fromMap(json["jit_funding"]),
        digitalWalletTokenization: DigitalWalletTokenization.fromMap(json["digital_wallet_tokenization"]),
        fulfillment: Fulfillment.fromMap(json["fulfillment"]),
    );

    Map<String, dynamic> toMap() => {
        "poi": poi.toMap(),
        "transaction_controls": transactionControls.toMap(),
        "selective_auth": selectiveAuth.toMap(),
        "special": special.toMap(),
        "card_life_cycle": cardLifeCycle.toMap(),
        "clearing_and_settlement": clearingAndSettlement.toMap(),
        "jit_funding": jitFunding.toMap(),
        "digital_wallet_tokenization": digitalWalletTokenization.toMap(),
        "fulfillment": fulfillment.toMap(),
    };
}

class CardLifeCycle {
    bool activateUponIssue;
    ExpirationOffset expirationOffset;
    int cardServiceCode;
    bool updateExpirationUponActivation;

    CardLifeCycle({
        required this.activateUponIssue,
        required this.expirationOffset,
        required this.cardServiceCode,
        required this.updateExpirationUponActivation,
    });

    factory CardLifeCycle.fromMap(Map<String, dynamic> json) => CardLifeCycle(
        activateUponIssue: json["activate_upon_issue"],
        expirationOffset: ExpirationOffset.fromMap(json["expiration_offset"]),
        cardServiceCode: json["card_service_code"],
        updateExpirationUponActivation: json["update_expiration_upon_activation"],
    );

    Map<String, dynamic> toMap() => {
        "activate_upon_issue": activateUponIssue,
        "expiration_offset": expirationOffset.toMap(),
        "card_service_code": cardServiceCode,
        "update_expiration_upon_activation": updateExpirationUponActivation,
    };
}

class ExpirationOffset {
    String unit;
    int value;

    ExpirationOffset({
        required this.unit,
        required this.value,
    });

    factory ExpirationOffset.fromMap(Map<String, dynamic> json) => ExpirationOffset(
        unit: json["unit"],
        value: json["value"],
    );

    Map<String, dynamic> toMap() => {
        "unit": unit,
        "value": value,
    };
}

class ClearingAndSettlement {
    String overdraftDestination;

    ClearingAndSettlement({
        required this.overdraftDestination,
    });

    factory ClearingAndSettlement.fromMap(Map<String, dynamic> json) => ClearingAndSettlement(
        overdraftDestination: json["overdraft_destination"],
    );

    Map<String, dynamic> toMap() => {
        "overdraft_destination": overdraftDestination,
    };
}

class DigitalWalletTokenization {
    ProvisioningControls provisioningControls;
    String cardArtId;

    DigitalWalletTokenization({
        required this.provisioningControls,
        required this.cardArtId,
    });

    factory DigitalWalletTokenization.fromMap(Map<String, dynamic> json) => DigitalWalletTokenization(
        provisioningControls: ProvisioningControls.fromMap(json["provisioning_controls"]),
        cardArtId: json["card_art_id"],
    );

    Map<String, dynamic> toMap() => {
        "provisioning_controls": provisioningControls.toMap(),
        "card_art_id": cardArtId,
    };
}

class ProvisioningControls {
    InAppProvisioning manualEntry;
    InAppProvisioning walletProviderCardOnFile;
    InAppProvisioning inAppProvisioning;
    WebPushProvisioning webPushProvisioning;
    bool forceYellowPathForCardProduct;

    ProvisioningControls({
        required this.manualEntry,
        required this.walletProviderCardOnFile,
        required this.inAppProvisioning,
        required this.webPushProvisioning,
        required this.forceYellowPathForCardProduct,
    });

    factory ProvisioningControls.fromMap(Map<String, dynamic> json) => ProvisioningControls(
        manualEntry: InAppProvisioning.fromMap(json["manual_entry"]),
        walletProviderCardOnFile: InAppProvisioning.fromMap(json["wallet_provider_card_on_file"]),
        inAppProvisioning: InAppProvisioning.fromMap(json["in_app_provisioning"]),
        webPushProvisioning: WebPushProvisioning.fromMap(json["web_push_provisioning"]),
        forceYellowPathForCardProduct: json["force_yellow_path_for_card_product"],
    );

    Map<String, dynamic> toMap() => {
        "manual_entry": manualEntry.toMap(),
        "wallet_provider_card_on_file": walletProviderCardOnFile.toMap(),
        "in_app_provisioning": inAppProvisioning.toMap(),
        "web_push_provisioning": webPushProvisioning.toMap(),
        "force_yellow_path_for_card_product": forceYellowPathForCardProduct,
    };
}

class InAppProvisioning {
    bool enabled;
    InAppProvisioningAddressVerification addressVerification;

    InAppProvisioning({
        required this.enabled,
        required this.addressVerification,
    });

    factory InAppProvisioning.fromMap(Map<String, dynamic> json) => InAppProvisioning(
        enabled: json["enabled"],
        addressVerification: InAppProvisioningAddressVerification.fromMap(json["address_verification"]),
    );

    Map<String, dynamic> toMap() => {
        "enabled": enabled,
        "address_verification": addressVerification.toMap(),
    };
}

class InAppProvisioningAddressVerification {
    bool validate;

    InAppProvisioningAddressVerification({
        required this.validate,
    });

    factory InAppProvisioningAddressVerification.fromMap(Map<String, dynamic> json) => InAppProvisioningAddressVerification(
        validate: json["validate"],
    );

    Map<String, dynamic> toMap() => {
        "validate": validate,
    };
}

class WebPushProvisioning {
    String wppApplePartnerId;
    String wppAppleCardTemplateId;
    String wppGooglePiaid;

    WebPushProvisioning({
        required this.wppApplePartnerId,
        required this.wppAppleCardTemplateId,
        required this.wppGooglePiaid,
    });

    factory WebPushProvisioning.fromMap(Map<String, dynamic> json) => WebPushProvisioning(
        wppApplePartnerId: json["wpp_apple_partner_id"],
        wppAppleCardTemplateId: json["wpp_apple_card_template_id"],
        wppGooglePiaid: json["wpp_google_piaid"],
    );

    Map<String, dynamic> toMap() => {
        "wpp_apple_partner_id": wppApplePartnerId,
        "wpp_apple_card_template_id": wppAppleCardTemplateId,
        "wpp_google_piaid": wppGooglePiaid,
    };
}

class Fulfillment {
    Shipping shipping;
    String paymentInstrument;
    String packageId;
    bool allZeroCardSecurityCode;
    String binPrefix;
    bool bulkShip;
    String panLength;
    String fulfillmentProvider;
    bool allowCardCreation;
    bool uppercaseNameLines;
    bool enableOfflinePin;

    Fulfillment({
        required this.shipping,
        required this.paymentInstrument,
        required this.packageId,
        required this.allZeroCardSecurityCode,
        required this.binPrefix,
        required this.bulkShip,
        required this.panLength,
        required this.fulfillmentProvider,
        required this.allowCardCreation,
        required this.uppercaseNameLines,
        required this.enableOfflinePin,
    });

    factory Fulfillment.fromMap(Map<String, dynamic> json) => Fulfillment(
        shipping: Shipping.fromMap(json["shipping"]),
        paymentInstrument: json["payment_instrument"],
        packageId: json["package_id"],
        allZeroCardSecurityCode: json["all_zero_card_security_code"],
        binPrefix: json["bin_prefix"],
        bulkShip: json["bulk_ship"],
        panLength: json["pan_length"],
        fulfillmentProvider: json["fulfillment_provider"],
        allowCardCreation: json["allow_card_creation"],
        uppercaseNameLines: json["uppercase_name_lines"],
        enableOfflinePin: json["enable_offline_pin"],
    );

    Map<String, dynamic> toMap() => {
        "shipping": shipping.toMap(),
        "payment_instrument": paymentInstrument,
        "package_id": packageId,
        "all_zero_card_security_code": allZeroCardSecurityCode,
        "bin_prefix": binPrefix,
        "bulk_ship": bulkShip,
        "pan_length": panLength,
        "fulfillment_provider": fulfillmentProvider,
        "allow_card_creation": allowCardCreation,
        "uppercase_name_lines": uppercaseNameLines,
        "enable_offline_pin": enableOfflinePin,
    };
}

class Shipping {
    ReturnAddress returnAddress;
    RecipientAddress recipientAddress;

    Shipping({
        required this.returnAddress,
        required this.recipientAddress,
    });

    factory Shipping.fromMap(Map<String, dynamic> json) => Shipping(
        returnAddress: ReturnAddress.fromMap(json["return_address"]),
        recipientAddress: RecipientAddress.fromMap(json["recipient_address"]),
    );

    Map<String, dynamic> toMap() => {
        "return_address": returnAddress.toMap(),
        "recipient_address": recipientAddress.toMap(),
    };
}

class RecipientAddress {
    String firstName;
    String lastName;
    String address1;
    String city;
    String state;
    String postalCode;
    String country;
    String phone;

    RecipientAddress({
        required this.firstName,
        required this.lastName,
        required this.address1,
        required this.city,
        required this.state,
        required this.postalCode,
        required this.country,
        required this.phone,
    });

    factory RecipientAddress.fromMap(Map<String, dynamic> json) => RecipientAddress(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address1"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        country: json["country"],
        phone: json["phone"],
    );

    Map<String, dynamic> toMap() => {
        "first_name": firstName,
        "last_name": lastName,
        "address1": address1,
        "city": city,
        "state": state,
        "postal_code": postalCode,
        "country": country,
        "phone": phone,
    };
}

class ReturnAddress {
    String address1;
    String city;
    String country;

    ReturnAddress({
        required this.address1,
        required this.city,
        required this.country,
    });

    factory ReturnAddress.fromMap(Map<String, dynamic> json) => ReturnAddress(
        address1: json["address1"],
        city: json["city"],
        country: json["country"],
    );

    Map<String, dynamic> toMap() => {
        "address1": address1,
        "city": city,
        "country": country,
    };
}

class JitFunding {
    PaymentcardFundingSource paymentcardFundingSource;
    ProgramFundingSource programgatewayFundingSource;
    ProgramFundingSource programFundingSource;

    JitFunding({
        required this.paymentcardFundingSource,
        required this.programgatewayFundingSource,
        required this.programFundingSource,
    });

    factory JitFunding.fromMap(Map<String, dynamic> json) => JitFunding(
        paymentcardFundingSource: PaymentcardFundingSource.fromMap(json["paymentcard_funding_source"]),
        programgatewayFundingSource: ProgramFundingSource.fromMap(json["programgateway_funding_source"]),
        programFundingSource: ProgramFundingSource.fromMap(json["program_funding_source"]),
    );

    Map<String, dynamic> toMap() => {
        "paymentcard_funding_source": paymentcardFundingSource.toMap(),
        "programgateway_funding_source": programgatewayFundingSource.toMap(),
        "program_funding_source": programFundingSource.toMap(),
    };
}

class PaymentcardFundingSource {
    bool enabled;
    String refundsDestination;

    PaymentcardFundingSource({
        required this.enabled,
        required this.refundsDestination,
    });

    factory PaymentcardFundingSource.fromMap(Map<String, dynamic> json) => PaymentcardFundingSource(
        enabled: json["enabled"],
        refundsDestination: json["refunds_destination"],
    );

    Map<String, dynamic> toMap() => {
        "enabled": enabled,
        "refunds_destination": refundsDestination,
    };
}

class ProgramFundingSource {
    bool enabled;
    String fundingSourceToken;
    String refundsDestination;
    bool? alwaysFund;

    ProgramFundingSource({
        required this.enabled,
        required this.fundingSourceToken,
        required this.refundsDestination,
        this.alwaysFund,
    });

    factory ProgramFundingSource.fromMap(Map<String, dynamic> json) => ProgramFundingSource(
        enabled: json["enabled"],
        fundingSourceToken: json["funding_source_token"],
        refundsDestination: json["refunds_destination"],
        alwaysFund: json["always_fund"],
    );

    Map<String, dynamic> toMap() => {
        "enabled": enabled,
        "funding_source_token": fundingSourceToken,
        "refunds_destination": refundsDestination,
        "always_fund": alwaysFund,
    };
}

class Poi {
    Other other;
    bool ecommerce;
    bool atm;

    Poi({
        required this.other,
        required this.ecommerce,
        required this.atm,
    });

    factory Poi.fromMap(Map<String, dynamic> json) => Poi(
        other: Other.fromMap(json["other"]),
        ecommerce: json["ecommerce"],
        atm: json["atm"],
    );

    Map<String, dynamic> toMap() => {
        "other": other.toMap(),
        "ecommerce": ecommerce,
        "atm": atm,
    };
}

class Other {
    bool allow;
    bool cardPresenceRequired;
    bool cardholderPresenceRequired;
    String track1DiscretionaryData;
    String track2DiscretionaryData;
    bool useStaticPin;

    Other({
        required this.allow,
        required this.cardPresenceRequired,
        required this.cardholderPresenceRequired,
        required this.track1DiscretionaryData,
        required this.track2DiscretionaryData,
        required this.useStaticPin,
    });

    factory Other.fromMap(Map<String, dynamic> json) => Other(
        allow: json["allow"],
        cardPresenceRequired: json["card_presence_required"],
        cardholderPresenceRequired: json["cardholder_presence_required"],
        track1DiscretionaryData: json["track1_discretionary_data"],
        track2DiscretionaryData: json["track2_discretionary_data"],
        useStaticPin: json["use_static_pin"],
    );

    Map<String, dynamic> toMap() => {
        "allow": allow,
        "card_presence_required": cardPresenceRequired,
        "cardholder_presence_required": cardholderPresenceRequired,
        "track1_discretionary_data": track1DiscretionaryData,
        "track2_discretionary_data": track2DiscretionaryData,
        "use_static_pin": useStaticPin,
    };
}

class SelectiveAuth {
    int saMode;
    bool enableRegexSearchChain;
    int dmdLocationSensitivity;

    SelectiveAuth({
        required this.saMode,
        required this.enableRegexSearchChain,
        required this.dmdLocationSensitivity,
    });

    factory SelectiveAuth.fromMap(Map<String, dynamic> json) => SelectiveAuth(
        saMode: json["sa_mode"],
        enableRegexSearchChain: json["enable_regex_search_chain"],
        dmdLocationSensitivity: json["dmd_location_sensitivity"],
    );

    Map<String, dynamic> toMap() => {
        "sa_mode": saMode,
        "enable_regex_search_chain": enableRegexSearchChain,
        "dmd_location_sensitivity": dmdLocationSensitivity,
    };
}

class Special {
    bool merchantOnBoarding;

    Special({
        required this.merchantOnBoarding,
    });

    factory Special.fromMap(Map<String, dynamic> json) => Special(
        merchantOnBoarding: json["merchant_on_boarding"],
    );

    Map<String, dynamic> toMap() => {
        "merchant_on_boarding": merchantOnBoarding,
    };
}

class TransactionControls {
    String acceptedCountriesToken;
    bool alwaysRequirePin;
    bool alwaysRequireIcc;
    bool allowGpaAuth;
    bool requireCardNotPresentCardSecurityCode;
    bool allowMccGroupAuthorizationControls;
    bool allowFirstPinSetViaFinancialTransaction;
    bool ignoreCardSuspendedState;
    bool allowChipFallback;
    bool allowNetworkLoad;
    bool allowNetworkLoadCardActivation;
    bool allowQuasiCash;
    bool enablePartialAuthApproval;
    TransactionControlsAddressVerification addressVerification;
    StrongCustomerAuthenticationLimits strongCustomerAuthenticationLimits;
    String quasiCashExemptMids;
    bool enableCreditService;

    TransactionControls({
        required this.acceptedCountriesToken,
        required this.alwaysRequirePin,
        required this.alwaysRequireIcc,
        required this.allowGpaAuth,
        required this.requireCardNotPresentCardSecurityCode,
        required this.allowMccGroupAuthorizationControls,
        required this.allowFirstPinSetViaFinancialTransaction,
        required this.ignoreCardSuspendedState,
        required this.allowChipFallback,
        required this.allowNetworkLoad,
        required this.allowNetworkLoadCardActivation,
        required this.allowQuasiCash,
        required this.enablePartialAuthApproval,
        required this.addressVerification,
        required this.strongCustomerAuthenticationLimits,
        required this.quasiCashExemptMids,
        required this.enableCreditService,
    });

    factory TransactionControls.fromMap(Map<String, dynamic> json) => TransactionControls(
        acceptedCountriesToken: json["accepted_countries_token"],
        alwaysRequirePin: json["always_require_pin"],
        alwaysRequireIcc: json["always_require_icc"],
        allowGpaAuth: json["allow_gpa_auth"],
        requireCardNotPresentCardSecurityCode: json["require_card_not_present_card_security_code"],
        allowMccGroupAuthorizationControls: json["allow_mcc_group_authorization_controls"],
        allowFirstPinSetViaFinancialTransaction: json["allow_first_pin_set_via_financial_transaction"],
        ignoreCardSuspendedState: json["ignore_card_suspended_state"],
        allowChipFallback: json["allow_chip_fallback"],
        allowNetworkLoad: json["allow_network_load"],
        allowNetworkLoadCardActivation: json["allow_network_load_card_activation"],
        allowQuasiCash: json["allow_quasi_cash"],
        enablePartialAuthApproval: json["enable_partial_auth_approval"],
        addressVerification: TransactionControlsAddressVerification.fromMap(json["address_verification"]),
        strongCustomerAuthenticationLimits: StrongCustomerAuthenticationLimits.fromMap(json["strong_customer_authentication_limits"]),
        quasiCashExemptMids: json["quasi_cash_exempt_mids"],
        enableCreditService: json["enable_credit_service"],
    );

    Map<String, dynamic> toMap() => {
        "accepted_countries_token": acceptedCountriesToken,
        "always_require_pin": alwaysRequirePin,
        "always_require_icc": alwaysRequireIcc,
        "allow_gpa_auth": allowGpaAuth,
        "require_card_not_present_card_security_code": requireCardNotPresentCardSecurityCode,
        "allow_mcc_group_authorization_controls": allowMccGroupAuthorizationControls,
        "allow_first_pin_set_via_financial_transaction": allowFirstPinSetViaFinancialTransaction,
        "ignore_card_suspended_state": ignoreCardSuspendedState,
        "allow_chip_fallback": allowChipFallback,
        "allow_network_load": allowNetworkLoad,
        "allow_network_load_card_activation": allowNetworkLoadCardActivation,
        "allow_quasi_cash": allowQuasiCash,
        "enable_partial_auth_approval": enablePartialAuthApproval,
        "address_verification": addressVerification.toMap(),
        "strong_customer_authentication_limits": strongCustomerAuthenticationLimits.toMap(),
        "quasi_cash_exempt_mids": quasiCashExemptMids,
        "enable_credit_service": enableCreditService,
    };
}

class TransactionControlsAddressVerification {
    Messages avMessages;
    Messages authMessages;

    TransactionControlsAddressVerification({
        required this.avMessages,
        required this.authMessages,
    });

    factory TransactionControlsAddressVerification.fromMap(Map<String, dynamic> json) => TransactionControlsAddressVerification(
        avMessages: Messages.fromMap(json["av_messages"]),
        authMessages: Messages.fromMap(json["auth_messages"]),
    );

    Map<String, dynamic> toMap() => {
        "av_messages": avMessages.toMap(),
        "auth_messages": authMessages.toMap(),
    };
}

class Messages {
    bool validate;
    bool declineOnAddressNumberMismatch;
    bool declineOnPostalCodeMismatch;

    Messages({
        required this.validate,
        required this.declineOnAddressNumberMismatch,
        required this.declineOnPostalCodeMismatch,
    });

    factory Messages.fromMap(Map<String, dynamic> json) => Messages(
        validate: json["validate"],
        declineOnAddressNumberMismatch: json["decline_on_address_number_mismatch"],
        declineOnPostalCodeMismatch: json["decline_on_postal_code_mismatch"],
    );

    Map<String, dynamic> toMap() => {
        "validate": validate,
        "decline_on_address_number_mismatch": declineOnAddressNumberMismatch,
        "decline_on_postal_code_mismatch": declineOnPostalCodeMismatch,
    };
}

class StrongCustomerAuthenticationLimits {
    StrongCustomerAuthenticationLimits();

    factory StrongCustomerAuthenticationLimits.fromMap(Map<String, dynamic> json) => StrongCustomerAuthenticationLimits(
    );

    Map<String, dynamic> toMap() => {
    };
}
