import 'dart:convert';

import 'package:qrpay/widgets/payment_link/custom_drop_down.dart';

WalletsModel walletsModelFromJson(String str) =>
    WalletsModel.fromJson(json.decode(str));

String walletsModelToJson(WalletsModel data) => json.encode(data.toJson());

class WalletsModel {
  Message message;
  Data data;

  WalletsModel({
    required this.message,
    required this.data,
  });

  factory WalletsModel.fromJson(Map<String, dynamic> json) => WalletsModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  List<MainUserWallet> userWallets;

  Data({
    required this.userWallets,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userWallets: List<MainUserWallet>.from(
            json["userWallets"].map((x) => MainUserWallet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "userWallets": List<dynamic>.from(userWallets.map((x) => x.toJson())),
      };
}

class MainUserWallet implements DropdownModel {
  dynamic balance;
  int status;
  MainCurrency currency;

  MainUserWallet({
    this.balance,
    required this.status,
    required this.currency,
  });

  factory MainUserWallet.fromJson(Map<String, dynamic> json) => MainUserWallet(
        balance: json["balance"],
        status: json["status"],
        currency: MainCurrency.fromJson(json["currency"]),
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "status": status,
        "currency": currency.toJson(),
      };

  @override
  String get title =>
      "${currency.country}(${double.parse(balance.toString()).toStringAsFixed(2)}${currency.code})";
}

class MainCurrency {
  int id;
  String code;
  dynamic rate;
  dynamic flag;
  String symbol;
  String type; 
  int currencyDefault; 
  String country;
  bool both; 
  bool senderCurrency;
  bool receiverCurrency;
  String currencyImage;
                      
  MainCurrency({
    required this.id,
    required this.code,
    required this.rate,
    this.flag, 
    required this.symbol,
    required this.type,
    required this.currencyDefault,
    required this.country,
    required this.both,
    required this.senderCurrency,
    required this.receiverCurrency,
    required this.currencyImage,
  });
   
    
  factory MainCurrency.fromJson(Map<String, dynamic> json) => MainCurrency(
        id: json["id"],
        code: json["code"],
        rate: json["rate"],
        flag: json["flag"] ?? '',
        symbol: json["symbol"],
        type: json["type"],
        currencyDefault: json["default"],
        country: json["country"],
        both: json["both"],
        senderCurrency: json["senderCurrency"],
        receiverCurrency: json["receiverCurrency"],
        currencyImage: json["currencyImage"],
      ); 
     
   
Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "rate": rate,
        "flag": flag,
        "symbol": symbol,
        "type": type,
        "default": currencyDefault,
        "country": country,
        "both": both,
        "senderCurrency": senderCurrency,
        "receiverCurrency": receiverCurrency,
        "currencyImage": currencyImage,
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
