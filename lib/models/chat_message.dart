class ChatMessage {
  String id;
  String senderId;
  String auctionId;
  String senderName;
  String imageUrl;
  String content;
  String timestamp;

  ChatMessage(
    this.id,
    this.senderId,
    this.auctionId,
    this.senderName,
    this.imageUrl,
    this.content,
    this.timestamp,
  );
}
