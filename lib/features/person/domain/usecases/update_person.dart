import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/person.dart';
import '../repositories/person_repository.dart';

class UpdatePerson implements UseCase<void, UpdatePersonParams> {
  final PersonRepository repository;

  UpdatePerson(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdatePersonParams params) async {
    return await repository.updatePerson(params.person);
  }
}

class UpdatePersonParams extends Equatable {
  final Person person;

  const UpdatePersonParams(this.person);

  @override
  List<Object> get props => [person];
}
