class AppConstants {
  // api constants
  static const String baseUrl = "http://172.105.152.70:8082";
  static const String GET_USERS = "/account";
  static const String ADD_EDIT_ACCOUNT = "/account";
  static const String DELETE_ACCOUNT = "/account/delete/";
  static const String VERIFYLOGIN = "/account/authentication";
  static const String VERIFY_ACCOUNT = "/account/authentication/";
  static const String RESET_OR_SUBMIT_PASSWORD_EMAIL =
      "/account/password_reset";
  static const String SUBMIT_RESET_PAWWORD = "/account/delete/";
  static const String GET_ALL_LOCATIONS = "/locations/all";
  static const String GET_LOCATION = "/locations/";
  static const String ADD_LOCATION = "/locations/add";
  static const String GET_LOCATION_REVIEWS = "/locations/reviews";
  static const String DELETE_REVIEW = "/reviews";
  static const String GET_ALL_REVIEWS = "/reviews/all";
  static const String GET_MY_REVIEWS = "/reviews/all?user_id=";
  static const String GET_MY_FAVORITES =
      "/account/favourite_locations?user_id=";
  static const String ADD_TO_FAVORITES =
      "/account/favourite_locations/add?location_id=";
  static const String DELETE_FAVORITE =
      "/account/favourite_locations/remove?location_id=";
  static const String ADD_REVIEW = "/reviews/add";

  // local
  static String token = '';
  static String userId = '';
  static String email = '';
  static String name = '';

  // images
  static const String image1 = "assets/1.png";
  static const String image2 = "assets/2.png";
  static const String image3 = "assets/3.png";
  static const String image4 = "assets/4.png";
  static const String image5 = "assets/5.png";
  static const String image6 = "assets/6.png";
  static const String image7 = "assets/7.png";
  static const String image8 = "assets/8.png";
  static const String imageBeens = "assets/beens.png";
}
