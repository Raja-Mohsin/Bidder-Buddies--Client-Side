class OrderMessage {
  String id;
  String orderId;
  String senderId;
  String recieverId;
  String content;
  String timestamp;

  OrderMessage(
    this.id,
    this.orderId,
    this.senderId,
    this.recieverId,
    this.content,
    this.timestamp,
  );
}
