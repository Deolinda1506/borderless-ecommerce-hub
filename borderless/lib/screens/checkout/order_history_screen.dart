import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/orders/orders_bloc.dart';
import '../../blocs/orders/orders_event.dart';
import '../../blocs/orders/orders_state.dart';
import '../../models/order.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<OrdersBloc>().add(LoadOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState({bool isOngoing = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        Image.asset(
          'assets/images/empty_orders.png',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 24),
        Text(
          isOngoing ? 'No ongoing order' : 'No completed order',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            isOngoing
                ? 'We currently don\'t have any active orders in progress. Feel free to explore our products and place a new order.'
                : 'We don\'t have any past orders that have been completed. Start shopping now and create your first order with us.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/categories');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Explore Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(Order order, bool isOngoing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOngoing)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8E8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 14,
                    color: Color(0xFFFF4B4B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Estimated time: 7 working days',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF4B4B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  order.items.isNotEmpty
                      ? order.items[0].product.imageUrl
                      : 'assets/images/placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items.isNotEmpty
                          ? order.items[0].product.name
                          : 'Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF21D4B4),
                      ),
                    ),
                    if (!isOngoing) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F3FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Finished',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF2E7DFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Order History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _tabController.animateTo(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Ongoing',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _tabController.index == 0
                              ? Colors.white
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _tabController.animateTo(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tabController.index == 1
                            ? Colors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        'Completed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _tabController.index == 1
                              ? Colors.white
                              : Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is OrdersError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (state is OrdersLoaded) {
                  final ongoingOrders = state.orders
                      .where((order) => order.status != 'delivered')
                      .toList();
                  final completedOrders = state.orders
                      .where((order) => order.status == 'delivered')
                      .toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      ongoingOrders.isEmpty
                          ? _buildEmptyState(isOngoing: true)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: ongoingOrders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderItem(
                                    ongoingOrders[index], true);
                              },
                            ),
                      completedOrders.isEmpty
                          ? _buildEmptyState(isOngoing: false)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: completedOrders.length,
                              itemBuilder: (context, index) {
                                return _buildOrderItem(
                                    completedOrders[index], false);
                              },
                            ),
                    ],
                  );
                }

                return const Center(child: Text('No orders found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
