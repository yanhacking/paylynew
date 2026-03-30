import 'dart:convert';

ReferInfoModel referInfoModelFromJson(String str) =>
    ReferInfoModel.fromJson(json.decode(str));

String referInfoModelToJson(ReferInfoModel data) => json.encode(data.toJson());

class ReferInfoModel {
  Message message;
  Data data;

  ReferInfoModel({
    required this.message,
    required this.data,
  });

  factory ReferInfoModel.fromJson(Map<String, dynamic> json) => ReferInfoModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
      };
}

class Data {
  Basic basic;
  List<AccountLevel> accountLevels;
  List<ReferUser> referUsers;

  Data({
    required this.basic,
    required this.accountLevels,
    required this.referUsers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        basic: Basic.fromJson(json["basic"]),
        accountLevels: List<AccountLevel>.from(
            json["account_levels"].map((x) => AccountLevel.fromJson(x))),
        referUsers: List<ReferUser>.from(
            json["refer_users"].map((x) => ReferUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "basic": basic.toJson(),
        "account_levels":
            List<dynamic>.from(accountLevels.map((x) => x.toJson())),
        "refer_users": List<dynamic>.from(referUsers.map((x) => x.toJson())),
      };
}

class AccountLevel {
  int id;
  String title;
  int referUser;
  dynamic depositAmount;
  int commission;
  bool accountLevelDefault;
  bool active;
  DateTime createdAt;
  DateTime updatedAt;

  AccountLevel({
    required this.id,
    required this.title,
    required this.referUser,
    required this.depositAmount,
    required this.commission,
    required this.accountLevelDefault,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountLevel.fromJson(Map<String, dynamic> json) => AccountLevel(
        id: json["id"],
        title: json["title"],
        referUser: json["refer_user"],
        depositAmount: json["deposit_amount"]?.toDouble() ?? 0.0,
        commission: json["commission"],
        accountLevelDefault: json["default"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "refer_user": referUser,
        "deposit_amount": depositAmount,
        "commission": commission,
        "default": accountLevelDefault,
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Basic {
  String totalDeposit;
  String totalRefers;
  String currencyCode;
  String referCode;

  Basic({
    required this.totalDeposit,
    required this.totalRefers,
    required this.currencyCode,
    required this.referCode,
  });

  factory Basic.fromJson(Map<String, dynamic> json) => Basic(
        totalDeposit: json["total_deposit"],
        totalRefers: json["total_refers"],
        currencyCode: json["currency_code"],
        referCode: json["refer_code"],
      );

  Map<String, dynamic> toJson() => {
        "total_deposit": totalDeposit,
        "total_refers": totalRefers,
        "currency_code": currencyCode,
        "refer_code": referCode,
      };
}

class ReferUser {
  String firstname;
  String email;
  String fullMobile;
  String username;
  String referralId;
  DateTime createdAt;

  ReferUser({
    required this.firstname,
    required this.email,
    required this.fullMobile,
    required this.username,
    required this.referralId,
    required this.createdAt,
  });

  factory ReferUser.fromJson(Map<String, dynamic> json) => ReferUser(
        firstname: json["firstname"],
        email: json["email"],
        fullMobile: json["full_mobile"],
        username: json["username"],
        referralId: json["referral_id"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "email": email,
        "full_mobile": fullMobile,
        "username": username,
        "referral_id": referralId,
        "created_at": createdAt.toIso8601String(),
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
