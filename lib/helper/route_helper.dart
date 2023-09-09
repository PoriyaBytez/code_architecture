import 'package:get/get_navigation/src/routes/get_route.dart';

import '../screen/auth/mobile_number_screen.dart';
import '../screen/auth/sign_in_screen.dart';
import '../screen/dashboard/dashboard_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/splash_screen.dart';

class RouteHelper {
  static String splash = '/Splash';
  static String signIn = '/SignIn';
  static String mobileNumberScreen = '/MobileNumber';
  static String home = '/HomeScreen';
  static String profile = '/ProfileScreen';
  static String createProject = '/CreateProject';
  static String projectList = '/ProjectList';
  static String dashBoard = '/DashBoardScreen';
  static String addTask = '/AddTask';
  static String updateTask = '/UpdateTask';
  static String taskIssue = '/TaskIssue';
  static String issueDetails = '/IssueDetails';
  static String taskReview = '/TaskReview';
  static String addTeamMember = '/AddTeamMember';
  static String contact = '/ContactScreen';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(name: mobileNumberScreen, page: () => MobileNumberScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: dashBoard, page: () => DashBoardScreen()),
  ];
}
