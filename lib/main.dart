import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'login/loginpage.dart';
import 'provider/app_theme_provider.dart';
import 'utils/app_theme.dart';
import 'widgets/bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(context, ref.watch(appThemeProvider)),
        home: const AuthenticationWrapper());
    // home: MaterialApp(
    //   home: Scaffold(
    //     body: Center(
    //         child: ElevatedButton(
    //             onPressed: () {
    //               FirebaseFirestore.instance
    //                   .collection("user")
    //                   .add({"name": "kalpesh"});
    //             },
    //             child: Text("enter"))),
    //   ),
    // ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // return LoginPage();
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          print(user);
          if (user == null) {
            return LoginPage();
          } else {
            if (user.emailVerified) {
              return const BottomNavigationExample();
            } else {
              return LoginPage();
            }
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
