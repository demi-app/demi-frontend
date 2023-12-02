class BaseAPI {
  static String api = "http://api.karpedemi.com";
  Uri usersPath = Uri.parse('$api/users');
  Uri loginPath = Uri.parse('$api/login');
  Uri authPath = Uri.parse("$api/auth");
  Uri logoutPath = Uri.parse("$api/logout");
  Uri signupPath = Uri.parse("$api/signup");
  Uri goalPath = Uri.parse('$api/goals');
  Uri specificGoalPath = Uri.parse('$api/goal');
  Uri missionsAcceptedPath = Uri.parse('$api/missions/accepted');
  Uri missionsAllPath = Uri.parse('$api/missions/all');
  Uri missionStatusPath = Uri.parse('$api/mission/status');
  Uri milestonesPath = Uri.parse('$api/milestones');
  // more routes
  Map<String, String> headers = {
    "Content-Type": "application/json; charset=UTF-8"
  };
}
