import 'package:flutter/material.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBookingPage extends StatefulWidget {
  final String docId;

  const UserBookingPage({required this.docId, super.key});

  @override
  _UserBookingPageState createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {
  List<dynamic> appointments = [];
  Map<String, List<dynamic>> groupedAppointments = {};

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    var data = await DioProvider().getAppointmentsByDocId(widget.docId);
    print(data); // Print API response
    setState(() {
      appointments = data;
      _groupAppointments();
    });
  }

  void _groupAppointments() {
    groupedAppointments.clear();
    for (var appointment in appointments) {
      String key = '${appointment['date']} - ${appointment['time']}';
      if (groupedAppointments.containsKey(key)) {
        groupedAppointments[key]!.add(appointment);
      } else {
        groupedAppointments[key] = [appointment];
      }
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color.fromARGB(255, 59, 209, 255);
      case 'complete':
        return Colors.green;
      case 'cancel':
        return Colors.red;
      case 'confirm':
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'upcoming':
        return 'UP';
      case 'complete':
        return 'CO';
      case 'cancel':
        return 'CA';
      case 'confirm':
        return 'CF';
      default:
        return 'NA';
    }
  }

  void _changeStatus(String appointmentId, String newStatus) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var response = await DioProvider()
        .updateAppointmentStatus(appointmentId, newStatus, token!);

    if (response == 200) {
      setState(() {
        _fetchAppointments();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status updated to ${_getStatusLabel(newStatus)}')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  void _showStatusSelectionSheet(String appointmentId, String currentStatus) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('Upcoming'),
              onTap: () {
                Navigator.pop(context);
                _changeStatus(appointmentId, 'upcoming');
              },
            ),
            ListTile(
              leading: Icon(Icons.check_circle),
              title: Text('Complete'),
              onTap: () {
                Navigator.pop(context);
                _changeStatus(appointmentId, 'complete');
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
                _changeStatus(appointmentId, 'cancel');
              },
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text('Confirm'),
              onTap: () {
                Navigator.pop(context);
                _changeStatus(appointmentId, 'confirm');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
            child: Center(
              child: Text(
                'User Bookings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: groupedAppointments.isEmpty
                ? Center(child: Text('No appointments found'))
                : ListView(
                    children: groupedAppointments.entries.map((entry) {
                      String dateTimeKey = entry.key;
                      List<dynamic> groupedList = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              dateTimeKey,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...groupedList.map((appointment) {
                            return GestureDetector(
                              onLongPress: () {
                                _showStatusSelectionSheet(
                                    appointment['id'].toString(),
                                    appointment['status']);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Name: ${appointment['user']['name']}'),
                                      Text(
                                          'Email: ${appointment['user']['email']}'),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                          appointment['status']),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      _getStatusLabel(appointment['status']),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
