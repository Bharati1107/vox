import 'package:cloud_firestore/cloud_firestore.dart';

String? formatTimestamp(Timestamp timestamp) {
  final dateTime = timestamp.toDate();
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes == 1) {
    return '1 minute ago';
  } else if (difference.inHours < 1) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours == 1) {
    return '1 hour ago';
  } else {
    return '${difference.inHours} hours ago';
  }
}
