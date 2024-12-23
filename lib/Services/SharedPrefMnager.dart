import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  late SharedPreferences loginInformation, currentUserId, touchUserId;
  late SharedPreferences themeData;
  late SharedPreferences userPermssionStatus;

  saveCurrentUserId(String id)async{
    currentUserId = await SharedPreferences.getInstance();
    currentUserId.setString('currentUserId', id);
  }
  saveCurrentUserIdForLoginTouch(String id)async{
    touchUserId = await SharedPreferences.getInstance();
    touchUserId.setString('touchUserId', id);
  }
  Future<String?> getCurrentUserIdForLoginTouch()async{
    currentUserId = await SharedPreferences.getInstance();
    String? userId =currentUserId.getString('touchUserId');
    return userId;
  }
   clearCurrentUserIdForLoginTouch() async {
    currentUserId = await SharedPreferences.getInstance();
    currentUserId.remove('touchUserId');
  }
 saveThemeData(int themeId)async{
    themeData = await SharedPreferences.getInstance();
    print("Theme data is: $themeId");
    themeData.setInt('themeId', themeId);
  }
 Future<int?> getThemeData()async{
    themeData = await SharedPreferences.getInstance();
    int? userId =themeData.getInt('themeId');
    return userId;
  }
  
  Future<String?> getCurrentUserId()async{
    currentUserId = await SharedPreferences.getInstance();
    String? userId =currentUserId.getString('currentUserId');
    return userId;
  }
  clearLoggedInUser() async {
    currentUserId = await SharedPreferences.getInstance();
    currentUserId.remove('currentUserId');
  }
  setVisitingFlag() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("UserVisited", true);
  }

  intialInstalledTrue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("firstTime", true);
  }
  isFirstTimeInstalled() async {
    loginInformation = await SharedPreferences.getInstance();
    bool isFirstTime = loginInformation.getBool('firstTime')?? false;
    return isFirstTime;
  }

  saveUserLoginInformation(email, password) async {
    loginInformation = await SharedPreferences.getInstance();
    loginInformation.setString('user_email', email);
    loginInformation.setString('user_password', password);
  }
  

  getUserEmail() async {
    loginInformation = await SharedPreferences.getInstance();
    String? emailOfUser = loginInformation.getString('user_email');
    return emailOfUser;
  }

  getUserPassword() async {
    loginInformation = await SharedPreferences.getInstance();
    String? emailOfUser = loginInformation.getString('user_password');
    return emailOfUser;
  }

  clearUserInformation() async {
    loginInformation = await SharedPreferences.getInstance();
    loginInformation.remove('user_email');
    loginInformation.remove('user_password');
  }

  userPermssionStatusSave(bool setPermssion) async {
    userPermssionStatus = await SharedPreferences.getInstance();
    loginInformation.setBool('permssion', setPermssion);
  }
  getUserPermssionStatusSave() async {
    userPermssionStatus = await SharedPreferences.getInstance();
    loginInformation.getBool('permssion');
  }
  clearUserPermssionStatusSave() async {
    userPermssionStatus = await SharedPreferences.getInstance();
    loginInformation.remove('permssion');
  }
}
