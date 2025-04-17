import 'dart:convert';

class Account {
  String? id;
  int userId;
  String username;
  String password;
  String status;
  String lastLogin;
  String createdAt;

  Account({
    this.id,
    required this.userId,
    required this.username,
    required this.password,
    required this.status,
    required this.lastLogin,
    required this.createdAt,
  });

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['_id']?.toString(),
      userId: map['userId'] is int ? map['userId'] : int.tryParse(map['userId'].toString()) ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
      status: map['status'] ?? 'inactive',
      lastLogin: map['lastLogin'] ?? DateTime.now().toIso8601String(),
      createdAt: map['createdAt'] ?? DateTime.now().toIso8601String(),
    );
  }

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));

  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'userId': userId,
      'username': username,
      'password': password,
      'status': status,
      'lastLogin': lastLogin,
      'createdAt': createdAt,
    };
  }

  String toJson() => json.encode(toMap());

  Account copyWith({
    String? id,
    int? userId,
    String? username,
    String? password,
    String? status,
    String? lastLogin,
    String? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, userId: $userId, username: $username, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Account &&
        other.id == id &&
        other.username == username;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode;
}