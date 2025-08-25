import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/providers/theme_provider.dart';
import 'package:sweet_pal/features/orders/cubit/cart_cubit.dart';
import 'package:sweet_pal/features/orders/cubit/cart_state.dart';
import 'package:sweet_pal/features/orders/cubit/order_cubit.dart';
import 'package:sweet_pal/features/payment/views/widgets/payment_page.dart';

import 'package:flutter/cupertino.dart';

class OrderViewBody extends StatelessWidget {
  const OrderViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: Provider.of<ThemeProvider>(context, listen: false).textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Provider.of<ThemeProvider>(context).textColor,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    CupertinoIcons.cart_badge_minus,
                    size: 100,
                    color: Provider.of<ThemeProvider>(context).textColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Provider.of<ThemeProvider>(context).secondaryTextColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Image.network(
                              item.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Provider.of<ThemeProvider>(context).textColor,
                                    ),
                                  ),
                                  Text(
                                    '\$${item.price}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(
                                      item.productId,
                                      item.quantity - 1,
                                    );
                                  },
                                ),
                                Text(
                                  item.quantity.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Provider.of<ThemeProvider>(context).textColor,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    context.read<CartCubit>().updateQuantity(
                                      item.productId,
                                      item.quantity + 1,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    context.read<CartCubit>().removeItem(
                                      item.productId,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Provider.of<ThemeProvider>(context).textColor,
                          ),
                        ),
                        Text(
                          '\$${state.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final cartState = context.read<CartCubit>().state;
                          try {
                            final orderCubit = context.read<OrderCubit>();
                            final orderId = await orderCubit.createOrder(
                              items: cartState.items
                                  .map(
                                    (item) => {
                                      'product_id': item.productId,
                                      'product_name': item.productName,
                                      'image_url': item.imageUrl,
                                      'quantity': item.quantity,
                                      'price': item.price,
                                    },
                                  )
                                  .toList(),
                              totalPrice: cartState.totalAmount,
                            );

                            context.read<CartCubit>().clearCart();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  orderId: orderId,
                                  totalAmount: cartState.totalAmount,
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error creating order: $e'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Proceed to Checkout',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
