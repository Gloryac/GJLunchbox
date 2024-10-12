import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DJ Lunchbox App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainView(),
    );
  }
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-n6ayoeyocngwbam1.us.auth0.com',
        'LGPJ2EKhu6PWfX5svHminkXJ4rW4gVVK');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
            child: _credentials == null
                ? ElevatedButton(
                    onPressed: () async {
                      final credentials =
                          await auth0.webAuthentication().login(useHTTPS: true);

                      setState(() {
                        _credentials = credentials;
                      });
                    },
                    child: const Text("Log in"),
                  )
                : ElevatedButton(
                    onPressed: () async {
                      await auth0.webAuthentication().logout(useHTTPS: true);

                      setState(() {
                        _credentials = null;
                      });
                    },
                    child: const Text("Log out"),
                  )),
      ),
    );
  }
}
