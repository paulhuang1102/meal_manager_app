part of 'meal_order_bloc.dart';

sealed class MealOrderEvent extends Equatable {
  const MealOrderEvent();

  @override
  List<Object> get props => [];
}

final class MealOrderLoadEvent extends MealOrderEvent {}

final class MealOrderToggleEvent extends MealOrderEvent {
  final String personId;
  final String personName;
  final MealType mealType;

  const MealOrderToggleEvent({
    required this.personId,
    required this.personName,
    required this.mealType,
  });

  @override
  List<Object> get props => [personId, personName, mealType];
}
