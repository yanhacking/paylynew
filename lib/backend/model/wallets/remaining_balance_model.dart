
class RemainingBalanceModel {
    Message message;
    Data data;

    RemainingBalanceModel({
        required this.message,
        required this.data,
    });

    factory RemainingBalanceModel.fromJson(Map<String, dynamic> json) => RemainingBalanceModel(
        message: Message.fromJson(json["message"]),
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
        "data": data.toJson(),
    };
}

class Data {
    bool status;
    String transactionType;
    String remainingDaily;
    String remainingMonthly;
    String currency;

    Data({
        required this.status,
        required this.transactionType,
        required this.remainingDaily,
        required this.remainingMonthly,
        required this.currency,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        transactionType: json["transaction_type"],
        remainingDaily: json["remainingDaily"],
        remainingMonthly: json["remainingMonthly"],
        currency: json["currency"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "transaction_type": transactionType,
        "remainingDaily": remainingDaily,
        "remainingMonthly": remainingMonthly,
        "currency": currency,
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
