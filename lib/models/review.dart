class Review {
  String id;
  String orderId;
  String sellerId;
  String buyerId;
  String qualityRating;
  String recommendationRating;
  String satisfactionRating;
  String averageRating;
  String content;
  String date;
  String time;

  Review(
    this.id,
    this.orderId,
    this.sellerId,
    this.buyerId,
    this.qualityRating,
    this.recommendationRating,
    this.satisfactionRating,
    this.averageRating,
    this.content,
    this.date,
    this.time,
  );
}
