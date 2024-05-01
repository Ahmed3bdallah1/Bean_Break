class ReviewModel {
  String? id;
  String? userName;
  String? userId;
  String? locationId;
  DateTime? createdDate;
  bool? instantCoffee;
  bool? beansCoffee;
  bool? alternateOptions;
  bool? sitDown;
  num? priceRating;
  num? tasteRating;
  num? selectionRating;
  num? friendlinessRating;
  bool? isFree;
  bool? keyRequired;
  bool? wheelchairFriendly;
  num? cleanlinessRating;
  num? accessibilityRating;
  num? suppliesRating;
  num? safetyRating;

  ReviewModel({
    this.id,
    this.userName,
    this.userId,
    this.locationId,
    this.createdDate,
    this.instantCoffee,
    this.beansCoffee,
    this.alternateOptions,
    this.sitDown,
    this.priceRating,
    this.tasteRating,
    this.selectionRating,
    this.friendlinessRating,
    this.isFree,
    this.keyRequired,
    this.wheelchairFriendly,
    this.cleanlinessRating,
    this.accessibilityRating,
    this.suppliesRating,
    this.safetyRating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    id: json["id"],
    userName: json["user_name"],
    userId: json["user_id"],
    locationId: json["location_id"],
    createdDate: DateTime.parse(json["created_date"]),
    instantCoffee: json["instant_coffee"],
    beansCoffee: json["beans_coffee"],
    alternateOptions: json["alternate_options"],
    sitDown: json["sit_down"],
    priceRating: json["price_rating"],
    tasteRating: json["taste_rating"],
    selectionRating: json["selection_rating"],
    friendlinessRating: json["friendliness_rating"],
    isFree: json["is_free"],
    keyRequired: json["key_required"],
    wheelchairFriendly: json["wheelchair_friendly"],
    cleanlinessRating: json["cleanliness_rating"],
    accessibilityRating: json["accessibility_rating"],
    suppliesRating: json["supplies_rating"],
    safetyRating: json["safety_rating"],
  );
}
