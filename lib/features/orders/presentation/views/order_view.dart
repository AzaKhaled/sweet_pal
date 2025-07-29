import 'package:flutter/material.dart';
import 'package:sweet_pal/features/orders/presentation/views/widgets/order_view_body.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrderViewBody());
  }
}
