import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_item.dart';
import '../../models/product.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  static const String _cartKey = 'cart_items';
  static const String _savedItemsKey = 'saved_items';

  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<SaveForLater>(_onSaveForLater);
    on<MoveToCart>(_onMoveToCart);
    on<RemoveSavedItem>(_onRemoveSavedItem);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);

    // Load cart state when bloc is created
    add(LoadCart());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cartJson = prefs.getString(_cartKey);
      final savedItemsJson = prefs.getString(_savedItemsKey);

      final cartItems = cartJson != null
          ? (jsonDecode(cartJson) as List)
              .map((item) => CartItem.fromJson(item))
              .toList()
          : <CartItem>[];

      final savedItems = savedItemsJson != null
          ? (jsonDecode(savedItemsJson) as List)
              .map((item) => CartItem.fromJson(item))
              .toList()
          : <CartItem>[];

      emit(CartState(
        items: cartItems,
        savedItems: savedItems,
      ));
    } catch (e) {
      // Handle error
      print('Error loading cart: $e');
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final currentState = state;
      final updatedItems = List<CartItem>.from(currentState.items);

      final existingIndex = updatedItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (existingIndex >= 0) {
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: updatedItems[existingIndex].quantity + 1,
        );
      } else {
        updatedItems.add(CartItem(
          product: event.product,
          quantity: 1,
        ));
      }

      final updatedState = currentState.copyWith(items: updatedItems);
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cartKey,
        jsonEncode(updatedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      final updatedItems = currentState.items
          .where((item) => item.product.id != event.productId)
          .toList();

      final updatedState = currentState.copyWith(items: updatedItems);
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cartKey,
        jsonEncode(updatedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      final updatedItems = currentState.items.map((item) {
        if (item.product.id == event.productId) {
          return item.copyWith(quantity: event.quantity);
        }
        return item;
      }).toList();

      final updatedState = currentState.copyWith(items: updatedItems);
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cartKey,
        jsonEncode(updatedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<void> _onSaveForLater(
    SaveForLater event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      final cartItem = currentState.items
          .firstWhere((item) => item.product.id == event.productId);

      final updatedCartItems = currentState.items
          .where((item) => item.product.id != event.productId)
          .toList();

      final updatedSavedItems = [...currentState.savedItems, cartItem];

      final updatedState = currentState.copyWith(
        items: updatedCartItems,
        savedItems: updatedSavedItems,
      );
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cartKey,
        jsonEncode(updatedCartItems.map((item) => item.toJson()).toList()),
      );
      await prefs.setString(
        _savedItemsKey,
        jsonEncode(updatedSavedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error saving for later: $e');
    }
  }

  Future<void> _onMoveToCart(
    MoveToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      final savedItem = currentState.savedItems
          .firstWhere((item) => item.product.id == event.productId);

      final updatedSavedItems = currentState.savedItems
          .where((item) => item.product.id != event.productId)
          .toList();

      final updatedCartItems = [...currentState.items, savedItem];

      final updatedState = currentState.copyWith(
        items: updatedCartItems,
        savedItems: updatedSavedItems,
      );
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _cartKey,
        jsonEncode(updatedCartItems.map((item) => item.toJson()).toList()),
      );
      await prefs.setString(
        _savedItemsKey,
        jsonEncode(updatedSavedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error moving to cart: $e');
    }
  }

  Future<void> _onRemoveSavedItem(
    RemoveSavedItem event,
    Emitter<CartState> emit,
  ) async {
    try {
      final currentState = state;
      final updatedSavedItems = currentState.savedItems
          .where((item) => item.product.id != event.productId)
          .toList();

      final updatedState = currentState.copyWith(savedItems: updatedSavedItems);
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _savedItemsKey,
        jsonEncode(updatedSavedItems.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print('Error removing saved item: $e');
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      final updatedState = state.copyWith(items: []);
      emit(updatedState);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cartKey, '[]');
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }
}
