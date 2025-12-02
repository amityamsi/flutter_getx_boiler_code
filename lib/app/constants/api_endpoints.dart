abstract final class ApiEndpoints {
  // STAGING URL
  static const String _stagingUrl = "https://jsonplaceholder.typicode.com";

  // BASE URL
  static const String _baseUrl = "$_stagingUrl/api";

  // AUTH
  static const String registerUser = "$_baseUrl/user/register";
  static const String loginUser = "$_baseUrl/user/login";
}
