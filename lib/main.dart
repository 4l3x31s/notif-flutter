import 'package:flutter/material.dart';
import 'package:notif/screens/home_screen.dart';
import 'package:notif/screens/message_screen.dart';
import 'package:notif/services/push_notifications_service.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await PushNotificationService.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey = new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService.messagesStram.listen((message) {
      print('MyApp: $message');
      navigatorKey.currentState?.pushNamed('message', arguments: message);

      final snackbar = SnackBar(content: Text(message));

      messengerKey.currentState?.showSnackBar(snackbar);
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      navigatorKey: navigatorKey, //navegar
      scaffoldMessengerKey: messengerKey, //snacks
      routes: {
        'home': (_)=> HomeScreen(),
        'message':(_) => MessageScreen()
      },
    );
  }
}