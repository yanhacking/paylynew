
class CommonSuccessModel {
    Message message;

    CommonSuccessModel({
        required this.message,
    });

    factory CommonSuccessModel.fromJson(Map<String, dynamic> json) => CommonSuccessModel(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
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
