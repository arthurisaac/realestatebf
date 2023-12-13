import 'package:intl/intl.dart';

const String serverUrl = 'https://residant.fasobizness.com/';
//const String serverUrl = 'http://192.168.11.106:8000/';
//const String serverUrl = 'http://192.168.195.13:8000/';
//const String serverUrl = 'http://localhost:8000/';
const String baseUrl = '${serverUrl}api/';
const String mediaUrl = '${serverUrl}storage/';
const String jwtKey = "";
const String jwtSharedSecret= "SECUREKEY";

const hive = "auth";

//api endpoints
// espace entre les widgets
const double space = 20;

// token issuer
const String issuer = 'estate';

// price symbole
const String priceSymbole = 'F';

// String
const String errorOccured = "Une erreur s'est produite";

//api endpoints
const String propertiesUrl = "${baseUrl}properties";
const String myPropertiesUrl = "${baseUrl}my-properties";
const String propertyUpdateUrl = "${baseUrl}property-update";
const String searchPropertiesUrl = "${baseUrl}search-properties";
const String reservationUrl = "${baseUrl}reservations";
const String myReservationUrl = "${baseUrl}my-reservations";
const String favoriteUrl = "${baseUrl}favorites";
const String unavailableDatesUrl = "${baseUrl}reservations-indisponibles";
const String loginUrl = "${baseUrl}login";
const String updatePasswordUrl = "${baseUrl}change-password";
const String registerUrl = "${baseUrl}register";
const String meUrl = "${baseUrl}me";
const String updateUserUrl = "${baseUrl}me/update";

const String propertiesPicturesUrl = "${baseUrl}properties-pictures";

final numberFormat = NumberFormat("##,##0", "fr_FR");