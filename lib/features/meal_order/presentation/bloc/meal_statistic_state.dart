part of 'meal_statistic_bloc.dart';

sealed class MealStatisticState extends Equatable {
  const MealStatisticState();

  @override
  List<Object> get props => [];
}

final class MealStatisticInitial extends MealStatisticState {}

final class MealStatisticLoading extends MealStatisticState {}

final class MealStatisticLoaded extends MealStatisticState {
  final MealStatistics statistics;

  const MealStatisticLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}

final class MealStatisticError extends MealStatisticState {
  final String message;

  const MealStatisticError(this.message);

  @override
  List<Object> get props => [message];
}
