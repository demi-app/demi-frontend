class BaseAPI {
  static String api = "http://localhost:8080";
  Uri usersPath = Uri.parse(api + '/users');
  Uri loginPath = Uri.parse(api + '/login');
  Uri authPath = Uri.parse(api + "/auth");
  Uri logoutPath = Uri.parse(api + "/logout");
  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
