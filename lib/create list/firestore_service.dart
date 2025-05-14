import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

Future<void> saveListRequest({
  required String? governorate,
  required String? constituency,
  required String listName,
  required int candidatesCount,
  required String listAddress,
  required Map<String, dynamic> delegate,
  required List<Map<String, dynamic>> members,
  required Map<String, PlatformFile?> uploadedFiles,
  required String userId,
}) async {
  try {
    final listData = {
      'governorate': governorate,
      'constituency': constituency,
      'listName': listName,
      'candidatesCount': candidatesCount,
      'listAddress': listAddress,
      'delegate': delegate,
      'members': members,
      'uploadedFiles':
          uploadedFiles.map((label, file) => MapEntry(label, file?.name)),
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pinned',
    };

    await FirebaseFirestore.instance.collection('lists_requests').add(listData);
    print("List request saved successfully!");
  } catch (e) {
    print("Error saving list request: $e");
    rethrow;
  }
}
