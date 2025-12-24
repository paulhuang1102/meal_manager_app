import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/person.dart';
import '../../domain/repositories/person_repository.dart';
import '../datasources/person_local_data_source.dart';
import '../models/person_model.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonLocalDataSource localDataSource;

  PersonRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Person>>> getPersons() async {
    try {
      final persons = await localDataSource.getPersons();
      return Right(persons);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addPerson(Person person) async {
    try {
      final personModel = PersonModel.fromEntity(person);
      await localDataSource.addPerson(personModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePerson(Person person) async {
    try {
      final personModel = PersonModel.fromEntity(person);
      await localDataSource.updatePerson(personModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deletePerson(String id) async {
    try {
      await localDataSource.deletePerson(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Person>>> searchPersons({
    String? name,
    int? minAge,
    int? maxAge,
    int? birthMonth,
  }) async {
    try {
      final persons = await localDataSource.searchPersons(
        name: name,
        minAge: minAge,
        maxAge: maxAge,
        birthMonth: birthMonth,
      );
      return Right(persons);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('An unexpected error occurred: $e'));
    }
  }
}
