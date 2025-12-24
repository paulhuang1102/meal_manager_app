import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person.dart';
import '../repositories/person_repository.dart';

class SearchPersons implements UseCase<List<Person>, SearchPersonsParams> {
  final PersonRepository repository;

  SearchPersons(this.repository);

  @override
  Future<Either<Failure, List<Person>>> call(SearchPersonsParams params) async {
    return await repository.searchPersons(
      name: params.name,
      minAge: params.minAge,
      maxAge: params.maxAge,
      birthMonth: params.birthMonth,
    );
  }
}

class SearchPersonsParams extends Equatable {
  final String? name;
  final int? minAge;
  final int? maxAge;
  final int? birthMonth;

  const SearchPersonsParams({
    this.name,
    this.minAge,
    this.maxAge,
    this.birthMonth,
  });

  @override
  List<Object?> get props => [name, minAge, maxAge, birthMonth];
}
