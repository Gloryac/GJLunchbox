import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/recipe.dart';


class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Stream<List<Recipe>> getRecipeByCategory(String category) {
    try {
      print("Getting recipes for category: $category");
      if (category == "All") {
        return _firestore
            .collection("recipes")
            .snapshots()
            .map((snapshot) =>
            snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
      } else {
        return _firestore
            .collection("recipes")
            .where('Category', isEqualTo: category)
            .snapshots()
            .map((snapshot) =>
            snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
      }
    } catch (e) {
      print("Error in getRecipeByCategory :$e");
      return Stream.value([]);
    }
  }


  // Stream<List<Recipe>> searchRecipes(String query) async {
  //   final snapshot = await _firestore
  //       .collection('recipes')
  //       .where('name', isGreaterThanOrEqualTo: query)
  //       .where('name', isLessThanOrEqualTo: query + '\uf8ff')
  //       .get();
  //   return snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  // }
  // In RecipeService class
  // Stream<List<Recipe>> searchRecipes(String query) {
  //   return _firestore
  //       .collection('recipes')
  //       .where('Recipe Name', isGreaterThanOrEqualTo: query.toLowerCase())
  //       .where('Recipe Name', isLessThanOrEqualTo: query.toLowerCase() + '\uf8ff')
  //       .snapshots()
  //       .map((snapshot) =>
  //       snapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList());
  // }
  Stream<List<Recipe>> searchRecipes(String query) {
    return _firestore
        .collection('recipes')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Recipe.fromFirestore(doc))
        .where((recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }

}