enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

class OrderItem {
  final String foodName;
  final int quantity;
  final double price;

  const OrderItem({
    required this.foodName,
    required this.quantity,
    required this.price,
  });
}

class OrderModel {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final DateTime orderedAt;
  final DateTime? deliveredAt;
  final String deliveryAddress;
  final String paymentMethod;
  final String? customerName;
  final String? note;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.orderedAt,
    this.deliveredAt,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.customerName,
    this.note,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get itemCount {
    int sum = 0;
    for (final item in items) {
      sum += item.quantity;
    }
    return sum;
  }
}
