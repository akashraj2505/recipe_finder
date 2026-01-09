class ApiConstants {
  ApiConstants._(); // private constructor (no object creation)

  static const String baseUrl =
      'https://www.themealdb.com/api/json/v1/1';

  // Endpoints
  static const String searchMealByName = '/search.php?s=';
  static const String lookupMealById = '/lookup.php?i=';
  static const String filterByCategory = '/filter.php?c=';
  static const String filterByArea = '/filter.php?a=';
  static const String categories = '/categories.php';
  static const String areas = '/list.php?a=list';
}
