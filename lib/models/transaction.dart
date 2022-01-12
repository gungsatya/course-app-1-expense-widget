class TransactionDto{
  int id;
  String title;
  double amount;
  DateTime date;

  TransactionDto({required this.id, required this.title, required this.amount, required this.date});
}