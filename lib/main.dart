import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:personal_expense/widgets/chart.dart';
import 'package:personal_expense/widgets/new_transaction.dart';
import 'package:personal_expense/widgets/transaction_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        //primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
              color: Colors.black,
            )),
        colorScheme: ColorScheme.fromSwatch(
            accentColor: Colors.amber, primarySwatch: Colors.purple),
        appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        //accentColor: Colors.amber,
      ),
      home: const MyHomePage(title: 'Personal Expenses'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    Transaction(
        id: 't1', amount: 100.99, title: 'New Shoes', date: DateTime.now()),
    Transaction(
        id: 't2',
        amount: 66.99,
        title: 'New Shirt',
        date: DateTime.now().subtract(const Duration(days: 1))),
    Transaction(
        id: 't3',
        amount: 125.99,
        title: 'New Bag',
        date: DateTime.now().subtract(const Duration(days: 2))),
    Transaction(
        id: 't4',
        amount: 56.99,
        title: 'Grocery',
        date: DateTime.now().subtract(const Duration(days: 1))),
    Transaction(
        id: 't5',
        amount: 12.56,
        title: 'Transport',
        date: DateTime.now().subtract(const Duration(days: 3))),
    Transaction(
        id: 't6',
        amount: 577.45,
        title: 'Overseas travel',
        date: DateTime.now()),
    Transaction(
        id: 't7', amount: 60.5, title: 'Entertainment', date: DateTime.now()),
    Transaction(id: 't8', amount: 15.50, title: 'Lunch', date: DateTime.now()),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date!.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
      Navigator.of(context).pop();
    });
  }

  void startNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final _appBar = AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(
        widget.title,
      ),
      actions: [
        IconButton(
            onPressed: () {
              startNewTransaction(context);
            },
            icon: const Icon(Icons.add))
      ],
    );
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: _appBar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Chart'),
                  Switch.adaptive(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              _appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7, // substracting the heigh of th appbar and status bar i.e. top padding
                      child: Chart(_recentTransactions))
                  : Container(
                      height: (MediaQuery.of(context).size.height -
                              _appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: TransactionList(
                          _userTransactions, _deleteTransaction)),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3, // substracting the heigh of th appbar and status bar i.e. top padding
                  child: Chart(_recentTransactions)),
            if (!isLandscape)
              Container(
                  height: (MediaQuery.of(context).size.height -
                          _appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.7,
                  child:
                      TransactionList(_userTransactions, _deleteTransaction)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                startNewTransaction(context);
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
