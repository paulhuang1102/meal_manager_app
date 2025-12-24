import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/person_repository.dart';

class DeletePerson implements UseCase<void, DeletePersonParams> {
  final PersonRepository repository;

  DeletePerson(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePersonParams params) async {
    return await repository.deletePerson(params.id);
  }
}

class DeletePersonParams extends Equatable {
  final String id;

  const DeletePersonParams(this.id);

  @override
  List<Object> get props => [id];
}
