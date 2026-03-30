
class ErrorResponse {
    Message message;

    ErrorResponse({
        required this.message,
    });

    factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
    };
}

class Message {
    List<String> error;

    Message({
        required this.error,
    });
 
 
    factory Message.fromJson(Map<String, dynamic> json) => Message(
        error: List<String>.from(json["error"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "error": List<dynamic>.from(error.map((x) => x)),
    };
}
