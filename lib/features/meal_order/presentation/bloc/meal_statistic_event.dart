part of 'meal_statistic_bloc.dart';

sealed class MealStatisticEvent extends Equatable {
  const MealStatisticEvent();

  @override
  List<Object> get props => [];
}

final class MealStatisticLoadEvent extends MealStatisticEvent {}
