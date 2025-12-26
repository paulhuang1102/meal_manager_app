import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/person_repository.dart';
import '../../../meal_order/domain/repositories/meal_order_repository.dart';

class DeletePerson implements UseCase<void, DeletePersonParams> {
  final PersonRepository personRepository;
  final MealOrderRepository mealOrderRepository;

  DeletePerson({
    required this.personRepository,
    required this.mealOrderRepository,
  });

  @override
  Future<Either<Failure, void>> call(DeletePersonParams params) async {
    final deleteMealOrdersResult =
        await mealOrderRepository.deleteMealOrdersByPersonId(params.id);

    if (deleteMealOrdersResult.isLeft()) {
      return deleteMealOrdersResult;
    }

    return await personRepository.deletePerson(params.id);
  }
}

class DeletePersonParams extends Equatable {
  final String id;

  const DeletePersonParams(this.id);

  @override
  List<Object> get props => [id];
}
