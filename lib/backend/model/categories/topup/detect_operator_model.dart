class DetectOperatorModel {
  final DetectOperatorModelData data;

  DetectOperatorModel({
    required this.data,
  });

  factory DetectOperatorModel.fromJson(Map<String, dynamic> json) =>
      DetectOperatorModel(
        data: DetectOperatorModelData.fromJson(json["data"]),
      );
}

class DetectOperatorModelData {
  final bool status;
  final String message;
  final DataData? data;

  DetectOperatorModelData({
    required this.status,
    required this.message,
    this.data,
  });

  factory DetectOperatorModelData.fromJson(Map<String, dynamic> json) =>
      DetectOperatorModelData(
        status: json["status"],
        message: json["message"],
        data: json["data"] != null ? DataData.fromJson(json["data"]) : null,
      );
}

class DataData {
  final int? operatorId;
  final String? name;
  final bool? supportsLocalAmounts;
  final String? denominationType;
  final String? senderCurrencyCode;
  final String? destinationCurrencyCode;
  final dynamic minAmount;
  final dynamic maxAmount;
  final dynamic localMinAmount;
  final dynamic localMaxAmount;
  final Country? country;
  final Fx? fx;
  final List<dynamic>? localFixedAmounts;
  final Fees? fees;
  final String? status;
  final double? receiverCurrencyRate;
  final String? receiverCurrencyCode;

  DataData({
    this.operatorId,
    this.name,
    this.supportsLocalAmounts,
    this.denominationType,
    this.senderCurrencyCode,
    this.destinationCurrencyCode,
    this.minAmount,
    this.maxAmount,
    this.localMinAmount,
    this.localMaxAmount,
    this.country,
    this.fx,
    this.localFixedAmounts,
    this.fees,
    this.status,
    this.receiverCurrencyRate,
    this.receiverCurrencyCode,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        operatorId: json["operatorId"],
        name: json["name"],
        supportsLocalAmounts: json["supportsLocalAmounts"],
        denominationType: json["denominationType"],
        senderCurrencyCode: json["senderCurrencyCode"],
        destinationCurrencyCode: json["destinationCurrencyCode"],
        minAmount: json["minAmount"]?.toDouble() ?? 0.0,
        maxAmount: json["maxAmount"]?.toDouble() ?? 0.0,
        localMinAmount: json["localMinAmount"]?.toDouble() ?? 0.0,
        localMaxAmount: json["localMaxAmount"]?.toDouble() ?? 0.0,
        country:
            json["country"] != null ? Country.fromJson(json["country"]) : null,
        fx: json["fx"] != null ? Fx.fromJson(json["fx"]) : null,
        localFixedAmounts: json["localFixedAmounts"] != null
            ? List<dynamic>.from(json["localFixedAmounts"].map((x) => x))
            : null,
        fees: json["fees"] != null ? Fees.fromJson(json["fees"]) : null,
        status: json["status"],
        receiverCurrencyRate: json["receiver_currency_rate"]?.toDouble(),
        receiverCurrencyCode: json["receiver_currency_code"],
      );
}

class Fx {
  double rate;
  String currencyCode;

  Fx({
    required this.rate,
    required this.currencyCode,
  });

  factory Fx.fromJson(Map<String, dynamic> json) => Fx(
        rate: json["rate"]?.toDouble(),
        currencyCode: json["currencyCode"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "currencyCode": currencyCode,
      };
}

class Country {
  final String name;

  Country({
    required this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json["name"],
      );
}

class Fees {
  final double? international;
  // final int local;
  // final int localPercentage;
  final double? internationalPercentage;

  Fees({
    this.international,
    // required this.local,
    // required this.localPercentage,
    this.internationalPercentage,
  });

  factory Fees.fromJson(Map<String, dynamic> json) => Fees(
        international: json["international"]?.toDouble() ?? 0.0,
        // local: json["local"],
        // localPercentage: json["localPercentage"],
        internationalPercentage:
            json["internationalPercentage"]?.toDouble() ?? 0.0,
      );
}
