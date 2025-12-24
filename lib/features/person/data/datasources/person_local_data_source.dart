import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getPersons();

  Future<void> addPerson(PersonModel person);

  Future<void> updatePerson(PersonModel person);

  Future<void> deletePerson(String id);

  Future<List<PersonModel>> searchPersons({
    String? name,
    int? minAge,
    int? maxAge,
    int? birthMonth,
  });
}

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PersonLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PersonModel>> getPersons() async {
    try {
      final jsonString = sharedPreferences.getString(StorageKeys.personsList);
      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => PersonModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheException('Failed to get persons: $e');
    }
  }

  @override
  Future<void> addPerson(PersonModel person) async {
    try {
      final persons = await getPersons();
      persons.add(person);
      await _savePersons(persons);
    } catch (e) {
      throw CacheException('Failed to add person: $e');
    }
  }

  @override
  Future<void> updatePerson(PersonModel person) async {
    try {
      final persons = await getPersons();
      final index = persons.indexWhere((p) => p.id == person.id);
      if (index == -1) {
        throw CacheException('Person not found');
      }
      persons[index] = person;
      await _savePersons(persons);
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to update person: $e');
    }
  }

  @override
  Future<void> deletePerson(String id) async {
    try {
      final persons = await getPersons();
      persons.removeWhere((p) => p.id == id);
      await _savePersons(persons);
    } catch (e) {
      throw CacheException('Failed to delete person: $e');
    }
  }

  @override
  Future<List<PersonModel>> searchPersons({
    String? name,
    int? minAge,
    int? maxAge,
    int? birthMonth,
  }) async {
    try {
      final persons = await getPersons();

      return persons.where((person) {
        // Filter by name
        if (name != null && name.isNotEmpty) {
          if (!person.name.toLowerCase().contains(name.toLowerCase())) {
            return false;
          }
        }

        // Filter by minimum age
        if (minAge != null && person.age < minAge) {
          return false;
        }

        // Filter by maximum age
        if (maxAge != null && person.age > maxAge) {
          return false;
        }

        // Filter by birth month
        if (birthMonth != null && person.birthday.month != birthMonth) {
          return false;
        }

        return true;
      }).toList();
    } catch (e) {
      throw CacheException('Failed to search persons: $e');
    }
  }

  Future<void> _savePersons(List<PersonModel> persons) async {
    final jsonList = persons.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await sharedPreferences.setString(StorageKeys.personsList, jsonString);
  }
}
