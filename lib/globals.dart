const String base_url = 'https://mashtoz.org';
const api_url = '$base_url/api/v1';

var types = <String>[
  'libraries',
  'encyclopedias',
  'lessons',
  'dialects',
  'audiolibraries',
  'gallery',
  'armenians',
  'italians',
];
List<String> wordsArm = [
  'ա',
  "բ",
  "գ",
  "դ",
  "ե",
  "զ",
  "է",
  "ը",
  "թ",
  "ժ",
  "ի",
  "լ",
  "խ",
  "ծ",
  "կ",
  "հ",
  "ձ",
  "ղ",
  "ճ",
  "մ",
  "յ",
  "ն",
  "շ",
  "ո",
  "չ",
  "պ",
  "ջ",
  "ռ",
  "ս",
  "վ",
  "տ",
  "ր",
  "ց",
  "ու",
  "փ",
  "ք",
  "և",
  "օ",
  "ֆ"
];

class Api {
  //Refresh_APIs
  static String get refreshToken => '$api_url/refresh';
  //Login_Signup_Forgot APIs
  static String get loginUrl => '$api_url/login';

  static String get loginOut => '$api_url/logout';

  static String get resgisterUrl => '$api_url/register';

  static String get forgotPassword => '$api_url/forgot-password';

  static String get checkCode => '$api_url/code-check';

  static String get resetPassword => '$api_url/password-reset';

  //Contact API
  static String get contactform => '$api_url/contactform';

  //Favorite_save_&_Favorite_update APIs
  static String get saveFavorite => '$api_url/saveFavorite';

  static String get updateFavorite => '$api_url/updateFavorite';

  //Get Favorite
  static String get getFavorites => '$api_url/getFavorites';

  //User_Info API
  static String get userInfo => '$api_url/me';

  //Info APIs
  static String get abaoutUs => '$api_url/getpage/about-us';

  static String get donation => '$api_url/getpage/donation';

  //Menu API
  static String get menu => '$api_url/menu';

//Gallery API
  static String get gallery => '$api_url/galleries';

//Dialect APIs
  static String get dialectCharacters => '$api_url/dialectsCharacters';

  static dialectBYCharacters(caracters) => '$api_url/dialects/$caracters';

//Encyclopedia APIs
  static String get encyclopediasCharacters =>
      '$api_url/encyclopediasCharacters';

  static encyclopediasByCharacters(character) =>
      '$api_url/encyclopedias/$character';

//AudioLibraries APIs
  static String get audioLibrariesCharacters =>
      '$api_url/audilibrariesCharacters';

  static audioLibrariesByCharacters(characters) =>
      '$api_url/audilibraries/$characters';

  //Library_Category APIs
  static String get categoryListUrl => '$api_url/libraries/categoryList';

  // static libraryCategoryById(id) => '$api_url/libraries/$id';
  static String libraryCategoryById(String id, {String? eTag}) {
    var url = '$api_url/libraries/$id';
    if (eTag != null) {
      url += '?_etag=$eTag';
    }
    return url;
  }
  //ItalianLesson API
  static String get italianLessons => '$api_url/lessons';

  //Dictoniary APIs
  static String get italianDictionaryCharacters =>
      '$api_url/italiansCharacters';

  static italianDictionaryByCharacters(character) =>
      '$api_url/italians/$character';

  static String get armenianDictionaryCharacters =>
      '$api_url/armeniansCharacters';

  static armenianDictionaryByCharacters(character) =>
      '$api_url/armenians/$character';

  //Words of Day APIs
  static String get wordsOfDay => '$api_url/wordsofday';

  static String get afterWordsOfDay => '$api_url/allwordsofday';
  //Home_data API
  static String get getHomeData => '$api_url/home';

  //Search
  static search(query) => '$api_url/search?search=$query';

  //Search results
  static searchReuslts({String? type, int? id}) =>
      '$api_url/byType/$type/$id';
  static List<String> get armAlphapet => wordsArm;
}
