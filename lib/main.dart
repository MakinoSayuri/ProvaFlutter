import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Abastecimento',
        theme: ThemeData(
          useMaterial3: true,

          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink.shade300,
            primary: Colors.pink.shade400,
            secondary: Colors.pink.shade200,
            surface: Colors.white,
            background: Colors.pink.shade50,
          ),

          scaffoldBackgroundColor: Colors.pink.shade50,

          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'Inter'),
            bodyLarge: TextStyle(fontFamily: 'Inter'),
            titleLarge: TextStyle(fontFamily: 'Inter'),
          ),

          appBarTheme: AppBarTheme(
            backgroundColor: Colors.pink.shade300,
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.pink.shade200.withOpacity(0.4),
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Colors.white,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(26),
              ),
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStatePropertyAll(2),
              backgroundColor: MaterialStatePropertyAll(Colors.pink.shade400),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: 14, horizontal: 26),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 4,
            backgroundColor: Colors.pink.shade300,
            foregroundColor: Colors.white,
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.pink.shade50,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(
                color: Colors.pink.shade300,
                width: 2,
              ),
            ),
            labelStyle: TextStyle(
              color: Colors.pink.shade400,
              fontFamily: "Inter",
            ),
            prefixIconColor: Colors.pink.shade300,
          ),
        ),

        routes: {
          '/': (context) => const EntryPoint(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return StreamBuilder(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.hasData ? const HomePage() : const LoginPage();
      },
    );
  }
}
