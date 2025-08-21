import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/features/orders/cubit/order_cubit.dart';
import 'package:sweet_pal/features/orders/presentation/views/order_history_view.dart';

class PaymentPage extends StatefulWidget {
  final String orderId;
  final double totalAmount;

  const PaymentPage({
    Key? key,
    required this.orderId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrderHistoryView()),
            );
          },
          child: const Row(
            children: [
              SizedBox(width: 8),
              Icon(Icons.arrow_back_ios, size: 20),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            const Column(
              children: [
                Icon(
                  Icons.payment,
                  size: 60,
                  color: AppColors.lightPrimaryColor,
                ),
                SizedBox(height: 10),
                Text(
                  'Secure Payment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Complete your order safely',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Order Summary
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Order ID:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(widget.orderId.substring(0, 8)),
                      ],
                    ),
                    const Divider(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '\$${widget.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // PayPal Button
            _isProcessing
                ? const CircularProgressIndicator(color: AppColors.primaryColor)
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    icon: const Icon(Icons.account_balance_wallet, size: 22),
                    onPressed: _processPayment,
                    label: const Text(
                      'Pay with PayPal',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

            const SizedBox(height: 20),
            const Text(
              'Your payment is secure and encrypted.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId: 'YOUR_CLIENT_ID',
          secretKey: 'YOUR_SECRET_KEY',
          returnURL: 'https://sweetpal.com/payment/success',
          cancelURL: 'https://sweetpal.com/payment/cancel',
          transactions: [
            {
              'amount': {
                'total': widget.totalAmount.toStringAsFixed(2),
                'currency': 'USD',
                'details': {
                  'subtotal': widget.totalAmount.toStringAsFixed(2),
                  'shipping': '0',
                  'shipping_discount': 0,
                },
              },
              'description': 'Sweet Pal Order Payment',
              'item_list': {
                'items': [
                  {
                    'name': 'Order ${widget.orderId}',
                    'quantity': 1,
                    'price': widget.totalAmount.toStringAsFixed(2),
                    'currency': 'USD',
                  },
                ],
              },
            },
          ],
          note: 'Payment for order ${widget.orderId}',
          onSuccess: (Map params) async {
            await _handlePaymentSuccess();
          },
          onError: (error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
          },
          onCancel: (params) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Payment cancelled')));
          },
        ),
      ),
    );
  }

  Future<void> _handlePaymentSuccess() async {
    setState(() => _isProcessing = true);
    try {
      final orderCubit = context.read<OrderCubit>();
      await orderCubit.updateOrderStatus(widget.orderId, 'completed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful! Order completed.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/order-history');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }
}
