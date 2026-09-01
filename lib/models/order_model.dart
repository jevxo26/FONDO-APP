/// Order processing lifecycle states.
enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

/// Individual line item in an order.
class OrderItem {
  /// Name of the dish or package.
  final String foodName;

  /// Quantity of this item ordered.
  final int quantity;

  /// Unit price in Bangladeshi Taka.
  final double price;

  const OrderItem({
    required this.foodName,
    required this.quantity,
    required this.price,
  });
}

/// Comprehensive customer order model.
class OrderModel {
  /// Unique order identifier.
  final String id;

  /// Customer-facing display order number (e.g. #FND-84920).
  final String orderNumber;

  /// Itemized line items list.
  final List<OrderItem> items;

  /// Subtotal before delivery and taxes.
  final double subtotal;

  /// Applied delivery fee.
  final double deliveryFee;

  /// Voucher or promotional discount.
  final double discount;

  /// Final billed total amount.
  final double total;

  /// Current order status.
  final OrderStatus status;

  /// Timestamp when order was placed.
  final DateTime orderedAt;

  /// Timestamp when delivery completed.
  final DateTime? deliveredAt;

  /// Destination street & delivery instructions.
  final String deliveryAddress;

  /// Selected payment method.
  final String paymentMethod;

  /// Customer recipient name.
  final String? customerName;

  /// Special instructions for restaurant and rider.
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
