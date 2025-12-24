import 'dart:convert';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../domain/entities/person.dart';

class PersonModel extends Person {
  const PersonModel({
    required super.id,
    required super.name,
    required super.birthday,
    required super.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthday': birthday.toFormattedString(),
      'age': age,
    };
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    final birthday = (json['birthday'] as String).toDateTime()!;
    return PersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      birthday: birthday,
      age: json['age'] as int,
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory PersonModel.fromJsonString(String jsonString) {
    return PersonModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  factory PersonModel.fromEntity(Person person) {
    return PersonModel(
      id: person.id,
      name: person.name,
      birthday: person.birthday,
      age: person.age,
    );
  }

  factory PersonModel.create({
    required String id,
    required String name,
    required DateTime birthday,
  }) {
    return PersonModel(
      id: id,
      name: name,
      birthday: birthday,
      age: birthday.age,
    );
  }
}
