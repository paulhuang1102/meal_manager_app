import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/meal_order.dart';
import '../repositories/meal_order_repository.dart';

class GetMealOrders implements UseCase<List<MealOrder>, NoParams> {
  final MealOrderRepository repository;

  GetMealOrders(this.repository);

  @override
  Future<Either<Failure, List<MealOrder>>> call(NoParams params) async {
    return await repository.getMealOrders();
  }
}
