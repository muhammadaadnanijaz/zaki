// const {onCall, region} = require("firebase-functions/v2/https");
const functions = require("firebase-functions/v2");
const {onCall} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {initializeApp} = require("firebase-admin/app");
// const {CloudSchedulerClient} = require("@google-cloud/scheduler");
const {logger} = require("firebase-functions");
const axios = require("axios");
// const {CloudSchedulerClient} = require("@google-cloud/scheduler");
// const schedulerClient = new CloudSchedulerClient();


initializeApp();

const db = getFirestore();
const messaging = getMessaging();
// const schedulerClient = new CloudSchedulerClient();
let cronExpression = "every minute";
let data;


// const functionsRegion = "us-central1"; // Specify your region here
// Marqeta API credentials
const MARQETA_BASE_URL = "https://sandbox-api.marqeta.com/v3/"; // Replace with actual Marqeta API Base URL
const MARQETA_API_KEY = "YTkwNDA3NzItOTJkOS00NThlLTkyOTEtMjYzMTlhZmZlZjU0OjkxYzdiZDVmLWI1MjgtNGQ1ZC1hMGQ2LWRiZDZmN2NhMTU1OQ==";
const ZAKI_PAY_ACCOUNT_NUMBER = "6eb9401b-d44d-44ca-ae22-5efc0e2d10ce";
const USER_DEVICE_NOTIFICATION_TOKEN = "fSzALXYPSPWs6CQHjQkETV:APA91bGUgH6UOqVbgenu"+
"9RF3tEUkDoczkfRwLMsUoReEI2ktLj4PzP4GbMNhC7ilhQL5WEb3wtqxn077eNXbqSd7AwXw5JkSv8Dn5wkFBpIfp3W5KjwHACrVnDzbg7gmosA-AiedcF-J";
const USER_BANK_ACCOUNT_ID = "45a0f24c-adf3-4137-b301-4b967295b84b";
const MARQATA_SHOW_CARD_PAN= "showpan";
const BALANCE = "balances/";
const PAY = "peertransfers";
const MTransactiontype = "TT";
const MFromWallet = "FW";
const MToWallet = "TW";
const MGoalid = "GI";
const MTransactionMethod = "TM";
const MTagItId = "TI";
const MTagItName = "TN";
const SpendWallet = "Spend-Wallet";
const TAG_IT_TRANSACTION_TYPE_SUBSCRIPTION = "Subscription";
const TAG_IT_TRANSACTION_TYPE_ALLOWANCE = "Allowance";
const TAG_IT_ID_ALLOWANCE = "13";
// const TRANSACTION_METHOD_PAYMENT = "Received";
const TRANSACTION_METHOD_PAYMENT = "Payment";
const TAGID0005 = "Clothing";
const TAGID = 4;
// const MARQETA_API_SECRET = "a9040772-92d9-458e-9291-26319affef54"; // Use the same Application Token as API Secret

exports.sendUserNotification = functions.https.onRequest(async (request, res) => {
  const data = request.body;
  const userId = data.data.userId;
  const userCardToken = data.data.userCardToken;
  const userToken = data.data.userToken;

  console.log("Received data:", data);
  console.log("userId:", userId);
  console.log("userCardToken:", userCardToken);

  if (userId==null || userCardToken==null) {
    console.error("Invalid or missing userId or userCardToken");
    return res.status(400).send("Invalid or missing userId or userCardToken");
  }

  // console.debug("Its Send User Notification and id is:"+userToken);

  try {
    // Retrieve card information from Marqeta using the card token
    const cardInfo = await getMarqetaCardInfo(userCardToken);
    // showCardInformation();
    if (!cardInfo || !cardInfo.last_four) {
      throw new Error("No card information found for the provided card token or missing 'last_four' data.");
    } else {
      console.log("Card Info:", cardInfo);
    }
    const userCardBalance = await getBalanceFromMarqata(cardInfo.user_token);
    if (!userCardBalance) {
      throw new Error("No card information found for the provided card token or missing 'last_four' data.");
    } else if (userCardBalance.available_balance>=0) {
      // Now we need to dedut money from marqata and then update firebase status update
    }
    await moveMoney(
        cardInfo.user_token,
        ZAKI_PAY_ACCOUNT_NUMBER,
        20,
        `${MTransactiontype}=${TAG_IT_TRANSACTION_TYPE_SUBSCRIPTION},` +
    `${MFromWallet}=${SpendWallet},` +
    `${MToWallet}=${SpendWallet},` +
    `${MGoalid}=,` +
    `${MTransactionMethod}=${TRANSACTION_METHOD_PAYMENT},` +
    `${MTagItId}=${TAGID},` +
    `${MTagItName}=${TAGID0005},` +
    `SID=${cardInfo.user_token},` +
    `RID=${ZAKI_PAY_ACCOUNT_NUMBER},` +
    `TID=,LATLNG:`,
    );
    console.log("You have the balance:", cardInfo);
    // await moveMoney(
    //     cardInfo.user_token,
    //     ZAKI_PAY_ACCOUNT_NUMBER,
    //     20,
    //     `${MTransactiontype}=${TAG_IT_TRANSACTION_TYPE_SUBSCRIPTION},` +
    //   `${MFromWallet}=${SpendWallet},` +
    //   `${MToWallet}=${SpendWallet},` +
    //   `${MGoalid}=,` +
    //   `${MTransactionMethod}=${TRANSACTION_METHOD_PAYMENT},` +
    //   `${MTagItId}=${TAGID},` +
    //   `${MTagItName}=${TAGID0005},` +
    //   `SID=${cardInfo.user_token},` +
    //   `RID=${ZAKI_PAY_ACCOUNT_NUMBER},` +
    //   `TID=,LATLNG:`,
    // );
    await deductMoneyFromUserAccount(userId, 20, userToken, "", 20);
    await updateUserSubscriptionStatus(userId, false, 3);
    // Assuming you have a way to retrieve the user's device token based on userId
    // const userToken = await getUserToken(userId);

    // if (!userToken) {
    //   throw new Error("No device token found for the provided userId");
    // }

    const payload = {
      notification: {
        title: "Your Card Info",
        body: `Card ending in ${cardInfo.last_four} is ready to use.`,
      },
      token: userToken,
    };

    await messaging.send(payload);
    res.status(200).send("Notification sent successfully");
  } catch (error) {
    console.error("Error sending notification:", error);
    res.status(500).send("Failed to send notification");
  }
});

