import 'package:flutter/material.dart';
import 'package:medical/providers/dio_provider.dart';

class UserBookingPage extends StatefulWidget {
  final String docId;

  const UserBookingPage({required this.docId, super.key});

  @override
  _UserBookingPageState createState() => _UserBookingPageState();
}

class _UserBookingPageState extends State<UserBookingPage> {
  List<dynamic> appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    var data = await DioProvider().getAppointmentsByDocId(widget.docId);
    print(data); // In phản hồi từ API
    setState(() {
      appointments = data;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color.fromARGB(255, 59, 209, 255);
      case 'complete':
        return Colors.green;
      case 'cancel':
        return Colors.red;
      default:
        return Colors.grey;
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
      default:
        return 'NA';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: Text(
                'User Bookings',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: appointments.isEmpty
                ? Center(child: Text('No appointments found'))
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      var appointment = appointments[index];
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                              'Booking on ${appointment['date']}\nAt ${appointment['time']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${appointment['user']['name']}'),
                              Text('Email: ${appointment['user']['email']}'),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: _getStatusColor(appointment['status']),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
