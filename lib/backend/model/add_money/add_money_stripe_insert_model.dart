import 'dart:convert';

AddMoneyStripeInsertModel addMoneyStripeInsertModelFromJson(String str) =>
    AddMoneyStripeInsertModel.fromJson(json.decode(str));

String addMoneyStripeInsertModelToJson(AddMoneyStripeInsertModel data) =>
    json.encode(data.toJson());

class AddMoneyStripeInsertModel {
  AddMoneyStripeInsertModel({
    required this.message,
    required this.data,
  });

  final Message message;
  final Data data;

  factory AddMoneyStripeInsertModel.fromJson(Map<String, dynamic> json) =>
      AddMoneyStripeInsertModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.gatewayType,
    required this.gatewayCurrencyName,
    required this.alias,
    required this.identify,
    required this.paymentInformation,
    required this.url,
    required this.method,
  });

  final String gatewayType;
  final String gatewayCurrencyName;
  final String alias;
  final String identify;
  final PaymentInformation paymentInformation;
  final String url;
  final String method;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        gatewayType: json["gateway_type"],
        gatewayCurrencyName: json["gateway_currency_name"],
        alias: json["alias"],
        identify: json["identify"],
        paymentInformation:
            PaymentInformation.fromJson(json["payment_information"]),
        url: json["url"],
        method: json["method"],
      );

  Map<String, dynamic> toJson() => {
        "gateway_type": gatewayType,
        "gateway_currency_name": gatewayCurrencyName,
        "alias": alias,
        "identify": identify,
        "payment_information": paymentInformation.toJson(),
        "url": url,
        "method": method,
      };
}

class PaymentInformation {
  PaymentInformation({
    required this.trx,
    required this.gatewayCurrencyName,
    required this.requestAmount,
    required this.exchangeRate,
    required this.totalCharge,
    required this.willGet,
    required this.payableAmount,
  });

  final String trx;
  final String gatewayCurrencyName;
  final String requestAmount;
  final String exchangeRate;
  final String totalCharge;
  final String willGet;
  final String payableAmount;

  factory PaymentInformation.fromJson(Map<String, dynamic> json) =>
      PaymentInformation(
        trx: json["trx"],
        gatewayCurrencyName: json["gateway_currency_name"],
        requestAmount: json["request_amount"],
        exchangeRate: json["exchange_rate"],
        totalCharge: json["total_charge"],
        willGet: json["will_get"],
        payableAmount: json["payable_amount"],
      );

  Map<String, dynamic> toJson() => {
        "trx": trx,
        "gateway_currency_name": gatewayCurrencyName,
        "request_amount": requestAmount,
        "exchange_rate": exchangeRate,
        "total_charge": totalCharge,
        "will_get": willGet,
        "payable_amount": payableAmount,
      };
}

class Message {
  Message({
    required this.success,
  });

  final List<String> success;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}
