import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe.dart';


class RecipeService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Recipe>> getFeaturedRecipes(){
    return _firestore
        .collection('recipes')
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map((snapshot)=>
          snapshot.docs.map((doc)=>Recipe.fromFirestore(doc)).toList());
  }
  Stream<List<Recipe>> getRecipeByCategory(String category) {
    if (category == "All") {
      return _firestore
          .collection("recipes")
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
    } else {
      return _firestore
          .collection("recipes")
          .where('category', isEqualTo: category)
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
    }
  }

  Future<List<Recipe>> searchRecipes(String query) async {
    final snapshot = await _firestore
        .collection('recipes')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }
}