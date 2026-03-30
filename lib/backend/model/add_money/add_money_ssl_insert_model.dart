import 'dart:convert';

AddMoneySslInsertModel addMoneySslInsertModelFromJson(String str) =>
    AddMoneySslInsertModel.fromJson(json.decode(str));

String addMoneySslInsertModelToJson(AddMoneySslInsertModel data) =>
    json.encode(data.toJson());

class AddMoneySslInsertModel {
  Message message;
  Data data;

  AddMoneySslInsertModel({
    required this.message,
    required this.data,
  });

  factory AddMoneySslInsertModel.fromJson(Map<String, dynamic> json) =>
      AddMoneySslInsertModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  String gatewayType;
  String gatewayCurrencyName;
  String alias;
  String identify;
  PaymentInformation paymentInformation;
  String url;
  String method;

  Data({
    required this.gatewayType,
    required this.gatewayCurrencyName,
    required this.alias,
    required this.identify,
    required this.paymentInformation,
    required this.url,
    required this.method,
  });

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
  String trx;
  String gatewayCurrencyName;
  String requestAmount;
  String exchangeRate;
  String totalCharge;
  String willGet;
  String payableAmount;

  PaymentInformation({
    required this.trx,
    required this.gatewayCurrencyName,
    required this.requestAmount,
    required this.exchangeRate,
    required this.totalCharge,
    required this.willGet,
    required this.payableAmount,
  });

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
