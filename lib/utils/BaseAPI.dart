class BaseAPI {
  static String api = "http://api.karpedemi.com";
  Uri usersPath = Uri.parse('$api/users');
  Uri loginPath = Uri.parse('$api/login');
  Uri authPath = Uri.parse("$api/auth");
  Uri logoutPath = Uri.parse("$api/logout");
  Uri signupPath = Uri.parse("$api/signup");
  Uri goalPath = Uri.parse('$api/goals');
  Uri specificGoalPath = Uri.parse('$api/goal');
  Uri missionsAccepted = Uri.parse('$api/missions/accepted');
  Uri missionsAll = Uri.parse('$api/missions/all');
  Uri missionStatus = Uri.parse('$api/mission/status');
  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