// Helper function to retrieve Marqeta card information
async function getMarqetaCardInfo(cardToken) {
  try {
    const response = await axios.get(`https://sandbox-api.marqeta.com/v3/cards/${cardToken}/${MARQATA_SHOW_CARD_PAN}`, {
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": `Basic ${MARQETA_API_KEY}`,
      },
      // auth: {
      //   username: MARQETA_API_KEY,
      //   password: MARQETA_API_SECRET,
      // },
    },
    );
    console.log("Marqata card result:", response.data);
    return response.data; // Returns the card information from Marqeta API
  } catch (error) {
    console.error("Error fetching card info from Marqeta:", error);
    return null;
  }
}

async function getBalanceFromMarqata(cardToken) {
  try {
    console.log("User Token is:", cardToken);
    console.log("Full URL of balance is:", `https://api.marqeta.com/v3/${BALANCE}${cardToken}`);
    const response = await axios.get(`${MARQETA_BASE_URL}${BALANCE}${cardToken}`, {
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": `Basic ${MARQETA_API_KEY}`,
      },
      // auth: {
      //   username: MARQETA_API_KEY,
      //   password: MARQETA_API_SECRET,
      // },
    },
    );
    console.log("Marqata Balance:", response.data);
    return response.data; // Returns the card information from Marqeta API
  } catch (error) {
    console.error("Error fetching card info from Marqeta:", error);
    return null;
  }
}

async function moveMoney(senderUserToken, receiverUserToken, amount, tags) {
  try {
    console.error(`Sender is: ${senderUserToken} and receiver token: ${receiverUserToken} and money is: ${amount}`, tags);
    const response = await axios.post(`${MARQETA_BASE_URL}${PAY}`, {
      "amount": parseFloat(amount),
      "currency_code": "USD",
      "sender_user_token": senderUserToken,
      "recipient_user_token": receiverUserToken,
      "tags": tags,
    }, {
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": `Basic ${MARQETA_API_KEY}`,
      },
    },
    );
    console.log("Marqata Move Money:", response.data);
    return response.data; // Returns the card information from Marqeta API
  } catch (error) {
    console.error("Error doing transaction", error);
    return null;
  }
}


// Function to create headers
function headers() {
  return {
    "accept": "application/json",
    "Content-Type": "application/json",
    "Authorization": `Basic ${MARQETA_API_KEY}`,
  };
}

// Cloud Function to show card information
exports.showCardInformation = functions.https.onRequest(async (request, res) => {
  const cardToken = request.query.cardToken || request.body.cardToken;

  if (!cardToken) {
    return res.status(400).send("Invalid or missing cardToken");
  }

  try {
    const response = await axios.get(`${MARQETA_BASE_URL}cards/${cardToken}/showpan`, {
      headers: headers(),
    });

    console.log("Card Full Detail:", response.data);

    res.status(200).send(response.data);
  } catch (error) {
    console.error("Error fetching card information:", error);
    res.status(500).send("Error fetching card information");
  }
});

