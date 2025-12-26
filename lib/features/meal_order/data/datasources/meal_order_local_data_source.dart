import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/meal_order_model.dart';
import '../../domain/entities/meal_order.dart';
import '../../domain/entities/meal_statistics.dart';

abstract class MealOrderLocalDataSource {
  Future<List<MealOrderModel>> getMealOrders();
  Future<void> addMealOrder(MealOrderModel order);
  Future<void> deleteMealOrder(String id);
  Future<MealStatistics> getStatistics();
}

class MealOrderLocalDataSourceImpl implements MealOrderLocalDataSource {
  final SharedPreferences sharedPreferences;

  MealOrderLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<MealOrderModel>> getMealOrders() async {
    try {
      final jsonString = sharedPreferences.getString(StorageKeys.mealOrders);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => MealOrderModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to get meal orders');
    }
  }

  @override
  Future<void> addMealOrder(MealOrderModel order) async {
    try {
      final orders = await getMealOrders();
      orders.add(order);
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      await sharedPreferences.setString(StorageKeys.mealOrders, jsonString);
    } catch (e) {
      throw CacheException('Failed to add meal order');
    }
  }

  @override
  Future<void> deleteMealOrder(String id) async {
    try {
      final orders = await getMealOrders();
      orders.removeWhere((order) => order.id == id);
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      await sharedPreferences.setString(StorageKeys.mealOrders, jsonString);
    } catch (e) {
      throw CacheException('Failed to delete meal order');
    }
  }

  @override
  Future<MealStatistics> getStatistics() async {
    try {
      final orders = await getMealOrders();

      int breakfastCount = 0;
      int lunchCount = 0;
      int dinnerCount = 0;

      for (var order in orders) {
        if (order.mealType == MealType.breakfast) {
          breakfastCount++;
        } else if (order.mealType == MealType.lunch) {
          lunchCount++;
        } else if (order.mealType == MealType.dinner) {
          dinnerCount++;
        }
      }

      return MealStatistics(
        breakfastCount: breakfastCount,
        lunchCount: lunchCount,
        dinnerCount: dinnerCount,
        totalCount: breakfastCount + lunchCount + dinnerCount,
      );
    } catch (e) {
      throw CacheException('Failed to get statistics');
    }
  }
}
