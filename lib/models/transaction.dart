class Transaction {
  String id;
  String senderId;
  String receiverId;
  DateTime date;
  double amount;
  double tax;

  Transaction(
      {required this.id,
      required this.senderId,
      required this.receiverId,
      required this.date,
      required this.amount,
      required this.tax});

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        id: map["id"] as String,
        senderId: map["senderId"] as String,
        receiverId: map["receiverId"] as String,
        date: DateTime.parse(map['date'] as String),
        amount: map["amount"] as double,
        tax: map["tax"] as double);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "date": date.toIso8601String(),
      "amount": amount,
      "tax": tax
    };
  }

  Transaction copyWith(
      {String? id,
      String? senderId,
      String? receiverId,
      DateTime? date,
      double? amount,
      double? tax}) {
    return Transaction(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        tax: tax ?? this.tax);
  }

  Map<String, dynamic> toJson() => toMap();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      Transaction.fromMap(json);

  @override
  String toString() {
    return '\\Transação $id\\nFrom $senderId to $receiverId\\nValor: $amount\\nData: $date\tTaxa: $tax\\n';
  }

  @override
  bool operator ==(covariant Transaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.amount == amount &&
        other.date == date &&
        other.tax == tax;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        receiverId.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        tax.hashCode;
  }
}
