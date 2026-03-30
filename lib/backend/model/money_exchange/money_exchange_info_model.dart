// To parse this JSON data, do
//
//     final moneyExchangeInfoModel = moneyExchangeInfoModelFromJson(jsonString);

import 'dart:convert';

MoneyExchangeInfoModel moneyExchangeInfoModelFromJson(String str) => MoneyExchangeInfoModel.fromJson(json.decode(str));

String moneyExchangeInfoModelToJson(MoneyExchangeInfoModel data) => json.encode(data.toJson());

class MoneyExchangeInfoModel {
    Message message;
    Data data;

    MoneyExchangeInfoModel({
        required this.message,
        required this.data,
    });

    factory MoneyExchangeInfoModel.fromJson(Map<String, dynamic> json) => MoneyExchangeInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
    };
}

class Data {
    dynamic baseCurr;
    dynamic baseCurrRate;
    GetRemainingFields getRemainingFields;
    Charges charges;
    List<dynamic> transactions;

    Data({
        required this.baseCurr,
        required this.baseCurrRate,
        required this.getRemainingFields,
        required this.charges,
        required this.transactions,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"]??"",
        baseCurrRate: json["base_curr_rate"],
        getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),
        charges: Charges.fromJson(json["charges"]),
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),
        "charges": charges.toJson(),
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
    };
}

class Charges {

  final dynamic id;
  final dynamic slug;
  final dynamic title;
  final dynamic fixedCharge;
  final dynamic percentCharge;
  final dynamic minLimit;
  final dynamic maxLimit;
  final dynamic monthlyLimit;
  final dynamic dailyLimit;

    Charges({
        required this.id,
        required this.slug,
        required this.title,
        required this.fixedCharge,
        required this.percentCharge,
        required this.minLimit,
        required this.maxLimit,
        required this.monthlyLimit,
        required this.dailyLimit,
    });

    factory Charges.fromJson(Map<String, dynamic> json) => Charges(
     id: json["id"] ?? '',
        slug: json["slug"] ?? '',
        title: json["title"] ?? '',
        fixedCharge: double.parse(json["fixed_charge"] ?? "0.0"),
        percentCharge: double.parse(json["percent_charge"] ?? "0.0"),
        minLimit: double.parse(json["min_limit"] ?? "0.0"),
        maxLimit: double.parse(json["max_limit"] ?? "0.0"),
        monthlyLimit: double.parse(json["monthly_limit"] ?? "0.0"),
        dailyLimit: double.parse(json["daily_limit"] ?? "0.0"),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
        "fixed_charge": fixedCharge,
        "percent_charge": percentCharge,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "monthly_limit": monthlyLimit,
        "daily_limit": dailyLimit,
    };
}

class GetRemainingFields {
    String transactionType;
    String attribute;

    GetRemainingFields({
        required this.transactionType,
        required this.attribute,
    });

    factory GetRemainingFields.fromJson(Map<String, dynamic> json) => GetRemainingFields(
        transactionType: json["transaction_type"],
        attribute: json["attribute"],
    );

    Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "attribute": attribute,
    };
}

class Message {
    List<String> success;

    Message({
        required this.success,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
    };
}
