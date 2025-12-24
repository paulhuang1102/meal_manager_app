import 'package:equatable/equatable.dart';

class Person extends Equatable {
  final String id;
  final String name;
  final DateTime birthday;
  final int age;

  const Person({
    required this.id,
    required this.name,
    required this.birthday,
    required this.age,
  });

  @override
  List<Object> get props => [id, name, birthday, age];
}
