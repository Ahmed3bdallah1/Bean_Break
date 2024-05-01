class AllUsersModel {
  int? status;
  String? message;
  List<AllUsersData>? data;

  AllUsersModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllUsersModel.fromJson(Map<String, dynamic> json) => AllUsersModel(
    status: json["status"],
    message: json["message"],
    data: List<AllUsersData>.from(json["data"].map((x) => AllUsersData.fromJson(x))),
  );
}

class AllUsersData {
  String? id;
  String? displayName;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? tokensList;
  List<DateTime>? tokesExpiryList;
  String? resetCode;
  DateTime? resetCodeExpiry;
  List<dynamic>? favouriteLocations;
  bool? emailVerified;
  String? emailVerificationCode;

  AllUsersData({
    this.id,
    this.displayName,
    this.email,
    this.createdAt,
    this.updatedAt,
    this.tokensList,
    this.tokesExpiryList,
    this.resetCode,
    this.resetCodeExpiry,
    this.favouriteLocations,
    this.emailVerified,
    this.emailVerificationCode,
  });

  factory AllUsersData.fromJson(Map<String, dynamic> json) => AllUsersData(
    id: json["id"],
    displayName: json["display_name"],
    email: json["email"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    tokensList: List<String>.from(json["tokens_list"].map((x) => x)),
    tokesExpiryList: List<DateTime>.from(json["tokes_expiry_list"].map((x) => DateTime.parse(x))),
    resetCode: json["reset_code"],
    resetCodeExpiry: DateTime.parse(json["reset_code_expiry"]),
    favouriteLocations: List<dynamic>.from(json["favourite_locations"].map((x) => x)),
    emailVerified: json["email_verified"],
    emailVerificationCode: json["email_verification_code"],
  );
}
