// To parse this JSON data, do
//
//     final balanceModel = balanceModelFromMap(jsonString);

import 'dart:convert';

BalanceModel balanceModelFromMap(String str) => BalanceModel.fromMap(json.decode(str));

String balanceModelToMap(BalanceModel data) => json.encode(data.toMap());

class BalanceModel {
    Gpa gpa;
    List<Link> links;

    BalanceModel({
        required this.gpa,
        required this.links,
    });

    factory BalanceModel.fromMap(Map<String, dynamic> json) => BalanceModel(
        gpa: Gpa.fromMap(json["gpa"]),
        links: List<Link>.from(json["links"].map((x) => Link.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "gpa": gpa.toMap(),
        "links": List<dynamic>.from(links.map((x) => x.toMap())),
    };
}

class Balances {
    Gpa usd;

    Balances({
        required this.usd,
    });

    factory Balances.fromMap(Map<String, dynamic> json) => Balances(
        usd: Gpa.fromMap(json["USD"]),
    );

    Map<String, dynamic> toMap() => {
        "USD": usd.toMap(),
    };
}

class Gpa {
    String currencyCode;
    double ledgerBalance;
    double availableBalance;
    double creditBalance;
    double pendingCredits;
    Balances? balances;

    Gpa({
        required this.currencyCode,
        required this.ledgerBalance,
        required this.availableBalance,
        required this.creditBalance,
        required this.pendingCredits,
        this.balances,
    });

    factory Gpa.fromMap(Map<String, dynamic> json) => Gpa(
        currencyCode: json["currency_code"],
        ledgerBalance: json["ledger_balance"],
        availableBalance: json["available_balance"],
        creditBalance: json["credit_balance"],
        pendingCredits: json["pending_credits"],
        balances: json["balances"] == null ? null : Balances.fromMap(json["balances"]),
    );

    Map<String, dynamic> toMap() => {
        "currency_code": currencyCode,
        "ledger_balance": ledgerBalance,
        "available_balance": availableBalance,
        "credit_balance": creditBalance,
        "pending_credits": pendingCredits,
        "balances": balances?.toMap(),
    };
}

class Link {
    String rel;
    String method;
    String href;

    Link({
        required this.rel,
        required this.method,
        required this.href,
    });

    factory Link.fromMap(Map<String, dynamic> json) => Link(
        rel: json["rel"],
        method: json["method"],
        href: json["href"],
    );

    Map<String, dynamic> toMap() => {
        "rel": rel,
        "method": method,
        "href": href,
    };
}
