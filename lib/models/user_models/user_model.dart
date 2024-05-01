class UserModel {
  String? id;
  String? displayName;
  String? email;
  String? password;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;
  DateTime? tokenExpiry;
  List<dynamic>? favouriteLocations;
  bool? emailVerified;

  UserModel({
    this.id,
    this.displayName,
    this.email,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.tokenExpiry,
    this.favouriteLocations,
    this.emailVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    displayName: json["display_name"],
    email: json["email"],
    password: json["password"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    token: json["token"],
    tokenExpiry: DateTime.parse(json["token_expiry"]),
    favouriteLocations: List<dynamic>.from(json["favourite_locations"].map((x) => x)),
    emailVerified: json["email_verified"],
  );
}
