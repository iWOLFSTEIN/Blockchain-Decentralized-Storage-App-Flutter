class Node {
  Node(this.address, this.url);
  String address;
  String url;
}

class NodePingData {
  NodePingData(
      {required this.bidPrice,
      required this.canStore,
      required this.node,
      required this.responseTimeInMilliseconds});
  bool canStore;
  String bidPrice;
  int responseTimeInMilliseconds;
  Node node;
}
