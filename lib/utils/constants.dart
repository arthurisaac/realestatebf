//const String serverUrl = 'http://192.168.1.198:8000/';
import 'package:intl/intl.dart';

const String serverUrl = 'http://192.168.11.102:8000/';
//const String serverUrl = 'http://localhost:8000/';
const String baseUrl = '${serverUrl}api/';
const String mediaUrl = '${serverUrl}storage/';
const String jwtKey = "";
const String jwtSharedSecret= "SECUREKEY";

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
const String reservationUrl = "${baseUrl}reservations";

final numberFormat = NumberFormat("##,##0", "fr_FR");