// // import 'package:chatview/chatview.dart';

// import 'dart:convert';
// import 'dart:io';

// // import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// // import 'package:intl/date_symbol_data_local.dart';
// import 'package:mime/mime.dart';
// // import 'package:open_filex/open_filex.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zaki/Constants/Styles.dart';
// import 'package:zaki/Widgets/CustomLoadingScreen.dart';
// class Chatui extends StatefulWidget {
//   const Chatui({key});

//   @override
//   State<Chatui> createState() => _ChatuiState();
// }

// class _ChatuiState extends State<Chatui> {
//   @override
//   Widget build(BuildContext context) {
//         var height = MediaQuery.of(context).size.height;
//     // var width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: white,
//         elevation: 0.8,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: CircleAvatar(
//             backgroundColor: transparent,
//             radius: 20,
//             backgroundImage: 
//             AssetImage(imageBaseAddress+"meta.png")
//             // NetworkImage(
//             //   'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Meta_Platforms_Inc._logo.svg/512px-Meta_Platforms_Inc._logo.svg.png',
//             // ),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Meta AI',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               'Online',
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         actions: const [
//           // Icon(Icons.phone, color: Colors.black87),
//           // SizedBox(width: 16),
//           Icon(Icons.qr_code, color: Colors.black87),
//           SizedBox(width: 12),
//         ],
//       ),
//       // appBar: AppBar(
//       //   leading: Icon(Icons.model_training_sharp, color: white),
//       // ),
//       body: SafeArea(
//         child: SizedBox(
//           height: height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               // Padding(
//               //   padding: getCustomPadding(),
//               // child: 
//               // appBarHeader_005(
//               //   appBarTitle: 'Welcome to chat',
//               //   context: context,
//               //   backArrow: true,
//               //   height: height,
//               //   width: width,
//               //   leadingIcon: false,
//               //   appBarTitleLeftAlign: true,
//               //   leadingImage: Image.asset(imageBaseAddress+"meta.png", height: width*0.08,width: width*0.08,),

//               //   requiredHeader: false
//               // )

//               // ),
//               Expanded(
//                 child: ChatPage()),
//             ],
//           ),
//         ),
//         )
//     );
//   }
// }

// // void main() {
// //   initializeDateFormatting().then((_) => runApp(const MyApp()));
// // }



// class ChatPage extends StatefulWidget {
//   // const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   List<types.Message> _messages = [];
//   final _user = const types.User(
//     id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
//   );

//   @override
//   void initState() {
//     super.initState();
//     _loadMessages();
//   }

//   void _addMessage(types.Message message) {
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   void _handleAttachmentPressed() {
//     showModalBottomSheet<void>(
//       context: context,
//       builder: (BuildContext context) => SafeArea(
//         child: SizedBox(
//           height: 144,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleImageSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Photo'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleFileSelection();
//                 },
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('File'),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Align(
//                   alignment: AlignmentDirectional.centerStart,
//                   child: Text('Cancel'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _handleFileSelection() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//     );

//     if (result != null && result.files.single.path != null) {
//       final message = types.FileMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: const Uuid().v4(),
//         mimeType: lookupMimeType(result.files.single.path!),
//         name: result.files.single.name,
//         size: result.files.single.size,
//         uri: result.files.single.path!,
//       );

//       _addMessage(message);
//     }
//   }

//   void _handleImageSelection() async {
//     final result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );

//     if (result != null) {
//       final bytes = await result.readAsBytes();
//       final image = await decodeImageFromList(bytes);

//       final message = types.ImageMessage(
//         author: _user,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         height: image.height.toDouble(),
//         id: const Uuid().v4(),
//         name: result.name,
//         size: bytes.length,
//         uri: result.path,
//         width: image.width.toDouble(),
//       );

//       _addMessage(message);
//     }
//   }

//   void _handleMessageTap(BuildContext _, types.Message message) async {
//     if (message is types.FileMessage) {
//       var localPath = message.uri;

//       if (message.uri.startsWith('http')) {
//         try {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: true,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });

//           final client = http.Client();
//           final request = await client.get(Uri.parse(message.uri));
//           final bytes = request.bodyBytes;
//           final documentsDir = (await getApplicationDocumentsDirectory()).path;
//           localPath = '$documentsDir/${message.name}';

//           if (!File(localPath).existsSync()) {
//             final file = File(localPath);
//             await file.writeAsBytes(bytes);
//           }
//         } finally {
//           final index =
//               _messages.indexWhere((element) => element.id == message.id);
//           final updatedMessage =
//               (_messages[index] as types.FileMessage).copyWith(
//             isLoading: null,
//           );

//           setState(() {
//             _messages[index] = updatedMessage;
//           });
//         }
//       }

//       // await OpenFilex.open(localPath);
//     }
//   }

//   void _handlePreviewDataFetched(
//     types.TextMessage message,
//     types.PreviewData previewData,
//   ) {
//     final index = _messages.indexWhere((element) => element.id == message.id);
//     final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
//       previewData: previewData,
//     );

//     setState(() {
//       _messages[index] = updatedMessage;
//     });
//   }

//   void _handleSendPressed(types.PartialText message) {
//     final textMessage = types.TextMessage(
//       author: _user,
//       createdAt: DateTime.now().millisecondsSinceEpoch,
//       id: const Uuid().v4(),
//       text: message.text,
//     );

//     _addMessage(textMessage);
//   }

//   void _loadMessages() async {
//     final response = await rootBundle.loadString('assets/messages.json');
//     final messages = (jsonDecode(response) as List)
//         .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
//         .toList();

//     setState(() {
//       _messages = messages;
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Chat(
//           theme: DefaultChatTheme(
//           inputTextColor: Colors.black87,
//           inputTextStyle: const TextStyle(
//             color: Colors.black87,
//             fontSize: 16,
//           ),
//           inputBackgroundColor: const Color(0xFFF0F0F0), // WhatsApp-like gray
//           inputBorderRadius: BorderRadius.circular(24),  // Rounded like WhatsApp
//           inputPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 12,
//           ),
//           sendButtonIcon: Icon( // Optional: WhatsApp-style send button
//             Icons.send_rounded,
//             color: Colors.green,
//           ),
//         ),

//         inputOptions: const InputOptions(
//           autocorrect: true,
//           enableSuggestions: true,
//         ),
//           // theme: ChatTheme(
//           //   backgroundColor: Colors.white,
//           //   inputBackgroundColor: Colors.white,
//           //   inputTextColor: Colors.black,
//           //   primaryColor: Colors.blue,
            
//           //   // sentMessageBodyColor: Colors.blue,
//           //   // sentMessageBorderColor: Colors.blue,
//           //   // sentMessageTextColor: Colors.white,
//           //   // receivedMessageBodyColor: Colors.grey.shade200,
//           //   // receivedMessageBorderColor: Colors.grey.shade200,
//           // ),
//           messages: _messages,
//           onAttachmentPressed: _handleAttachmentPressed,
//           onMessageTap: _handleMessageTap,
//           onPreviewDataFetched: _handlePreviewDataFetched,
//           onSendPressed: _handleSendPressed,
//           showUserAvatars: true,
//           showUserNames: true,
//           user: _user,
//         ),
//       );
// }


// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   bool _isLoading = false;
//   // final String customModelName = 'gemini-2.0-flash';
//   final String customModelName = 'projects/aichat-457808/locations/us-central1/agents/901d59b6-589f-431c-8be3-daca6f6766a7-chat-1745493917'; // custom model path

//   // Gemini API key
//   final String _apiKey = "AIzaSyBOsbMo9enAM5QIV9w7D8UuWDi-emoDZ78";

//   late GenerativeModel _model;
//   late ChatSession _chat;

//   @override
//   void initState() {
//     super.initState();
//     _model = GenerativeModel(
//       model: customModelName,
//       apiKey: _apiKey,
//     );
//     _chat = _model.startChat();
//   }

//   Future<void> _sendMessage() async {
//     final input = _controller.text.trim();
//     if (input.isEmpty) return;

//     setState(() {
//       _messages.add({'role': 'user', 'text': input});
//       _isLoading = true;
//     });

//     _controller.clear();

//     try {
//       final response = await _chat.sendMessage(Content.text(input));
//       final output = response.text ?? "⚠️ No response from Gemini";

//       setState(() {
//         _messages.add({'role': 'gemini', 'text': output});
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add({'role': 'gemini', 'text': '❌ Error: $e'});
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Widget _buildMessage(Map<String, String> message) {
//     final isUser = message['role'] == 'user';
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blue[100] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Text(message['text'] ?? ''),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.8,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 12),
//           child: CircleAvatar(
//             backgroundColor: transparent,
//             radius: 20,
//             backgroundImage: 
//             AssetImage(imageBaseAddress+"meta.png")
//             // NetworkImage(
//             //   'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Meta_Platforms_Inc._logo.svg/512px-Meta_Platforms_Inc._logo.svg.png',
//             // ),
//           ),
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               'Meta AI',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               'Online',
//               style: TextStyle(
//                 color: Colors.green,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//         centerTitle: true,
//         actions: const [
//           // Icon(Icons.phone, color: Colors.black87),
//           // SizedBox(width: 16),
//           Icon(Icons.history, color: Colors.black87),
//           SizedBox(width: 12),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return _buildMessage(_messages[index]);
//               },
//             ),
//           ),
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.only(bottom: 12),
//               child: Center(
//                 child: CustomLoadingScreen(
//                   small: true,
//                   )
//               )
//             ),
//           Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//   child: Container(
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//     decoration: BoxDecoration(
//       color: Colors.grey[200], // Light filled background
//       borderRadius: BorderRadius.circular(24), // Rounded like WhatsApp/Meta AI
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _controller,
//             onSubmitted: (_) => _sendMessage(),
//             decoration: const InputDecoration(
//               hintText: "Ask something...",
//               border: InputBorder.none, // No border
//               isCollapsed: true, // Remove default padding
//             ),
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//         const SizedBox(width: 8),
//         IconButton(
//           icon: const Icon(Icons.send, size: 20), // Smaller send icon
//           onPressed: _sendMessage,
//           color: Colors.blue, // Optional: color the send icon
//           padding: EdgeInsets.zero, // Remove extra padding
//           constraints: BoxConstraints(), // Remove size constraints
//         ),
//       ],
//     ),
//   ),
// )

//         ],
//       ),
//     );
//   }
// }
