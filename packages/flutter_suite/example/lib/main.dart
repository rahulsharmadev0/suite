import 'package:flutter_suite/flutter_suite.dart';

import 'demos/export.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppRun());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRun extends StatelessWidget {
  const AppRun({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      initialRoute: '/HomePage',
      routes: {
        '/HomePage': (context) => const HomePage(),
        '/JMarqueeDemo': (context) => const JMarqueeDemo(),
        '/JToastandJSnakBarDemo': (context) => const JToastandJSnakBarDemo(),
        '/JDialogsDemo': (context) => const JDialogsDemo(),
      },
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Welcome in JARS ❤️ Demo\ndeveloped by @rahulsharmadev',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.white)),
            const SizedBox(height: 64),
            ...{
              '/JMarqueeDemo': 'JMarquee Demo',
              '/JToastandJSnakBarDemo': 'JToast & JSnakBar Demo',
              '/JDialogsDemo': 'JDialogs Demo',
            }
                .entries
                .map((e) => TextButton(
                      onPressed: () => navigatorKey.currentState?.pushNamed(e.key),
                      child: Text(e.value),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
