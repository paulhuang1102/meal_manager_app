import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/meal_order.dart';
import '../entities/meal_statistics.dart';

abstract class MealOrderRepository {
  Future<Either<Failure, List<MealOrder>>> getMealOrders();
  Future<Either<Failure, void>> addMealOrder(MealOrder order);
  Future<Either<Failure, void>> deleteMealOrder(String id);
  Future<Either<Failure, void>> deleteMealOrdersByPersonId(String personId);
  Future<Either<Failure, MealStatistics>> getStatistics();
}
