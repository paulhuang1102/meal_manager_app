part of 'meal_order_bloc.dart';

sealed class MealOrderState extends Equatable {
  const MealOrderState();

  @override
  List<Object> get props => [];
}

final class MealOrderInitial extends MealOrderState {}

final class MealOrderLoading extends MealOrderState {}

final class MealOrderLoaded extends MealOrderState {
  final List<MealOrder> orders;

  const MealOrderLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class MealOrderError extends MealOrderState {
  final String message;

  const MealOrderError(this.message);

  @override
  List<Object> get props => [message];
}