async function sendMoneyToSaving0rDonationWallet(userId, walletName, amount) {
  try {
    const walletRef = db.collection("USER").doc(userId).collection("USER_WALLETS").doc(walletName);
    const walletDoc = await walletRef.get();
    if (!walletDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    const walletData = walletDoc.data();
    const walletBalance = walletData.wallet_balance;
    if (!walletDoc.exists) {
      throw new Error("Receiver's wallet not found");
    }
    const newBalance = Number(walletBalance) + Number(amount);
    await walletRef.update({wallet_balance: newBalance});
    return walletBalance;
  } catch (error) {
    console.error("No", error);
    return {success: false, message: error.message || error.toString()};
  }
}

async function deductMoneyFromUserAccount(userSenderId, amount, userToken, useReceiverId, senderMainWalletAmount) {
  try {
    const senderWalletRef = db.collection("USER").doc(userSenderId).collection("USER_WALLETS").doc("Spend-Wallet");
    const senderWalletDoc = await senderWalletRef.get();
    if (!senderWalletDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    const senderWallet = senderWalletDoc.data();
    const senderBalance = senderWallet.wallet_balance;

    const receiverWalletRef = db.collection("USER").doc(useReceiverId).collection("USER_WALLETS").doc("Spend-Wallet");
    const receiverWalletDoc = await receiverWalletRef.get();
    if (!receiverWalletDoc.exists) {
      throw new Error("Receiver's wallet not found");
    }
    const receiverWallet = receiverWalletDoc.data();
    const receiverBalance = receiverWallet.wallet_balance;

    if (senderBalance < amount) {
      return "Insufficient balance";
    }

    const newSenderBalance = senderBalance - Number(senderMainWalletAmount);
    const newReceiverBalance = Number(receiverBalance) + Number(amount);
    console.log("Reeciver abalance", `R prevoius banalnce: ${receiverBalance}, Amount: ${amount} R after balance: ${newReceiverBalance}`);


    await senderWalletRef.update({wallet_balance: newSenderBalance});
    await receiverWalletRef.update({wallet_balance: newReceiverBalance});

    // const userRef = db.collection("USER").doc(userSenderId);
    // await userRef.update({USER_created_at: new Date(dateTime)});
    sendingNotification(userToken, "Money Deducted From Users Spend Wallet", "Your money from spend wallet is deducted successfully");
  } catch (error) {
    console.error("Error updating document or sending notification", error);
    return {success: false, message: error.message || error.toString()};
  }
}
//
async function deductMoneyFromUserAccountWithNoReceiver(userSenderId, amount) {
  try {
    const senderWalletRef = db.collection("USER").doc(userSenderId).collection("USER_WALLETS").doc("Spend-Wallet");
    const senderWalletDoc = await senderWalletRef.get();
    if (!senderWalletDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    const senderWallet = senderWalletDoc.data();
    const senderBalance = senderWallet.wallet_balance;
    if (senderBalance < amount) {
      return "Insufficient balance";
    }

    const newSenderBalance = senderBalance - Number(amount);
    await senderWalletRef.update({wallet_balance: newSenderBalance});

    // const userRef = db.collection("USER").doc(userSenderId);
    // await userRef.update({USER_created_at: new Date(dateTime)});
    // sendingNotification(userToken, "Money Deducted From Users Spend Wallet", "Your money from spend wallet is deducted successfully");
  } catch (error) {
    console.error("Error updating document or sending notification", error);
    return {success: false, message: error.message || error.toString()};
  }
}

async function sendingNotification(userToken, title, subtitle) {
  if (!userToken) {
    throw new Error("User token Not found");
  }

  const payload = {
    notification: {
      title: title,
      body: subtitle,
    },
    token: userToken,
  };

  const response = await messaging.send(payload);
  console.log("Notification sent", response);

  return {success: true, message: "Money transferred and notification sent successfully."};
}

async function updateUserSubscriptionStatus(userSenderId, userSubscriptionStatus, subscriptionValue) {
  try {
    const senderWalletRef = db.collection("USER").doc(userSenderId);
    const senderWalletDoc = await senderWalletRef.get();
    if (!senderWalletDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    // const senderWallet = senderWalletDoc.data();
    // const senderBalance = senderWallet.wallet_balance;
    await senderWalletRef.update({
      SubscriptionExpired: userSubscriptionStatus,
      USER_SubscriptionValue: subscriptionValue,
    });
    // await receiverWalletRef.update({wallet_balance: newReceiverBalance});

    // const userRef = db.collection("USER").doc(userSenderId);
    // await userRef.update({USER_created_at: new Date(dateTime)});

    return {success: true, message: "User Subscription Status Change."};
  } catch (error) {
    console.error("Error updating document", error);
    return {success: false, message: error.message || error.toString()};
  }
}


// exports.scheduleNotification = onCall(async (requests) => {
//   try {
//     const data = requests.data;
//     const userToken = data.userToken;
//     const title = data.title;
//     const body = data.body;
//     const cronExpression = data.cronExpression; // Use cronExpression consistently

//     if (!userToken) {
//       throw new Error("Invalid or missing userToken");
//     }

//     console.log("Cron Expression is", cronExpression);

//     const payload = {
//       notification: {
//         title: title,
//         body: body,
//       },
//       token: userToken,
//     };

//     await messaging().send(payload);

//     const projectId = "zakipayapp"; // Replace with your actual project ID
//     const locationId = "us-central1"; // Replace with the region your Cloud Function is deployed in
//     const jobId = `send-notification-job-${userToken}`; // Define a unique job ID

//     const schedulerClient = new CloudSchedulerClient();
//     const parent = schedulerClient.locationPath(projectId, locationId);

//     const job = {
//       name: schedulerClient.jobPath(projectId, locationId, jobId),
//       schedule: cronExpression,
//       timeZone: `UTC`,
//       httpTarget: {
//         httpMethod: "POST",
//         uri: `https://us-central1-zakipayapp.cloudfunctions.net/senUserNotification`,
//         headers: {"Content-Type": "application/json"},
//         body: Buffer.from(JSON.stringify({userToken, title, body})),
//       },
//     };

//     const request = {
//       parent: parent,
//       job: job,
//     };

//     schedulerClient.createJob(request);

//     return {success: true};
//   } catch (error) {
//     console.error("Error creating scheduled job:", error);
//     throw new Error("Failed to schedule notification");
//   }
// });

// exports.createCronJob = onCall(origin, functionsRegion, async (request) => {
//   const data = request.data;
//   const cronExpression = data.cronExpression;
//   const functionName = "runScheduledTask";

//   const project = process.env.GCP_PROJECT;
//   const location = functionsRegion;
//   const parent = `projects/${project}/locations/${location}`;
//   const job = {
//     httpTarget: {
//       uri: `https://${location}-${project}.cloudfunctions.net/${functionName}`,
//       httpMethod: "POST",
//       headers: {
//         "Content-Type": "application/json",
//       },
//     },
//     schedule: cronExpression,
//     timeZone: "Etc/UTC",
//   };

//   const jobRequest = {
//     parent: parent,
//     job: {
//       ...job,
//       name: `${parent}/jobs/${functionName}`,
//     },
//   };

//   try {
//     await schedulerClient.createJob(jobRequest);
//     return {success: true, message: "Cron job created successfully"};
//   } catch (error) {
//     console.error("Error creating cron job", error);
//     return {success: false, message: error.message || error.toString()};
//   }
// });

// exports.runScheduledTask = region(functionsRegion).onSchedule(async (event) => {
//   const data = event.data;
//   const {useReceiverId, userSenderId, userToken, title, body, amount, dateTime} = data;

//   try {
//     const senderWalletRef = db.collection("USER").doc(userSenderId).collection("USER_WALLETS").doc("Spend-Wallet");
//     const senderWalletDoc = await senderWalletRef.get();
//     if (!senderWalletDoc.exists) {
//       throw new Error("Sender"s wallet not found");
//     }
//     const senderWallet = senderWalletDoc.data();
//     const senderBalance = senderWallet.wallet_balance;

//     const receiverWalletRef = db.collection("USER").doc(useReceiverId).collection("USER_WALLETS").doc("Spend-Wallet");
//     const receiverWalletDoc = await receiverWalletRef.get();
//     if (!receiverWalletDoc.exists) {
//       throw new Error("Receiver"s wallet not found");
//     }
//     const receiverWallet = receiverWalletDoc.data();
//     const receiverBalance = receiverWallet.wallet_balance;

//     if (senderBalance < amount) {
//       throw new Error("Sender has insufficient balance");
//     }

//     const newSenderBalance = senderBalance - amount;
//     const newReceiverBalance = receiverBalance + amount;

//     await senderWalletRef.update({wallet_balance: newSenderBalance});
//     await receiverWalletRef.update({wallet_balance: newReceiverBalance});

//     const userRef = db.collection("USER").doc(userSenderId);
//     await userRef.update({USER_created_at: new Date(dateTime)});

//     if (!userToken) {
//       throw new Error("Invalid or missing userToken");
//     }

//     const payload = {
//       notification: {
//         title: title,
//         body: body,
//       },
//       token: userToken,
//     };

//     const response = await messaging.send(payload);
//     console.log("Notification sent", response);

//     return {success: true, message: "Money transferred and notification sent successfully."};
//   } catch (error) {
//     console.error("Error updating document or sending notification", error);
//     return {success: false, message: error.message || error.toString()};
//   }
// });
exports.updateCollectionAndNotifyUser = onCall(async (request) => {
  data = request.data;
  cronExpression = data.cronExpression;
  console.debug("Its crown Expression:"+cronExpression);
  this.accountcleanup();
});

// exports.checkSchedule = onSchedule(cronExpression, {
//   timeZone: "America/Los_Angeles",
// }, async () => {
//   console.debug("Action performed and schedule reset");

//   return null;
// });

// exports.updateAllowance = onCall(async (request) => {
//   const data = request.data;
//   const dateTime = data.dateTime; // Get the dateTime from the request
//   const userId = data.userId; // Replace this with the user ID
//   const updatedData = {fieldName: "USER_created_at", dateTime: dateTime};

//   try {
//     const userRef = db.collection("USER").doc(userId);
//     await userRef.update(updatedData);

//     const userDoc = await userRef.get();

//     if (!userDoc.exists) {
//       console.error(`No document found for user ${userId}`);
//       return null;
//     }

//     const user = userDoc.data();

//     const payload = {
//       notification: {
//         title: "Your data has been updated",
//         body: "Click to see the updated data",
//       },
//       token: user.token,
//     };

//     const response = await messaging.send(payload);

//     console.log("Notification sent", response);
//     return {success: true};
//   } catch (error) {
//     console.error("Error updating document or sending notification", error);
//     return {success: false};
//   }
// });
// exports.makeUppercase = onDocumentCreated("/messages/{documentId}", async (event) => {
//   const snap = event.data;
//   const context = event.params;

//   // Grab the current value of what was written to Firestore.
//   const original = snap.data().original;

//   // Access the parameter `{documentId}` with `context.params`
//   logger.log("Uppercasing", context.documentId, original);

//   const uppercase = original.toUpperCase();

//   // Setting an "uppercase" field in Firestore document returns a Promise.
//   await snap.ref.set({uppercase}, {merge: true});
// });
// Function to generate a list of users
function generateUsers() {
  const users = [
    {
      id: "n0jyC350qmo1Nn5jxqSD",
      name: "Alice",
      userToken: USER_DEVICE_NOTIFICATION_TOKEN,
      userBanckId: USER_BANK_ACCOUNT_ID,
      transactionStatus: "Paid",
      dateOfExpiration: new Date(Date.now() + 1 * 24 * 60 * 60 * 1000).toISOString(), // 1 day from now
      nextDateToPay: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(), // 3 days from now
    },
    {
      id: "n0jyC350qmo1Nn5jxqSD",
      name: "Bob",
      userToken: USER_DEVICE_NOTIFICATION_TOKEN,
      userBanckId: USER_BANK_ACCOUNT_ID,
      transactionStatus: "Paid",
      dateOfExpiration: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(), // 2 days from now
      nextDateToPay: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toISOString(), // 4 days from now
    },
    {
      id: "n0jyC350qmo1Nn5jxqSD",
      name: "Charlie",
      userToken: USER_DEVICE_NOTIFICATION_TOKEN,
      userBanckId: USER_BANK_ACCOUNT_ID,
      transactionStatus: "Paid",
      dateOfExpiration: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(), // 3 days from now
      nextDateToPay: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(), // 5 days from now
    },
    {
      id: "n0jyC350qmo1Nn5jxqSD",
      name: "Diana",
      userToken: USER_DEVICE_NOTIFICATION_TOKEN,
      userBanckId: USER_BANK_ACCOUNT_ID,
      transactionStatus: "Pending",
      dateOfExpiration: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toISOString(), // 4 days from now
      nextDateToPay: new Date(Date.now() + 6 * 24 * 60 * 60 * 1000).toISOString(), // 6 days from now
    },
    {
      id: "n0jyC350qmo1Nn5jxqSD",
      name: "Eve",
      userToken: USER_DEVICE_NOTIFICATION_TOKEN,
      userBanckId: USER_BANK_ACCOUNT_ID,
      transactionStatus: "Paid",
      dateOfExpiration: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000).toISOString(), // 5 days from now
      nextDateToPay: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString(), // 7 days from now
    },
  ];

  return users;
}
// Run once a day at midnight, to clean up the users
// Manually run the task here https://console.cloud.google.com/cloudscheduler
// every minute 0 2 * * *
exports.runEveryDay2AM = onSchedule("0 2 * * *",
    async (event) => {
      try {
        const usersList = generateUsers();
        console.log("Generated Users List:", usersList);
        usersList.forEach(async (user) => {
          if (user.transactionStatus == "Pending") {
            // id: "user_4" status = "Paid"
            console.log(`User ID with Pending status: ${user.id}`);
            await deductMoneyFromUserAccount(user.id, 20, user.userToken, "");
            await moveMoney(
                user.userBanckId,
                ZAKI_PAY_ACCOUNT_NUMBER,
                20,
                `${MTransactiontype}=${TAG_IT_TRANSACTION_TYPE_SUBSCRIPTION},` +
          `${MFromWallet}=${SpendWallet},` +
          `${MToWallet}=${SpendWallet},` +
          `${MGoalid}=,` +
          `${MTransactionMethod}=${TRANSACTION_METHOD_PAYMENT},` +
          `${MTagItId}=${TAGID},` +
          `${MTagItName}=${TAGID0005},` +
          `SID=${user.id},` +
          `RID=${ZAKI_PAY_ACCOUNT_NUMBER},` +
          `TID=,LATLNG:`,
            );
            await updateUserSubscriptionStatus(user.id, false, 3);
          }
        });
        // LOad the list of users with there variables like id, name, status,
        // it is coming from payfort its assemption
        // if(listUser[index].cardStatus==false // expireation date also coming || listUser[index].userId){
        // deduct money from users spend wallet and may be send notification also.
        // }
        // Query all users where "SubscriptionExpired" is true
        const usersSnapshot = await db.collection("USER").where("SubscriptionExpired", "==", true).get();
        // Check if there are any users with "SubscriptionExpired" set to true
        if (!usersSnapshot.empty) {
        // Loop through each user and send notifications
          const promises = [];
          usersSnapshot.forEach((doc) => {
            const userData = doc.data();
            const notifyToken = userData["USER_iNApp_NotifyToken"];
            if (notifyToken) {
              const message = {
                token: notifyToken,
                notification: {
                  title: "Subscription Expired",
                  body: "Your subscription has expired. Please renew to continue using our services.",
                },
              };
              // Push the notification sending promise to the promises array
              promises.push(db.messaging().send(message));
            }
          });
          await Promise.all(promises);
          console.log("Notifications sent successfully to users with expired subscriptions.");
        } else {
          console.log("No users with expired subscriptions found.");
        }
      } catch (error) {
        console.error("Error sending notifications:", error);
      }
    });

exports.allowanceAt2am = onSchedule("* * * * *",
    async (event) => {
      try {
        const today = new Date();
        console.log(`Allowance is being called. ${today}`);
        // Get today's date in YYYY-MM-DD format
        const todayStart = new Date(today.setHours(0, 0, 0, 0)); // Start of today
        const todayEnd = new Date(today.setHours(23, 59, 59, 999)); // End of today

        // Query Firestore for documents in the 'ALLOW' collection where 'created_at' is today
        const snapshot = await db.collection("ALLOW")
            .where("created_at", ">=", todayStart)
            .where("created_at", "<=", todayEnd)
            .where("USER_allowance_status", "==", true)
            .get();

        // Check if there are any users created today
        if (snapshot.empty) {
          console.log("No users created today.");
          // return console.log("No users found.");
        }

        // Create an array to hold all the user data
        const usersData = [];
        for (const doc of snapshot.docs) {
          const data = doc.data();
          console.log("USER_kid_id:", data.USER_kid_id);
          console.log("USER_parent_id:", data.USER_parent_id);
          console.log("USER_Allow1_amount:", data.USER_Allow1_amount);
          // Getting user notification token
          const receiverToken = await getUserToken(data.USER_kid_id);
          console.log("Reeciver Device Token Token:", receiverToken);
          // Sending money to Donations Wallet
          await sendMoneyToSaving0rDonationWallet(data.USER_kid_id, "Donations-Wallet", data.USER_donate_amount);
          // Sending money to Savings Wallet
          await sendMoneyToSaving0rDonationWallet(data.USER_kid_id, "Savings-Wallet-Main", data.USER_saving_amount);
          // Sending money to Spend Wallet
          const status = await deductMoneyFromUserAccount(
              data.USER_parent_id, data.USER_Allow1_amount, receiverToken, data.USER_kid_id, data.USER_Main_amount);
          // Balance is not s
          if (status == "Insufficient balance") {
            const parentDeviceToken = await getUserToken(data.USER_parent_id);
            console.log("Parent Device Token Token:", receiverToken);
            sendingNotification(parentDeviceToken,
                "You dont have enough balance",
                "Make Sure to charge your spend wallet so your kid get his allowance");
            // Kid Side notification
            sendingNotification(receiverToken,
                "You Allowance is stoped",
                "Tell your parent to charge your spend wallet so you get allowance");
          }
          const nextDate = calculateNextExecutionDate(data.created_at, data.USER_allowance_schedule);
          await updateUserAllowanceDateTime(data.USER_kid_id, nextDate);
          console.log("Next Date of excution is:", nextDate);
          try {
            await moveMoney(
                data.USER_allowance_Parent_BankAccount_Id,
                data.USER_allowance_Kid_BankAccount_Id,
                data.USER_Allow1_amount,
                `${MTransactiontype}=${TAG_IT_TRANSACTION_TYPE_ALLOWANCE},` +
      `${MFromWallet}=${SpendWallet},` +
      `${MToWallet}=${SpendWallet},` +
      `${MGoalid}=,` +
      `${MTransactionMethod}=${TRANSACTION_METHOD_PAYMENT},` +
      `${MTagItId}=${TAG_IT_ID_ALLOWANCE},` +
      `${MTagItName}=${TAG_IT_TRANSACTION_TYPE_ALLOWANCE},` +
      `SID=${data.USER_parent_id},` +
      `RID=${data.USER_kid_id},` +
      `TID=,LATLNG:`,
            );
          } catch (error) {
            console.error("Error fetching users created today:", error);
          }
          // You can now use `await` here if needed, for example:
          // await someAsyncOperation(data.USER_kid_id);
        }
        // snapshot.forEach((doc) => {
        //   const data = doc.data();
        //   console.log("USER_kid_id:", data.USER_kid_id);
        //   console.log("USER_parent_id:", data.USER_parent_id);
        //   console.log("USER_Allow1_amount:", data.USER_Allow1_amount);
        //   usersData.push(doc.data()); // Push each user's data into the array
        //   // Deduct money from spend wallet to spend wallet
        // });

        // Return the users' data as a JSON response
        // console.log("No users with expired subscriptions found.");
        console.log(usersData);
        return usersData;
      } catch (error) {
        console.error("Error fetching users created today:", error);
        return console.log("No users with expired subscriptions found.");
      }
    });
function calculateNextExecutionDate(createdAt, schedule) {
  // Convert Firestore Timestamp to JavaScript Date object if it's not already
  const currentDate = createdAt instanceof Date ? createdAt : createdAt.toDate();

  const nextDate = new Date(currentDate); // Create a copy of the date

  // Calculate next execution date based on the schedule
  switch (schedule.toLowerCase()) {
    case "daily":
      nextDate.setDate(currentDate.getDate() + 1); // Add 1 day for daily
      break;
    case "weekly":
      nextDate.setDate(currentDate.getDate() + 7); // Add 7 days for weekly
      break;
    case "monthly":
      nextDate.setMonth(currentDate.getMonth() + 1); // Add 1 month for monthly
      break;
    default:
      throw new Error("Invalid schedule: " + schedule);
  }
  return nextDate; // Return the next execution date as a Date object
}
async function getUserToken(userId) {
  const tokenRef = db.collection("USER").doc(userId);
  const tokenRefDoc = await tokenRef.get();
  const tokenData = tokenRefDoc.data();
  const receiverToken = await tokenData.USER_iNApp_NotifyToken;
  return receiverToken;
}
async function updateUserAllowanceDateTime(userId, nextDateToExcute) {
  try {
    const userAllowanceRef = db.collection("ALLOW").doc(userId);
    const userAllowanceDoc = await userAllowanceRef.get();
    if (!userAllowanceDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    // const senderWallet = senderWalletDoc.data();
    // const senderBalance = senderWallet.wallet_balance;
    await userAllowanceRef.update({
      created_at: nextDateToExcute,
    });
    // await receiverWalletRef.update({wallet_balance: newReceiverBalance});

    // const userRef = db.collection("USER").doc(userSenderId);
    // await userRef.update({USER_created_at: new Date(dateTime)});

    return {success: true, message: "User Next Date Updated"};
  } catch (error) {
    console.error("Error updating document", error);
    return {success: false, message: error.message || error.toString()};
  }
}
//
async function updateUserSubscriptionDateTime(userId, nextDateToExcute) {
  try {
    const userAllowanceRef = db.collection("USER").doc(userId);
    const userAllowanceDoc = await userAllowanceRef.get();
    if (!userAllowanceDoc.exists) {
      throw new Error("Sender's not found");
    }
    // const senderWallet = senderWalletDoc.data();
    // const senderBalance = senderWallet.wallet_balance;
    await userAllowanceRef.update({
      DateOfExpirationSubscription: nextDateToExcute,
    });
    // await receiverWalletRef.update({wallet_balance: newReceiverBalance});

    // const userRef = db.collection("USER").doc(userSenderId);
    // await userRef.update({USER_created_at: new Date(dateTime)});

    return {success: true, message: "User Next Date Updated"};
  } catch (error) {
    console.error("Error updating document", error);
    return {success: false, message: error.message || error.toString()};
  }
}

// exports.anotherFunction = functions.https.onCall(async (data, context) => {
//   const cronExpression = data.cronExpression;// Cron expression from Flutter
//   const timezone = data.timezone || "UTC";// Default to UTC if no timezone is passed

//   try {
//     console.debug("Received cron expression: " + cronExpression+timezone);

//     // Use the existing URL for the Cloud Run or Cloud Function that you provided
//     const targetUrl = "https://runeveryday2am-i2tqsoankq-uc.a.run.app/"; // Your existing function URL

//     // Create a new Cloud Scheduler job
//     const job = {
//       name: `projects/zakipayapp/locations/us-central1/jobs/dynamic-job-${Date.now()}`, // Use zakipayapp project ID
//       schedule: cronExpression, // Cron expression (e.g., '0 2 * * *' for 2 AM daily)
//       timeZone: timezone, // Timezone for the cron job (default to UTC)
//       httpTarget: {
//         uri: targetUrl, // The URL of the function to be triggered by the scheduler
//         httpMethod: "POST", // Use POST to trigger the function
//       },
//     };

//     // Define the parent path with your project ID and location
//     const parent = `projects/zakipayapp/locations/us-central1`;

//     // Create the Cloud Scheduler job
//     const [response] = await schedulerClient.createJob({
//       parent: parent,
//       job: job,
//     });

//     console.log("Scheduler job created successfully: ", response.name);

//     return {status: "Job created successfully", jobId: response.name};
//   } catch (error) {
//     console.error("Error creating scheduler job:", error);
//     throw new functions.https.HttpsError("internal", "Failed to create scheduler job", error);
//   }
// });
exports.accountcleanup = onSchedule(cronExpression, async (event) => {
  logger.log("User cleanup finished");
  const dateTimeString = event.dateTime; // Get the dateTime from the request
  // const dateTime = new Date(dateTimeString);
  const useReceiverId = event.useReceiverId;
  const userSenderId = event.userSenderId;
  const userToken = event.userToken;
  const title = event.title;
  const body = event.body;
  const amount = event.amount;
  const updatedData ={USER_created_at: dateTimeString};

  try {
    console.debug(`Receiver id: ${useReceiverId}, Sender Id: ${userSenderId} token ${userToken}, cron: ${cronExpression}`);

    // Retrieve sender"s wallet balance
    const senderWalletRef = db.collection("USER").doc(userSenderId).collection("USER_WALLETS").doc("Spend-Wallet");
    const senderWalletDoc = await senderWalletRef.get();
    if (!senderWalletDoc.exists) {
      throw new Error("Sender's wallet not found");
    }
    const senderWallet = senderWalletDoc.data();
    const senderBalance = senderWallet.wallet_balance;

    // Retrieve receiver"s wallet balance
    const receiverWalletRef = db.collection("USER").doc(useReceiverId).collection("USER_WALLETS").doc("Spend-Wallet");
    const receiverWalletDoc = await receiverWalletRef.get();
    if (!receiverWalletDoc.exists) {
      throw new Error("Receiver's wallet not found");
    }
    const receiverWallet = receiverWalletDoc.data();
    const receiverBalance = receiverWallet.wallet_balance;

    // Check if sender has enough balance
    if (senderBalance < amount) {
      throw new Error("Sender has insufficient balance");
    }

    // Update balances
    const newSenderBalance = senderBalance - amount;
    const newReceiverBalance = receiverBalance + amount;

    // Save updated balances
    await senderWalletRef.update({wallet_balance: newSenderBalance});
    await receiverWalletRef.update({wallet_balance: newReceiverBalance});

    // Update user"s document with timestamp
    const userRef = db.collection("USER").doc(userSenderId);
    await userRef.update(updatedData);

    // Send notification
    if (!userToken) {
      throw new Error("Invalid or missing userToken");
    }

    const payload = {
      notification: {
        title: title,
        body: body,
      },
      token: userToken,
    };

    const response = await messaging.send(payload);

    console.log("Notification sent", response);
    return {success: true, message: "Money transferred and notification sent successfully."};
  } catch (error) {
    console.error("Error updating document or sending notification", error);
    return {success: false, message: error.message || error.toString()};
  }
});

exports.userSubscriptionCheckFunction = onSchedule("* * * * *",
    async (event) => {
      try {
        const today = new Date();
        console.log(`User Subscription Check function is being called. ${today}`);
        // Get today's date in YYYY-MM-DD format
        const todayStart = new Date(today.setHours(0, 0, 0, 0)); // Start of today
        const todayEnd = new Date(today.setHours(23, 59, 59, 999)); // End of today

        // Query Firestore for documents in the 'ALLOW' collection where 'created_at' is today
        const snapshot = await db.collection("USER")
            .where("DateOfExpirationSubscription", ">=", todayStart)
            .where("DateOfExpirationSubscription", "<=", todayEnd)
            .get();

        // Check if there are any users created today
        if (snapshot.empty) {
          console.log("No users Found.");
        }
        const usersData = [];
        for (const doc of snapshot.docs) {
          const data = doc.data();
          console.log("Next Expiration Date:", data.DateOfExpirationSubscription);
          console.log("Expiration Date:", data.DateOfSubscription);
          const status = await deductMoneyFromUserAccountWithNoReceiver(data.USER_UserID, 5);
          // Balance is not s
          if (status == "Insufficient balance") {
            console.log("Parent Device Token Token:", `${data.USER_iNApp_NotifyToken}`);
            sendingNotification(data.USER_iNApp_NotifyToken,
                "You dont have enough balance",
                "Your subscription is not renewed. Low balance");
          }
          try {
            await moveMoney(
                data.User_BankAccountID,
                ZAKI_PAY_ACCOUNT_NUMBER,
                20,
                `${MTransactiontype}=${TAG_IT_TRANSACTION_TYPE_SUBSCRIPTION},` +
      `${MFromWallet}=${SpendWallet},` +
      `${MToWallet}=${SpendWallet},` +
      `${MGoalid}=,` +
      `${MTransactionMethod}=${TRANSACTION_METHOD_PAYMENT},` +
      `${MTagItId}=${TAGID},` +
      `${MTagItName}=${TAGID0005},` +
      `SID=${data.USER_UserID},` +
      `RID=${ZAKI_PAY_ACCOUNT_NUMBER},` +
      `TID=,LATLNG:`,
            );
          } catch (error) {
            console.error("Error fetching users created today:", error);
          }
          const nextDate = calculateNextExecutionDate(data.DateOfExpirationSubscription, "monthly");
          await updateUserSubscriptionDateTime(data.USER_UserID, nextDate);
          console.log("Next New Expiration Date:", nextDate.toDateString);
        }
        console.log(usersData);
        return usersData;
      } catch (error) {
        console.error("Error fetching users created today:", error);
        return console.log("No users with expired subscriptions found.");
      }
    });
//
exports.spendLmitRestEveryMonth = onSchedule("* * * * *",
    async (event) => {
      try {
        // const database = getFirestore();
        const today = new Date();
        console.log(`Update Spend limit function is being called. ${today}`);
        // Get today's date in YYYY-MM-DD format
        // const todayStart = new Date(today.setHours(0, 0, 0, 0)); // Start of today
        // const todayEnd = new Date(today.setHours(23, 59, 59, 999)); // End of today

        // Query Firestore for documents in the 'ALLOW' collection where 'created_at' is today
        // const spendLCollectionRef = database.collection("SpendL").doc("zuE7Ai1OgzUuQENncxNl").collection("SpendL");
        // Query the top-level SpendL collection
        // Query the top-level SpendL collection
        const topLevelSpendLCollection = await db.collection("SpendL");
        const topLevelDocs = await topLevelSpendLCollection.get();
        if (topLevelDocs.empty) {
          console.log("No documents found in the top-level SpendL collection.");
          // return;
        } else {
          console.log("There are Documents into database", topLevelDocs.size);
          for (const spendLDoc of topLevelDocs.docs) {
            console.log("Top-level SpendL document ID:", spendLDoc.id); // Log document ID
            const data = spendLDoc.data();
            const SpendLTransactionAmountMax = data.SpendL_Transaction_Amount_Max;
            let SpendLTransactionAmountRemain = data.SpendL_Transaction_Amount_Remain;
            SpendLTransactionAmountRemain = SpendLTransactionAmountMax;
            //
            const SpendLTAGID0001Max = data.SpendL_TAGID0001_Max;
            let SpendLTAGID0001Remain = data.SpendL_TAGID0001_Remain;
            SpendLTAGID0001Remain = SpendLTAGID0001Max;
            //
            const SpendLTAGID0002Max = data.SpendL_TAGID0002_Max;
            let SpendLTAGID0002Remain = data.SpendL_TAGID0002_Remain;
            SpendLTAGID0002Remain=SpendLTAGID0002Max;
            //
            const SpendLTAGID0003Max = data.SpendL_TAGID0003_Max;
            let SpendLTAGID0003Remain = data.SpendL_TAGID0003_Remain;
            SpendLTAGID0003Remain=SpendLTAGID0003Max;
            //
            const SpendLTAGID0005Max = data.SpendL_TAGID0005_Max;
            let SpendLTAGID0005Remain = data.SpendL_TAGID0005_Remain;
            SpendLTAGID0005Remain = SpendLTAGID0005Max;
            //
            const SpendLTAGID0006Max = data.SpendL_TAGID0006_Max;
            let SpendLTAGID0006Remain = data.SpendL_TAGID0006_Remain;
            SpendLTAGID0006Remain = SpendLTAGID0006Max;
            //
            const SpendLTAGID0007Max = data.SpendL_TAGID0007_Max;
            let SpendLTAGID0007Remain = data.SpendL_TAGID0007_Remain;
            SpendLTAGID0007Remain = SpendLTAGID0007Max;
            //
            const SpendLTAGID0008Max = data.SpendL_TAGID0008_Max;
            let SpendLTAGID0008Remain = data.SpendL_TAGID0008_Remain;
            SpendLTAGID0008Remain = SpendLTAGID0008Max;
            //
            const SpendLTAGID0009Max = data.SpendL_TAGID0009_Max;
            let SpendLTAGID0009Remain = data.SpendL_TAGID0009_Remain;
            SpendLTAGID0009Remain =SpendLTAGID0009Max;
            //
            const SpendLTAGID0010Max = data.SpendL_TAGID0010_Max;
            let SpendLTAGID0010Remain = data.SpendL_TAGID0010_Remain;
            SpendLTAGID0010Remain =SpendLTAGID0010Max;
            //
            const SpendLTAGID0011Max = data.SpendL_TAGID0011_Max;
            let SpendLTAGID0011Remain = data.SpendL_TAGID0011_Remain;
            SpendLTAGID0011Remain = SpendLTAGID0011Max;
            //
            const userRef = db.collection("SpendL").doc(data.SpendL_user_id);
            await userRef.update({
              // SpendL_Transaction_Amount_Max: int.parse(totalAmount!),
              SpendL_Transaction_Amount_Remain: SpendLTransactionAmountRemain,
              // SpendL_TAGID0001_Max: int.parse(tAGID0001Amount!),
              SpendL_TAGID0001_Remain: SpendLTAGID0001Remain,
              // SpendL_TAGID0001_mcc_id: AppConstants.tagItList[1].mccId,
              // SpendL_TAGID0003_Max: int.parse(tAGID0003Amount!),
              SpendL_TAGID0003_Remain: SpendLTAGID0003Remain,
              // SpendL_TAGID0003_mcc_id: AppConstants.tagItList[2].mccId,
              // SpendL_TAGID0002_Max: int.parse(tAGID0002Amount!),
              SpendL_TAGID0002_Remain: SpendLTAGID0002Remain,
              // SpendL_TAGID0005_Max: int.parse(tAGID0005Amount!),
              SpendL_TAGID0005_Remain: SpendLTAGID0005Remain,
              // SpendL_TAGID0005_mcc_id: AppConstants.tagItList[4].mccId,
              // SpendL_TAGID0006_Max: int.parse(tAGID0006Amount!),
              SpendL_TAGID0006_Remain: SpendLTAGID0006Remain,
              // SpendL_TAGID0006_mcc_id: AppConstants.tagItList[5].mccId,
              // SpendL_TAGID0007_Max: int.parse(tAGID0007Amount!),
              SpendL_TAGID0007_Remain: SpendLTAGID0007Remain,
              // SpendL_TAGID0007_mcc_id: AppConstants.tagItList[6].mccId,
              // SpendL_TAGID0008_Max: int.parse(tAGID0008Amount!),
              SpendL_TAGID0008_Remain: SpendLTAGID0008Remain,
              // SpendL_TAGID0008_mcc_id: AppConstants.tagItList[7].mccId,
              // SpendL_TAGID0009_Max: int.parse(tAGID0009Amount!),
              SpendL_TAGID0009_Remain: SpendLTAGID0009Remain,
              // SpendL_TAGID0009_mcc_id: AppConstants.tagItList[8].mccId,
              // SpendL_TAGID0010_Max: int.parse(tAGID0010Amount!),
              SpendL_TAGID0010_Remain: SpendLTAGID0010Remain,
              // SpendL_TAGID0010_mcc_id: AppConstants.tagItList[9].mccId,
              // SpendL_TAGID0011_Max: int.parse(tAGID0011Amount!),
              SpendL_TAGID0011_Remain: SpendLTAGID0011Remain,
              // SpendL_TAGID0011_mcc_id: AppConstants.tagItList[10].mccId,
              // SpendL_daily_Amount_Max: int.parse(dailyAmount!),
              // SpendL_daily_Amount_Remain: int.parse(dailyAmount),
              // SpendL_TAGID0022_mcc_id: AppConstants.tagItList[10].mccId,
            });
            console.log("SpendL_TAGID0001_Max Value:", SpendLTAGID0001Max);
            // const nestedSpendLCollectionRef = spendLDoc.ref.collection("SpendL");
            // const userSnapshots = await nestedSpendLCollectionRef.get();
            // console.log(`Nested SpendL document count for ${spendLDoc.id}:`, userSnapshots.size);
            // Log nested count
            // for (const userDoc of userSnapshots.docs) {
            //   const userData = userDoc.data();
            //   console.log("User data:", userData); // Log user data if available
            // }
          }
        }
      } catch (error) {
        console.error("Error resetting SpendL Remain values:", error);
      }
    });
//
exports.spendLimitResetEveryDay = onSchedule("* * * * *",
    async (event) => {
      try {
        // const database = getFirestore();
        const today = new Date();
        console.log(`Every day Update Spend limit function is being called. ${today}`);
        const topLevelSpendLCollection = await db.collection("SpendL");
        const topLevelDocs = await topLevelSpendLCollection.get();
        if (topLevelDocs.empty) {
          console.log("No documents found in the top-level SpendL collection.");
          // return;
        } else {
          console.log("There are Documents into database", topLevelDocs.size);
          for (const spendLDoc of topLevelDocs.docs) {
            console.log("Top-level SpendL document ID:", spendLDoc.id); // Log document ID
            const data = spendLDoc.data();
            const SpendLdailyAmountMax = data.SpendL_daily_Amount_Max;
            let SpendLdailyAmountRemain = data.SpendL_daily_Amount_Remain;
            SpendLdailyAmountRemain = SpendLdailyAmountMax;
            const userRef = db.collection("SpendL").doc(data.SpendL_user_id);
            await userRef.update({
              // SpendL_Transaction_Amount_Max: int.parse(totalAmount!),
              SpendL_daily_Amount_Remain: SpendLdailyAmountRemain,
            });
            console.log("SpendLdailyAmountMax Value:", SpendLdailyAmountMax);
          }
        }
      } catch (error) {
        console.error("Error resetting SpendL Remain values:", error);
      }
    });
// Webhook handler for Marqeta
exports.marqetaWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const event = req.body.event; // Marqeta event type
    const data = req.body.data; // Marqeta transaction data

    if (event === "transaction.authorized") {
      const {mcc, amount, userToken} = data;

      // Fetch spend limits for the user from Firestore
      const spendLimitsSnapshot = await db
          .collection("SpendL")
          .where("SpendL_user_id", "==", userToken)
          .get();

      if (spendLimitsSnapshot.empty) {
        console.error("No spend limits found for user:", userToken);
        return res.status(404).send({approved: false, message: "No spend limits found"});
      }

      // Loop through spend limits to find a match for the MCC
      let transactionApproved = false;

      for (const doc of spendLimitsSnapshot.docs) {
        const spendL = doc.data();

        // Check if MCC matches and if the remaining balance allows the transaction
        if (spendL.SpendL_TAGID0001_mcc_id === mcc) {
          const remainingLimit = spendL.SpendL_TAGID0001_Remain;

          if (amount <= remainingLimit) {
            transactionApproved = true;

            // Deduct the amount from the remaining limit
            const updatedRemaining = remainingLimit - amount;

            await db.collection("SpendL").doc(doc.id).update({
              SpendL_TAGID0001_Remain: updatedRemaining,
            });

            console.log(`Transaction approved for user ${userToken} on MCC ${mcc}`);
            return res.status(200).send({approved: true});
          }
        }
      }

      // Decline the transaction if no limits allow it
      if (!transactionApproved) {
        console.error(`Transaction declined for user ${userToken} on MCC ${mcc}`);
        return res.status(403).send({approved: false, message: "Transaction exceeds spend limit"});
      }
    } else {
      console.log(`Unhandled event type: ${event}`);
      return res.status(200).send({message: "Event received"});
    }
  } catch (error) {
    console.error("Error processing webhook:", error);
    res.status(500).send({error: "Server error"});
  }
});
