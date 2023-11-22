class BaseAPI {
  static String base = "http://localhost:8080";
  static var api = base + "/api/v1";
  var usersPath = api + "/users";
  var authPath = api + "/auth";
  var logoutPath = api + "/logout";
  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
