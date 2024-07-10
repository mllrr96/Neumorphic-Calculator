import 'package:timeago/timeago.dart' as timeago;

extension DateTimeExtension on DateTime {
  String get timeAgo => timeago.format(this);
}
