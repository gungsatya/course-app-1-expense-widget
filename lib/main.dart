import 'package:flutter/material.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/add_transaction.dart';
import 'package:personal_expenses_app/widgets/charts.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

void main() {
  runApp(const PersonalExpenseApp());
}

class PersonalExpenseApp extends StatelessWidget {
  const PersonalExpenseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: const ColorScheme.light(
            primary: Colors.green, secondary: Colors.amber, error: Colors.red),
        fontFamily: 'QuickSand',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20),
        ),
      ),
      home: const PersonalExpenseHomePage(),
    );
  }
}

class PersonalExpenseHomePage extends StatefulWidget {
  final String title = 'Personal Expense';

  const PersonalExpenseHomePage({Key? key}) : super(key: key);

  @override
  _PersonalExpenseHomePageState createState() =>
      _PersonalExpenseHomePageState();
}

class _PersonalExpenseHomePageState extends State<PersonalExpenseHomePage> {
  final List<TransactionDto> _transactions = [];

  List<TransactionDto> get _recentTransactions {
    return _transactions
        .where(
          (tx) => tx.date.isAfter(
            DateTime.now().subtract(
              const Duration(
                days: 7,
              ),
            ),
          ),
        )
        .toList();
  }

  void _addTransactionHandler(String title, double amount, DateTime txDate) {
    setState(() {
      _transactions.add(TransactionDto(
          id: DateTime.now().microsecond,
          title: title,
          amount: amount,
          date: txDate));
    });
  }

  void _removeTransactionHandler(int id) {
    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddTransactionHandler(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AddTransaction(addTransactionCallback: _addTransactionHandler);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => _startAddTransactionHandler(context),
            icon: const Icon(
              Icons.add,
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Chart(recentTransactions: _recentTransactions),
              TransactionList(
                transactions: _transactions,
                removeTransactionCallback: _removeTransactionHandler,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddTransactionHandler(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
