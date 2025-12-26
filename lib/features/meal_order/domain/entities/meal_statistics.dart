import 'package:equatable/equatable.dart';

class MealStatistics extends Equatable {
  final int breakfastCount;
  final int lunchCount;
  final int dinnerCount;
  final int totalCount;

  const MealStatistics({
    required this.breakfastCount,
    required this.lunchCount,
    required this.dinnerCount,
    required this.totalCount,
  });

  @override
  List<Object> get props => [breakfastCount, lunchCount, dinnerCount, totalCount];
}
