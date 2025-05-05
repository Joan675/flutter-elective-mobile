// lib/screens/home_page.dart
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _message = "Welcome to the app!";

  void _incrementCounter() {
    setState(() {
      _counter++;
      _message = "You clicked the button $_counter times!";
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _message = "Counter reset!";
    });
  }

  void _showSnackBar(BuildContext ctx) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text("Snackbar: $_message"), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_message, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _incrementCounter, child: const Text("Increment Counter")),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: () => _showSnackBar(context), child: const Text("Show Snackbar")),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _resetCounter,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Reset Counter"),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _incrementCounter, tooltip: 'Increment', child: const Icon(Icons.add)),
    );
  }
}
