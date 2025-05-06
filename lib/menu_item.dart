class MenuItem {
  final String name;
  final int price;
  final String image;
  int quantity;
  MenuItem({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 0,
  });
}
