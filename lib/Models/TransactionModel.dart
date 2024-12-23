// To parse this JSON data, do
//
//     final cardTransation = cardTransationFromMap(jsonString);

import 'dart:convert';

CardTransation cardTransationFromMap(String str) => CardTransation.fromMap(json.decode(str));

String cardTransationToMap(CardTransation data) => json.encode(data.toMap());

class CardTransation {
    int count;
    int startIndex;
    int endIndex;
    bool isMore;
    List<Datum> data;

    CardTransation({
        required this.count,
        required this.startIndex,
        required this.endIndex,
        required this.isMore,
        required this.data,
    });

    factory CardTransation.fromMap(Map<String, dynamic> json) => CardTransation(
        count: json["count"],
        startIndex: json["start_index"],
        endIndex: json["end_index"],
        isMore: json["is_more"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "count": count,
        "start_index": startIndex,
        "end_index": endIndex,
        "is_more": isMore,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
    };
}

class Datum {
    Type type;
    String state;
    String identifier;
    String token;
    String userToken;
    String actingUserToken;
    Gpa gpa;
    DateTime createdTime;
    DateTime userTransactionTime;
    double amount;
    CurrencyCode currencyCode;
    Response? response;
    PeerTransfer? peerTransfer;
    User user;
    GpaOrder? gpaOrder;
    int? duration;
    String? precedingRelatedTransactionToken;

    Datum({
        required this.type,
        required this.state,
        required this.identifier,
        required this.token,
        required this.userToken,
        required this.actingUserToken,
        required this.gpa,
        required this.createdTime,
        required this.userTransactionTime,
        required this.amount,
        required this.currencyCode,
        this.response,
        this.peerTransfer,
        required this.user,
        this.gpaOrder,
        this.duration,
        this.precedingRelatedTransactionToken,
    });

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        type: typeValues.map[json["type"]]!,
        state: json["state"]!,
        identifier: json["identifier"],
        token: json["token"],
        userToken: json["user_token"],
        actingUserToken: json["acting_user_token"],
        gpa: Gpa.fromMap(json["gpa"]),
        createdTime: DateTime.parse(json["created_time"]),
        userTransactionTime: DateTime.parse(json["user_transaction_time"]),
        amount: json["amount"].toDouble(),
        currencyCode: currencyCodeValues.map[json["currency_code"]]!,
        response: json["response"] == null ? null : Response.fromMap(json["response"]),
        peerTransfer: json["peer_transfer"] == null ? null : PeerTransfer.fromMap(json["peer_transfer"]),
        user: User.fromMap(json["user"]),
        gpaOrder: json["gpa_order"] == null ? null : GpaOrder.fromMap(json["gpa_order"]),
        duration: json["duration"],
        precedingRelatedTransactionToken: json["preceding_related_transaction_token"],
    );

    Map<String, dynamic> toMap() => {
        "type": typeValues.reverse[type],
        "state": state,
        "identifier": identifier,
        "token": token,
        "user_token": userToken,
        "acting_user_token": actingUserToken,
        "gpa": gpa.toMap(),
        "created_time": createdTime.toIso8601String(),
        "user_transaction_time": userTransactionTime.toIso8601String(),
        "amount": amount,
        "currency_code": currencyCodeValues.reverse[currencyCode],
        "response": response?.toMap(),
        "peer_transfer": peerTransfer?.toMap(),
        "user": user.toMap(),
        "gpa_order": gpaOrder?.toMap(),
        "duration": duration,
        "preceding_related_transaction_token": precedingRelatedTransactionToken,
    };
}

enum CurrencyCode {
    USD
}

final currencyCodeValues = EnumValues({
    "USD": CurrencyCode.USD
});

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
    CurrencyCode currencyCode;
    double ledgerBalance;
    double  availableBalance;
    double  creditBalance;
    double  pendingCredits;
    double  impactedAmount;
    Balances? balances;

    Gpa({
        required this.currencyCode,
        required this.ledgerBalance,
        required this.availableBalance,
        required this.creditBalance,
        required this.pendingCredits,
        required this.impactedAmount,
        this.balances,
    });

    factory Gpa.fromMap(Map<String, dynamic> json) => Gpa(
        currencyCode: currencyCodeValues.map[json["currency_code"]]!,
        ledgerBalance: json["ledger_balance"].toDouble(),
        availableBalance: json["available_balance"].toDouble(),
        creditBalance: json["credit_balance"].toDouble(),
        pendingCredits: json["pending_credits"].toDouble(),
        impactedAmount: json["impacted_amount"].toDouble(),
        balances: json["balances"] == null ? null : Balances.fromMap(json["balances"]),
    );

    Map<String, dynamic> toMap() => {
        "currency_code": currencyCodeValues.reverse[currencyCode],
        "ledger_balance": ledgerBalance,
        "available_balance": availableBalance,
        "credit_balance": creditBalance,
        "pending_credits": pendingCredits,
        "impacted_amount": impactedAmount,
        "balances": balances?.toMap(),
    };
}

