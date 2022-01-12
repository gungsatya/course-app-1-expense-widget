import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<TransactionDto> recentTransactions;

  bool isSameDay(DateTime dateTime, DateTime comparingDate) {
    return dateTime.day == comparingDate.day &&
        dateTime.month == comparingDate.month &&
        dateTime.year == comparingDate.year;
  }

  List<Map<String, Object>> get summarizeData {
    return List.generate(7, (index) {
      DateTime weekDay = DateTime.now().subtract(Duration(days: index));

      final double speedingAmount = recentTransactions
          .where((tx) => isSameDay(tx.date, weekDay))
          .toList()
          .fold(0.0, (summary, tx) => summary + tx.amount);

      return {'day': DateFormat.E().format(weekDay), 'amount': speedingAmount};
    });
  }

  double get totalSpending{
    return summarizeData.fold(0.0, (previousValue, data) => previousValue + (data['amount'] as double));
  }

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: summarizeData.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  weekDay: e['day'].toString(),
                  spendingAmount: (e['amount'] as double),
                  spendingPercent: totalSpending == 0.0 ? 0.0 : (e['amount'] as double) / totalSpending,
                ),
              );
            }).toList(),
        ),
      ),
    );
  }
}
