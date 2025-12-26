import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/meal_order.dart';
import '../repositories/meal_order_repository.dart';

class AddMealOrder implements UseCase<void, AddMealOrderParams> {
  final MealOrderRepository repository;

  AddMealOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(AddMealOrderParams params) async {
    return await repository.addMealOrder(params.order);
  }
}

class AddMealOrderParams extends Equatable {
  final MealOrder order;

  const AddMealOrderParams({required this.order});

  @override
  List<Object> get props => [order];
}
