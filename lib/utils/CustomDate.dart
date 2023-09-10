// Package imports:
import 'package:intl/intl.dart';

class CustomDate {
  String formattedDateTime(date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }
  String formattedDate(date) {
    return DateFormat.yMMMd().format(date);
  }
  String formattedDateOnly(date) {
    return DateFormat.MMMd().format(date);
  }
  String formattedHourOnly(date) {
    return DateFormat('hh:mm a').format(date);
  }

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}
