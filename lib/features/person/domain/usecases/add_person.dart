import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person.dart';
import '../repositories/person_repository.dart';

class AddPerson implements UseCase<void, AddPersonParams> {
  final PersonRepository repository;

  AddPerson(this.repository);

  @override
  Future<Either<Failure, void>> call(AddPersonParams params) async {
    return await repository.addPerson(params.person);
  }
}

class AddPersonParams extends Equatable {
  final Person person;

  const AddPersonParams(this.person);

  @override
  List<Object> get props => [person];
}
