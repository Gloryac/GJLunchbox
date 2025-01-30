import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dj_lunchbox/features/recipe/widgets/categories.dart';
import 'package:dj_lunchbox/features/recipe/widgets/popular_recipes.dart';
import 'package:dj_lunchbox/utils/constants/colors.dart';
import 'package:dj_lunchbox/utils/constants/text_strings.dart';
import 'package:dj_lunchbox/utils/constants/text_style.dart';
import 'package:flutter/material.dart';

import '../services/recipe_service.dart';
import '../widgets/featured_recipes.dart';
import '../widgets/recipe_list.dart';
import '../widgets/search_bar.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
List<String> categories = ["All"];
String selectedCategory = "All";
bool isLoading = true;
String searchQuery = '';
final RecipeService _recipeService = RecipeService()
;

@override
void initState() {
  super.initState();
  fetchCategories();
}

Future<void> fetchCategories() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection("recipes").get();
    if (snapshot.docs.isNotEmpty) {
      Set<String> fetchedCategories = snapshot.docs
          .map((doc) => doc.data()["Category"]?.toString() ?? "")
          .where((category) => category.isNotEmpty)
          .toSet();

      setState(() {
        categories = ["All", ...fetchedCategories];
        isLoading = false;
      });
    }
  } catch (e) {
    print("Error fetching categories: $e");
    setState(() => isLoading = false);
  }
}

void onCategorySelected(String category) {
  setState(() => selectedCategory = category);
}
void onSearch(String query) {
  setState(() => searchQuery = query);
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('Recipes'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: RecipeSearchBar(onSearch: onSearch),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FeaturedSection(),
                const SizedBox(height: 24),
                Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const LinearProgressIndicator()
                else
                  Categories(
                    //categories: categories,
                    selectedCategory: selectedCategory,
                    onCategorySelected: onCategorySelected,
                  ),
                const SizedBox(height: 24),
                Text(
                  'All Recipes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: RecipeList(
            selectedCategory: selectedCategory,
            searchQuery: searchQuery,
            recipeService: _recipeService,
          ),
        ),
      ],
    ),
  );
}
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.white,
//         elevation: 0,
//         title: Text(TextStrings.recipe),
//         actions: [
//           IconButton(onPressed: (){}, icon: Icon(Icons.search))
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 FeaturedSection(),
//                 const SizedBox(height: 13.0),
//                 Text(TextStrings.category, style: AppTextTheme.textStyles.headlineSmall,),
//                 const SizedBox(height: 13.0),
//                 isLoading
//                   ? const LinearProgressIndicator()
//                   :Categories(
//                     categories: categories,
//                     onCategorySelected: onCategorySelected,
//                     selectedCategory: selectedCategory,),
//                 const SizedBox(height: 13.0),
//                 Text(TextStrings.popularRecipes, style: AppTextTheme.textStyles.headlineSmall,),
//                 const SizedBox(height: 13.0),
//                 PopularRecipes(),
//               ],
//             ),
//           ),
//
//
//         ],
//       ),
//     );
//   }
// }


