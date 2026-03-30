import 'dart:convert';

WithdrawInfoModel withdrawInfoModelFromJson(String str) =>
    WithdrawInfoModel.fromJson(json.decode(str));
String withdrawInfoModelToJson(WithdrawInfoModel data) =>
    json.encode(data.toJson());

class WithdrawInfoModel {
  final Message message;
  final Data data;

  WithdrawInfoModel({
    required this.message,
    required this.data,
  });

  factory WithdrawInfoModel.fromJson(Map<String, dynamic> json) =>
      WithdrawInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  final String baseCurr;
  final dynamic baseCurrRate;
  GetRemainingFields getRemainingFields;
  final String defaultImage;
  final String imagePath;
  final List<Gateway> gateways;
  final List<dynamic> transactions;

  Data({
    required this.baseCurr,
    required this.baseCurrRate,
    required this.getRemainingFields,
    required this.defaultImage,
    required this.imagePath,
    required this.gateways,
    required this.transactions,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        baseCurr: json["base_curr"],
        baseCurrRate: json["base_curr_rate"],
        getRemainingFields:
            GetRemainingFields.fromJson(json["get_remaining_fields"]),
        defaultImage: json["default_image"],
        imagePath: json["image_path"],
        gateways: List<Gateway>.from(
            json["gateways"].map((x) => Gateway.fromJson(x))),
        transactions: List<dynamic>.from(json["transactions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
        "get_remaining_fields": getRemainingFields.toJson(),
        "default_image": defaultImage,
        "image_path": imagePath,
        "gateways": List<dynamic>.from(gateways.map((x) => x.toJson())),
        "transactions": List<dynamic>.from(transactions.map((x) => x)),
      };
}

class GetRemainingFields {
  String transactionType;
  String attribute;

  GetRemainingFields({
    required this.transactionType,
    required this.attribute,
  });

  factory GetRemainingFields.fromJson(Map<String, dynamic> json) =>
      GetRemainingFields(
        transactionType: json["transaction_type"],
        attribute: json["attribute"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "attribute": attribute,
      };
}

class Gateway {
  final int id;
  final String name;
  final dynamic image;
  final String slug;
  final int code;
  final String type;
  final String alias;
  final List<String> supportedCurrencies;
  final dynamic inputFields;
  final int status;
  final List<Currency> currencies;

  Gateway({
    required this.id,
    required this.name,
    this.image,
    required this.slug,
    required this.code,
    required this.type,
    required this.alias,
    required this.supportedCurrencies,
    this.inputFields,
    required this.status,
    required this.currencies,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        name: json["name"],
        image: json["image"] ?? '',
        slug: json["slug"],
        code: json["code"],
        type: json["type"],
        alias: json["alias"],
        supportedCurrencies:
            List<String>.from(json["supported_currencies"].map((x) => x)),
        inputFields: json["input_fields"],
        status: json["status"],
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "slug": slug,
        "code": code,
        "type": type,
        "alias": alias,
        "supported_currencies":
            List<dynamic>.from(supportedCurrencies.map((x) => x)),
        "input_fields": inputFields,
        "status": status,
        "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
      };
}

class Currency {
  final int id;
  final int paymentGatewayId;
  final int crypto;
  final String type;
  final String name;
  final String alias;
  final String currencyCode;
  final String currencySymbol;
  final dynamic image;
  final double minLimit;
  final double maxLimit;
  final double percentCharge;
  final double fixedCharge;
 final  double dailyLimit;
 final  double monthlyLimit;
  final double rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Currency({
    required this.id,
    required this.paymentGatewayId,
    required this.crypto,
    required this.type,
    required this.name,
    required this.alias,
    required this.currencyCode,
    required this.currencySymbol,
    this.image,
    required this.minLimit,
    required this.maxLimit,
    required this.percentCharge,
    required this.fixedCharge,
    required this.dailyLimit,
    required this.monthlyLimit,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        paymentGatewayId: json["payment_gateway_id"],
        crypto: json["crypto"],
        type: json["type"],
        name: json["name"],
        alias: json["alias"],
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
        image: json["image"] ?? '',
        minLimit: double.parse(json["min_limit"] ?? "0.0"),
        maxLimit: double.parse(json["max_limit"] ?? "0.0"),
        percentCharge: double.parse(json["percent_charge"] ?? "0.0"),
        fixedCharge: double.parse(json["fixed_charge"] ?? "0.0"),
        dailyLimit: double.parse(json["daily_limit"] ?? "0.0"),
        monthlyLimit: double.parse(json["monthly_limit"] ?? "0.0"),
        rate: double.parse(json["rate"] ?? "0.0"),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_gateway_id": paymentGatewayId,
        "crypto": crypto,
        "type": type,
        "name": name,
        "alias": alias,
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
        "image": image,
        "min_limit": minLimit,
        "max_limit": maxLimit,
        "percent_charge": percentCharge,
        "fixed_charge": fixedCharge,
        "daily_limit": dailyLimit,
        "monthly_limit": monthlyLimit,
        "rate": rate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class UserWallet {
  final dynamic balance;
  final String currency;

  UserWallet({
    required this.balance,
    required this.currency,
  });

  factory UserWallet.fromJson(Map<String, dynamic> json) => UserWallet(
        balance: double.parse(json["balance"] ?? "0.0"),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "currency": currency,
      };
}

class Message {
  final List<String> success;

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
