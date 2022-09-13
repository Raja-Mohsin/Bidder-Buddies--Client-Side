class Auction {
  String id;
  String name;
  String description;
  List<String> imageUrls;
  String sellerId;
  List<String> bids;
  String date;
  String time;
  String category;
  String city;
  String minimumIncrement;
  String terminationDate;
  String startingPrice;
  String maximumPrice;
  String status;
  String featured;

  Auction(
    this.id,
    this.name,
    this.description,
    this.imageUrls,
    this.bids,
    this.sellerId,
    this.date,
    this.time,
    this.category,
    this.city,
    this.minimumIncrement,
    this.terminationDate,
    this.startingPrice,
    this.maximumPrice,
    this.status,
    this.featured,
  );
}
