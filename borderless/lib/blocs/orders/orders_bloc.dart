import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';
import '../../models/product.dart';
import 'orders_event.dart';
import 'orders_state.dart';
import 'package:flutter/material.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc() : super(OrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(OrdersLoading());
      // TODO: Implement actual orders loading logic
      // For now, we'll use mock data
      await Future.delayed(const Duration(seconds: 1));
      final mockOrders = [
        // Ongoing Orders
        Order(
          id: '1',
          userId: 'user1',
          items: [
            OrderItem(
              product: Product(
                id: '1',
                name: 'Wireless Headphones',
                description:
                    'High-quality wireless headphones with noise cancellation',
                price: 199.99,
                imageUrl: 'assets/images/headphones1.png',
                category: 'Electronics',
                colors: [Colors.black, Colors.white],
                sizes: ['One Size'],
                rating: 4.5,
                reviews: 128,
                discountPercentage: 15,
              ),
              quantity: 1,
              price: 199.99,
            ),
            OrderItem(
              product: Product(
                id: '2',
                name: 'Smart Watch',
                description:
                    'Fitness tracking smartwatch with heart rate monitoring',
                price: 299.99,
                imageUrl: 'assets/images/smartwatch.png',
                category: 'Electronics',
                colors: [Colors.black, Colors.grey],
                sizes: ['One Size'],
                rating: 4.8,
                reviews: 256,
                discountPercentage: 20,
              ),
              quantity: 1,
              price: 299.99,
            ),
          ],
          total: 499.98,
          status: 'processing',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          shippingAddress: '123 Main St',
          paymentMethod: 'Credit Card',
        ),
        // Completed Orders
        Order(
          id: '3',
          userId: 'user1',
          items: [
            OrderItem(
              product: Product(
                id: '4',
                name: 'Running Shoes',
                description: 'Comfortable running shoes with cushioning',
                price: 129.99,
                imageUrl: 'assets/images/nike_shoes.png',
                category: 'Sports',
                colors: [Colors.blue, Colors.black],
                sizes: ['40', '41', '42', '43'],
                rating: 4.6,
                reviews: 167,
                discountPercentage: 0,
              ),
              quantity: 1,
              price: 129.99,
            ),
            OrderItem(
              product: Product(
                id: '5',
                name: 'Sports Watch',
                description: 'Water-resistant sports watch with GPS',
                price: 249.99,
                imageUrl: 'assets/images/watch1.png',
                category: 'Sports',
                colors: [Colors.black, Colors.blue],
                sizes: ['One Size'],
                rating: 4.4,
                reviews: 92,
                discountPercentage: 5,
              ),
              quantity: 1,
              price: 249.99,
            ),
          ],
          total: 459.97,
          status: 'delivered',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          shippingAddress: '789 Pine St',
          paymentMethod: 'Credit Card',
        ),
        Order(
          id: '4',
          userId: 'user1',
          items: [
            OrderItem(
              product: Product(
                id: '6',
                name: 'Laptop Backpack',
                description:
                    'Spacious laptop backpack with multiple compartments',
                price: 79.99,
                imageUrl: 'assets/images/backpack.png',
                category: 'Accessories',
                colors: [Colors.black, Colors.grey],
                sizes: ['One Size'],
                rating: 4.3,
                reviews: 145,
                discountPercentage: 0,
              ),
              quantity: 1,
              price: 79.99,
            ),
          ],
          total: 79.99,
          status: 'delivered',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          shippingAddress: '321 Elm St',
          paymentMethod: 'PayPal',
        ),
      ];
      emit(OrdersLoaded(mockOrders));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(OrdersLoading());
      // TODO: Implement actual order creation logic
      await Future.delayed(const Duration(seconds: 1));
      final newOrder = Order(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: event.userId,
        items: event.items,
        total: event.total,
        status: 'processing',
        createdAt: DateTime.now(),
        shippingAddress: event.shippingAddress,
        paymentMethod: event.paymentMethod,
      );

      // Add the new order to the ongoing orders list
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders = [...currentState.orders, newOrder];
        emit(OrdersLoaded(updatedOrders));
      } else {
        emit(OrdersLoaded([newOrder]));
      }

      emit(OrderCreated(newOrder));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        emit(OrdersLoading());
        // TODO: Implement actual order status update logic
        await Future.delayed(const Duration(seconds: 1));
        final updatedOrders = currentState.orders.map((order) {
          if (order.id == event.orderId) {
            return order.copyWith(status: event.status);
          }
          return order;
        }).toList();
        emit(OrdersLoaded(updatedOrders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is OrdersLoaded) {
        emit(OrdersLoading());
        // TODO: Implement actual order cancellation logic
        await Future.delayed(const Duration(seconds: 1));
        final updatedOrders = currentState.orders
            .where((order) => order.id != event.orderId)
            .toList();
        emit(OrdersLoaded(updatedOrders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}
