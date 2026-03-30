import 'dart:convert';

AddMoneyPaymentGatewayModel addMoneyPaymentGatewayModelFromJson(String str) =>
    AddMoneyPaymentGatewayModel.fromJson(json.decode(str));

String addMoneyPaymentGatewayModelToJson(AddMoneyPaymentGatewayModel data) =>
    json.encode(data.toJson());

class AddMoneyPaymentGatewayModel {
  Message message;
  Data data;

  AddMoneyPaymentGatewayModel({
    required this.message,
    required this.data,
  });

  factory AddMoneyPaymentGatewayModel.fromJson(Map<String, dynamic> json) =>
      AddMoneyPaymentGatewayModel(
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
  dynamic defaultImage;
  dynamic imagePath;
  List<Gateway> gateways;
  List<Transactions> transactions;

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
        baseCurr: json["base_curr"] ?? "",
        baseCurrRate: json["base_curr_rate"],
          getRemainingFields: GetRemainingFields.fromJson(json["get_remaining_fields"]),

        defaultImage: json["default_image"] ?? "",
        imagePath: json["image_path"] ?? "",
        gateways: List<Gateway>.from(
            json["gateways"].map((x) => Gateway.fromJson(x))),
        transactions: List<Transactions>.from(
            json["transactions"].map((x) => Transactions.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "base_curr": baseCurr,
        "base_curr_rate": baseCurrRate,
                "get_remaining_fields": getRemainingFields.toJson(),
        
        "default_image": defaultImage,
        "image_path": imagePath,
        "gateways": List<dynamic>.from(gateways.map((x) => x.toJson())),
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
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

class Gateway {
  int id;
  dynamic image;
  dynamic slug;
  int code;
  dynamic type;
  dynamic alias;
  List<String> supportedCurrencies;
  int status;
  List<Currency> currencies;

  Gateway({
    required this.id,
    required this.image,
    required this.slug,
    required this.code,
    required this.type,
    required this.alias,
    required this.supportedCurrencies,
    required this.status,
    required this.currencies,
  });

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        image: json["image"] ?? "",
        slug: json["slug"] ?? "",
        code: json["code"],
        type: json["type"] ?? "",
        alias: json["alias"] ?? "",
        supportedCurrencies:
            List<String>.from(json["supported_currencies"].map((x) => x)),
        status: json["status"],
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "slug": slug,
        "code": code,
        "type": type,
        "alias": alias,
        "supported_currencies":
            List<dynamic>.from(supportedCurrencies.map((x) => x)),
        "status": status,
        "currencies": List<dynamic>.from(currencies.map((x) => x.toJson())),
      };
}

class Currency {
  int id;
  int crypto;
  int paymentGatewayId;
  dynamic type;
  dynamic name;
  dynamic alias;
  dynamic currencyCode;
  dynamic currencySymbol;
  dynamic image;
  double minLimit;
  double maxLimit;
  double percentCharge;
  double fixedCharge;
  double dailyLimit;
  double monthlyLimit;
  double rate;
  DateTime createdAt;
  DateTime updatedAt;

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
        crypto: json["crypto"],
        paymentGatewayId: json["payment_gateway_id"],
        type: json["type"] ?? "",
        name: json["name"] ?? "",
        alias: json["alias"] ?? "",
        currencyCode: json["currency_code"] ?? "",
        currencySymbol: json["currency_symbol"] ?? "",
        image: json["image"] ?? "",
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

class Transactions {
  int id;
  dynamic trx;
  dynamic gatewayName;
  dynamic transactionType;
  dynamic requestAmount;
  dynamic payable;
  dynamic exchangeRate;
  dynamic totalCharge;
  dynamic currentBalance;
  dynamic status;
  DateTime dateTime;
  StatusInfo statusInfo;
  dynamic rejectionReason;

  Transactions({
    required this.id,
    required this.trx,
    required this.gatewayName,
    required this.transactionType,
    required this.requestAmount,
    required this.payable,
    required this.exchangeRate,
    required this.totalCharge,
    required this.currentBalance,
    required this.status,
    required this.dateTime,
    required this.statusInfo,
    required this.rejectionReason,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        id: json["id"],
        trx: json["trx"] ?? "",
        gatewayName: json["gateway_name"] ?? "",
        transactionType: json["transaction_type"] ?? "",
        requestAmount: json["request_amount"] ?? "",
        payable: json["payable"] ?? "",
        exchangeRate: json["exchange_rate"] ?? "",
        totalCharge: json["total_charge"] ?? "",
        currentBalance: json["current_balance"] ?? "",
        status: json["status"] ?? "",
        dateTime: DateTime.parse(json["date_time"]),
        statusInfo: StatusInfo.fromJson(json["status_info"]),
        rejectionReason: json["rejection_reason"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "trx": trx,
        "gateway_name": gatewayName,
        "transaction_type": transactionType,
        "request_amount": requestAmount,
        "payable": payable,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "current_balance": currentBalance,
        "status": status,
        "date_time": dateTime.toIso8601String(),
        "status_info": statusInfo.toJson(),
        "rejection_reason": rejectionReason,
      };
}

class StatusInfo {
  int success;
  int pending;
  int rejected;

  StatusInfo({
    required this.success,
    required this.pending,
    required this.rejected,
  });

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
        success: json["success"],
        pending: json["pending"],
        rejected: json["rejected"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "pending": pending,
        "rejected": rejected,
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
