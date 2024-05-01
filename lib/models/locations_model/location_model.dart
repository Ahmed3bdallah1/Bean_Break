class LocationModel {
  String? id;
  String? name;
  double? latitude;
  double? longitude;
  String? locationDescription;
  String? description;
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

  LocationModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.locationDescription,
    this.description,
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

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    locationDescription: json["location_description"],
    description: json["description"],
    instantCoffee: json["instant_coffee"],
    beansCoffee: json["beans_coffee"],
    alternateOptions: json["alternate_options"],
    sitDown: json["sit_down"],
    priceRating: json["price_rating"].toDouble(),
    tasteRating: json["taste_rating"].toDouble(),
    selectionRating: json["selection_rating"].toDouble(),
    friendlinessRating: json["friendliness_rating"].toDouble(),
    isFree: json["is_free"],
    keyRequired: json["key_required"],
    wheelchairFriendly: json["wheelchair_friendly"],
    cleanlinessRating: json["cleanliness_rating"].toDouble(),
    accessibilityRating: json["accessibility_rating"].toDouble(),
    suppliesRating: json["supplies_rating"].toDouble(),
    safetyRating: json["safety_rating"].toDouble(),
  );
}
