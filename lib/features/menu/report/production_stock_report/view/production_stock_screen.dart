import 'package:flutter/material.dart';

import '../../../../../core/api/api_client.dart';
class ProductionStockScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final ApiClient apiClient;

  const ProductionStockScreen({
    super.key,
    required this.navigatorKey,
    required this.apiClient,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Stock Report'),
      ),
      body: Center(
        child:
        Text('Product Stock Report'),
      ),
    );
  }
}
