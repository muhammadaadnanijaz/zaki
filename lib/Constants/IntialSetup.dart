import 'package:zaki/Models/GoalModel.dart';
import 'package:zaki/Models/ToDoModel.dart';
import 'package:zaki/Services/api.dart';
// Default settings:
// days :365 days out
// Value: $1

final DateTime todayDate = DateTime.now();
DateTime defaultDate =
    DateTime(todayDate.year + 1, todayDate.month, todayDate.day);
final double goalCollected = 0;
String goalAmount = "0";
var weekList = ['One Time', 'Daily', 'Weekly', 'Monthly'];

var daysList = [
  'Fri',
  'Sat',
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
];

class IntialSetup {
  static List<GoalModel> dadDefaultGoals = [
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Mothers day gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "My wifes b'day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Savings for a rainy day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Anniversary gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Kids birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
  ];

  static List<GoalModel> momDefaultGoals = [
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Fathers day gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "My Husbands b'day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Savings for a rainy day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Anniversary gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Kids birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    )
  ];

  static List<GoalModel> kidsDefaultGoals = [
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Fathers day gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Mothers day gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Dad's birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Mom's birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Brother or sisters birthday",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Friends birthday",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Helping a family in need",
      goalPrice: goalAmount,
      topSecret: false,
    )
  ];
   
  static List<GoalModel> singleDefaultGoals = [
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Friends birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Nephew's birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Niece’s birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Money for a rainy day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Helping a family in need",
      goalPrice: goalAmount,
      topSecret: false,
    ),
  ];

  static List<GoalModel>  defaultGoals = [
      GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Friends birthday gift",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Money for a rainy day",
      goalPrice: goalAmount,
      topSecret: false,
    ),
    GoalModel(
      goalAmountCollected: goalCollected,
      goalDate: defaultDate,
      goalName: "Helping a family in need",
      goalPrice: goalAmount,
      topSecret: false,
    ),
  ];
 
// To do

  static List<ToDoModel> dadDefaultTodos = [
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Issue a ZakiPay debit card",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Invite your friends & family to ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup allowance for kids",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Review kids Goals in ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Personalize ZakiPay for each kid",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup To Do for each kid",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
  ];
  static List<ToDoModel> momDefaultTodos = [
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Issue a ZakiPay debit card",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Invite your friends & family to ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup allowance for Kids",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Review kids Goals in ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Personalize ZakiPay for each kid",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup To Do for each kid",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup To Do for your Husband :)",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
  ];
  static List<ToDoModel> kidsDefaultTodos = [
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Ask your parents to issue a ZakiPay debit card",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Invite your friends & family to ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Upload a cool profile logo and background image",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
  ];
  static List<ToDoModel> singleDefaultTodos = [
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Issue a ZakiPay debit card",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Invite your friends & family to ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup your financial goals in ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Upload a cool profile logo and background image",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
  ];

   static List<ToDoModel> defaultTodos = [
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Issue a ZakiPay debit card",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Invite your friends & family to ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Setup your financial goals in ZakiPay",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
    ToDoModel(
        doDay: "",
        doStatus: "",
        doTitle: "Upload a cool profile logo and background image",
        linkedAllowance: false,
        doType: weekList[1],
        createdAt: todayDate),
  ];

  static addDefaultPersonalozationSettings({String? userId, String? parentId}){
    ApiServices().addUserPersonalization(
                                    userId: userId,
                                    kidsToPayFriends: true,
                                    kidsToPublish: true,
                                    lockCharity: true,
                                    lockSaving: true,
                                    pendingApprovales: 'No',
                                    slideToPay: true,
                                    parentId: parentId,
                                    disableToDo: false
                                    );
  }
}
