class Order {
  String id;
  String auctionId;
  String buyerId;
  String sellerId;
  String chatId;
  String title;
  String price;
  String imageUrl;
  String date;
  String time;
  String status;
  String reviewGiven;
  String paymentStatus;
  String deliveryDateTime;

  Order(
    this.id,
    this.auctionId,
    this.buyerId,
    this.sellerId,
    this.chatId,
    this.title,
    this.price,
    this.imageUrl,
    this.date,
    this.time,
    this.status,
    this.reviewGiven,
    this.paymentStatus,
    this.deliveryDateTime,
  );
}
