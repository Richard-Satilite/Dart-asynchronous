class Account {
  String id;
  String name;
  String lastName;
  double balance;

  Account(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.balance});

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        id: map['id'],
        name: map['name'],
        lastName: map['lastName'],
        balance: map['balance']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "lastName": lastName,
      "balance": balance
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? lastName,
    double? balance,
  }) {
    return Account(
        id: id ?? this.id,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        balance: balance ?? this.balance);
  }

  @override
  String toString() {
    return '\\nConta $id\\n$name $lastName\\nSaldo: $balance\\n';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lastName == lastName &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ lastName.hashCode ^ balance.hashCode;
  }
}
