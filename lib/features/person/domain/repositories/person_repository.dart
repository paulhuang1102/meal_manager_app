import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/person.dart';

abstract class PersonRepository {
  Future<Either<Failure, List<Person>>> getPersons();

  Future<Either<Failure, void>> addPerson(Person person);

  Future<Either<Failure, void>> updatePerson(Person person);

  Future<Either<Failure, void>> deletePerson(String id);

  Future<Either<Failure, List<Person>>> searchPersons({
    String? name,
    int? minAge,
    int? maxAge,
    int? birthMonth,
  });
}