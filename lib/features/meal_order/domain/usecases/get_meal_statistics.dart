import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/meal_statistics.dart';
import '../repositories/meal_order_repository.dart';

class GetStatistics implements UseCase<MealStatistics, NoParams> {
  final MealOrderRepository repository;

  GetStatistics(this.repository);

  @override
  Future<Either<Failure, MealStatistics>> call(NoParams params) async {
    return await repository.getStatistics();
  }
}
