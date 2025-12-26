import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/meal_order_repository.dart';

class DeleteMealOrder implements UseCase<void, DeleteMealOrderParams> {
  final MealOrderRepository repository;

  DeleteMealOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMealOrderParams params) async {
    return await repository.deleteMealOrder(params.id);
  }
}

class DeleteMealOrderParams extends Equatable {
  final String id;

  const DeleteMealOrderParams({required this.id});

  @override
  List<Object> get props => [id];
}
