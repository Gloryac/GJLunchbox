import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';     // Import Firebase Auth

/// Shows a multi-date picker modal using CalendarDatePicker2.
///
/// Returns a list of selected [DateTime] objects, or null if cancelled.
Future<List<DateTime>?> showMultiDatePickerModal(
    BuildContext context, {
      required String RecipeId,
      required String RecipeCategory,
    }) async {
  List<DateTime?> selectedDates = []; // Local state to hold selected dates within the modal

  final results = await showModalBottomSheet<List<DateTime?>>(
    context: context,
    isScrollControlled: true, // Allows the bottom sheet to be full screen
    builder: (BuildContext context) {
      return StatefulBuilder( // Use StatefulBuilder to update UI within the modal
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75, // Adjust height as needed
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.multi,
                      selectedDayHighlightColor: Colors.blue,
                      selectedDayTextStyle: const TextStyle(color: Colors.white),
                      // Add more customizations here as needed
                    ),
                    value: selectedDates, // Pass current selected dates
                    onValueChanged: (dates) {
                      setState(() { // Update the local state when dates change
                        selectedDates = dates;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, null); // Dismiss without selecting
                      },
                      child: const Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Filter out nulls and convert to non-nullable DateTime list
                        final nonNullSelectedDates = selectedDates.whereType<DateTime>().toList();

                        if (nonNullSelectedDates.isNotEmpty) {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            final userId = user.uid;
                            final firestore = FirebaseFirestore.instance;
                            final mealPlanCategory = RecipeCategory + "_meal_plan";

                            // Reference to the collection based on RecipeCategory
                            // Ensure your RecipeCategory is safe to use as a collection name (e.g., no special characters)
                            final collectionRef = firestore.collection(mealPlanCategory);
                            final userDocRef = collectionRef.doc(userId);

                            // Create the JSON object for Firebase
                            Map<String, dynamic> dataToUpdate = {};
                            for (DateTime date in nonNullSelectedDates) {
                              DateTime midnightUtc = DateTime.utc(date.year, date.month, date.day);

                              dataToUpdate[midnightUtc.toIso8601String()] = RecipeId;
                            }

                            try {
                              await userDocRef.set(
                                dataToUpdate,
                                SetOptions(merge: true), // Use merge: true to update/add fields without overwriting the whole document
                              );
                              print('Successfully saved recipe consumption dates for $RecipeId under category $RecipeCategory for user $userId.');
                            } catch (e) {
                              print('Error saving dates to Firebase: $e');
                              // You might want to show an error message to the user here
                            }
                          } else {
                            print('No user logged in.');
                            // Handle case where user is not logged in (e.g., navigate to login screen)
                          }
                        }

                        Navigator.pop(context, nonNullSelectedDates); // Dismiss and return selected dates
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );

  // Return the results, filtering out any potential nulls if the picker
  // itself returns nullable DateTimes but we want a non-nullable list.
  return results?.whereType<DateTime>().toList();
}