class GpaOrder {
    String token;
    double amount;
    DateTime createdTime;
    DateTime lastModifiedTime;
    String transactionToken;
    String state;
    Response response;
    String? tags;
    Funding funding;
    String fundingSourceToken;
    String userToken;
    CurrencyCode currencyCode;

    GpaOrder({
        required this.token,
        required this.amount,
        required this.createdTime,
        required this.lastModifiedTime,
        required this.transactionToken,
        required this.state,
        required this.response,
        required this.funding,
        required this.fundingSourceToken,
        required this.userToken,
        required this.currencyCode,
        this.tags
    });

    factory GpaOrder.fromMap(Map<String, dynamic> json) => GpaOrder(
        token: json["token"],
        amount: json["amount"].toDouble(),
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.parse(json["last_modified_time"]),
        transactionToken: json["transaction_token"],
        state: json["state"]!,
        tags: json["tags"],
        response: Response.fromMap(json["response"]),
        funding: Funding.fromMap(json["funding"]),
        fundingSourceToken: json["funding_source_token"],
        userToken: json["user_token"],
        currencyCode: currencyCodeValues.map[json["currency_code"]]!,
    );

    Map<String, dynamic> toMap() => {
        "token": token,
        "amount": amount,
        "created_time": createdTime.toIso8601String(),
        "last_modified_time": lastModifiedTime.toIso8601String(),
        "transaction_token": transactionToken,
        "state": state,
        "response": response.toMap(),
        "funding": funding.toMap(),
        "funding_source_token": fundingSourceToken,
        "user_token": userToken,
        "currency_code": currencyCodeValues.reverse[currencyCode],
    };
}

class Funding {
    double amount;
    Source source;

    Funding({
        required this.amount,
        required this.source,
    });

    factory Funding.fromMap(Map<String, dynamic> json) => Funding(
        amount: json["amount"].toDouble(),
        source: Source.fromMap(json["source"]),
    );

    Map<String, dynamic> toMap() => {
        "amount": amount,
        "source": source.toMap(),
    };
}

class Source {
    String type;
    String token;
    String name;
    bool active;
    bool isDefaultAccount;
    DateTime createdTime;
    DateTime lastModifiedTime;

    Source({
        required this.type,
        required this.token,
        required this.name,
        required this.active,
        required this.isDefaultAccount,
        required this.createdTime,
        required this.lastModifiedTime,
    });

    factory Source.fromMap(Map<String, dynamic> json) => Source(
        type: json["type"],
        token: json["token"],
        name: json["name"],
        active: json["active"],
        isDefaultAccount: json["is_default_account"],
        createdTime: DateTime.parse(json["created_time"]),
        lastModifiedTime: DateTime.parse(json["last_modified_time"]),
    );

    Map<String, dynamic> toMap() => {
        "type": type,
        "token": token,
        "name": name,
        "active": active,
        "is_default_account": isDefaultAccount,
        "created_time": createdTime.toIso8601String(),
        "last_modified_time": lastModifiedTime.toIso8601String(),
    };
}

class Response {
    String code;
    String memo;

    Response({
        required this.code,
        required this.memo,
    });

    factory Response.fromMap(Map<String, dynamic> json) => Response(
        code: json["code"],
        memo: json["memo"],
    );

    Map<String, dynamic> toMap() => {
        "code": code,
        "memo": memo,
    };
}


class PeerTransfer {
    String token;
    double amount;
    String? memo;
    String? tags;
    CurrencyCode currencyCode;
    String senderUserToken;
    String recipientUserToken;
    DateTime createdTime;

    PeerTransfer({
        required this.token,
        required this.amount,
        this.memo,
        required this.currencyCode,
        required this.senderUserToken,
        required this.recipientUserToken,
        required this.createdTime,
        this.tags
    });

    factory PeerTransfer.fromMap(Map<String, dynamic> json) => PeerTransfer(
        token: json["token"],
        amount: json["amount"].toDouble(),
        memo: json["memo"],
        tags: json["tags"],
        currencyCode: currencyCodeValues.map[json["currency_code"]]!,
        senderUserToken: json["sender_user_token"],
        recipientUserToken: json["recipient_user_token"],
        createdTime: DateTime.parse(json["created_time"]),
    );

    Map<String, dynamic> toMap() => {
        "token": token,
        "amount": amount,
        "memo": memo,
        "currency_code": currencyCodeValues.reverse[currencyCode],
        "sender_user_token": senderUserToken,
        "recipient_user_token": recipientUserToken,
        "created_time": createdTime.toIso8601String(),
    };
}

enum Type {
    GPA_CREDIT,
    TRANSFER_PEER
}

final typeValues = EnumValues({
    "gpa.credit": Type.GPA_CREDIT,
    "transfer.peer": Type.TRANSFER_PEER
});

class User {
    Metadata metadata;

    User({
        required this.metadata,
    });

    factory User.fromMap(Map<String, dynamic> json) => User(
        metadata: Metadata.fromMap(json["metadata"]),
    );

    Map<String, dynamic> toMap() => {
        "metadata": metadata.toMap(),
    };
}

class Metadata {
    Metadata();

    factory Metadata.fromMap(Map<String, dynamic> json) => Metadata(
    );

    Map<String, dynamic> toMap() => {
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
