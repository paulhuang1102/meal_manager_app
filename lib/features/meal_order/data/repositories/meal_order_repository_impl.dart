import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/meal_order.dart';
import '../../domain/entities/meal_statistics.dart';
import '../../domain/repositories/meal_order_repository.dart';
import '../datasources/meal_order_local_data_source.dart';
import '../models/meal_order_model.dart';

class MealOrderRepositoryImpl implements MealOrderRepository {
  final MealOrderLocalDataSource localDataSource;

  MealOrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<MealOrder>>> getMealOrders() async {
    try {
      final orders = await localDataSource.getMealOrders();
      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addMealOrder(MealOrder order) async {
    try {
      final orderModel = MealOrderModel.fromEntity(order);
      await localDataSource.addMealOrder(orderModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealOrder(String id) async {
    try {
      await localDataSource.deleteMealOrder(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealOrdersByPersonId(String personId) async {
    try {
      await localDataSource.deleteMealOrdersByPersonId(personId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MealStatistics>> getStatistics() async {
    try {
      final statistics = await localDataSource.getStatistics();
      return Right(statistics);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
