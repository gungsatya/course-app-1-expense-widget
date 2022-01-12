import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransaction extends StatefulWidget {
  final Function addTransactionCallback;

  const AddTransaction({Key? key, required this.addTransactionCallback})
      : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateTextController = TextEditingController();
  DateTime? _selectedDate;

  void _startDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
        _dateTextController.text = DateFormat.yMd().format(value);
        _addTransactionOnSubmit();
      });
    });
  }

  void _addTransactionOnSubmit() {
    String inputTitle = _titleController.text;
    double inputAmount = double.parse(
        _amountController.text.isEmpty ? '0' : _amountController.text);

    if (inputAmount <= 0 || inputTitle.isEmpty || _selectedDate == null) return;

    widget.addTransactionCallback(inputTitle, inputAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: _titleController,
              onSubmitted: (_) => _addTransactionOnSubmit(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _addTransactionOnSubmit(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
              controller: _dateTextController,
              readOnly: true,
              onTap: _startDatePicker,
            ),
            OutlinedButton(
              onPressed: () => _addTransactionOnSubmit,
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
