import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDateTimeWidget extends StatefulWidget {
  final String userId;
  final String missionId;
  final Duration? duration;

  const UserDateTimeWidget({
    Key? key,
    required this.userId,
    required this.missionId,
    this.duration,
  }) : super(key: key);

  @override
  _UserDateTimeWidgetState createState() => _UserDateTimeWidgetState();
}

class _UserDateTimeWidgetState extends State<UserDateTimeWidget> {
  DateTime? dateTimeAfterDuration;

  @override
  void initState() {
    super.initState();
    if (widget.duration == null) {
      _fetchDurationAndCalculateDateTime();
    } else {
      _calculateDateTimeAndSendToBackend();
    }
  }

  Future<void> _fetchDurationAndCalculateDateTime() async {
    // Replace with your actual backend endpoint
    final response = await http.get(Uri.parse(
        'http://localhost:8080/missions/${widget.userId}/${widget.missionId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final durationInSeconds = data['duration']
          as int; // Update according to your backend response structure
      final duration = Duration(seconds: durationInSeconds);
      setState(() {
        dateTimeAfterDuration = _getDateTimeAfterDuration(duration);
      });
    } else {
      // Handle error or set state to show an error message
    }
  }

  Future<void> _calculateDateTimeAndSendToBackend() async {
    final newDateTime = _getDateTimeAfterDuration(widget.duration!);
    // Replace with your actual backend endpoint
    final response = await http.put(
      Uri.parse(
          'http://localhost:8080/missions/${widget.userId}/${widget.missionId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'preferredTime': newDateTime.toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        dateTimeAfterDuration = newDateTime;
      });
    } else {
      // Handle error or set state to show an error message
    }
  }

  DateTime _getDateTimeAfterDuration(Duration duration) {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    return midnight.add(duration);
  }

  @override
  Widget build(BuildContext context) {
    return dateTimeAfterDuration != null
        ? Text('DateTime after Duration: ${dateTimeAfterDuration!}')
        : CircularProgressIndicator(); // Show loading indicator while waiting for data
  }
}
