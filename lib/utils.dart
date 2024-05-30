import 'package:intl/intl.dart';

String getFormattedDateNow() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-ddTHH:mm:ss,SSS');
  return formatter.format(now);
}
