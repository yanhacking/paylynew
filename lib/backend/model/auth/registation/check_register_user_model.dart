class CheckRegisterUserModel {
  CheckRegisterUserModel({
    required this.message,
  });

  Message message;
  factory CheckRegisterUserModel.fromJson(Map<String, dynamic> json) =>
      CheckRegisterUserModel(
        message: Message.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message.toJson(),
      };
}

class Message {
  Message({
    required this.success,
  });

  List<String> success;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        success: List<String>.from(json["success"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": List<dynamic>.from(success.map((x) => x)),
      };
}

class Data {
  final User user;

  Data({
    required this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
      };
}

class User {
  final int id;

  User({
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
