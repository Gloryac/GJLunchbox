class IngredientItem {
 String name;
//  int quantity;

  IngredientItem({
    required this.name,
    //required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
     // 'quantity': quantity,
    };
  }

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      name: json['name'] as String,
      //quantity: json['quantity'] as int,
    );
  }
}