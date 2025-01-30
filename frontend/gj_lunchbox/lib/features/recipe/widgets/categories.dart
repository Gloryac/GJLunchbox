import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final List<String> categories= ["All", "Lunch", "Snacks"];
  final void Function(String) onCategorySelected;
  final String selectedCategory;

  Categories({
    super.key,
    //required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              backgroundColor: Colors.grey.shade200,
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              checkmarkColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 36, // Fixed height for consistency
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: categories.length,
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           final isSelected = category == selectedCategory;
//
//           return Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: MaterialButton(
//               onPressed: () => onCategorySelected(category),
//               elevation: 0,
//               color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFF5F5F5),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(18),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               child: Text(
//                 category,
//                 style: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black87,
//                   fontSize: 14,
//                   fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }