import 'package:flutter/material.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'BrewHub',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
            ),
            home: const MyHomePage(title: 'BrewHub Login'),
            debugShowCheckedModeBanner: false,
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});

    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        ClipOval(
                            child: SizedBox(
                                width: 180.0,
                                height: 180.0,
                                child: Image.asset(
                                    'assets/doggo.jpg',
                                    fit: BoxFit.cover
                                ),
                            )
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'email',
                                    border: OutlineInputBorder(),
                                )
                            ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'password',
                                    border: OutlineInputBorder(),
                                )
                            ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            width: 300,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                            // TODO: handle sign up
                                        },
                                        child: const Text('Sign up')
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                            // TODO: handle login
                                        },
                                        child: const Text('Login')
                                    ),
                                ]
                            )
                        )
                    ],
                ),
            ),
        );
    }
}
