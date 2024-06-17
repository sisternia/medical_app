import 'package:flutter/material.dart';
import 'package:medical/components/rating_dialog.dart';
import 'package:medical/main.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({
    super.key,
    required this.doctor,
    required this.color,
    required this.onStatusChange,
  });

  final Map<String, dynamic> doctor;
  final Color color;
  final VoidCallback onStatusChange;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Confirm Cancellation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();

                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            final token = prefs.getString('token') ?? '';

                            final String appointmentId =
                                widget.doctor['appointments']['id'].toString();

                            final response = await DioProvider()
                                .updateAppointmentStatus(
                                    appointmentId, 'cancel', token);

                            if (response == 200) {
                              setState(() {
                                widget.doctor['appointments']['status'] =
                                    'cancel';
                              });
                              widget
                                  .onStatusChange(); // Call the callback function
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Failed to cancel the appointment')));
                            }
                          },
                          child: const Text('Yes'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(), // Close the dialog
                          child: const Text('No'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        "http://127.0.0.1:8000${widget.doctor['doctor_profile']}"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Dr ${widget.doctor['doctor_name']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        widget.doctor['category'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              Config.spaceSmall,
              ScheduleCard(
                appointment: widget.doctor['appointments'],
              ),
              Config.spaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _showCancelConfirmationDialog,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Review',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return RatingDialog(
                              initialRating: 1.0,
                              title: const Text(
                                'Rate the Doctor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              message: const Text(
                                'Please help us to rate our Doctor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              image: Image.asset(
                                'assets/images/Logo.png',
                                width: 100,
                                height: 100,
                              ),
                              submitButtonText: 'Submit',
                              commentHint: 'Your Reviews',
                              onSubmitted: (response) async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                final rating = await DioProvider().storeReviews(
                                    response.comment,
                                    response.rating,
                                    widget.doctor['appointments']['id'],
                                    widget.doctor['doc_id'],
                                    token);

                                if (rating == 200 && rating != '') {
                                  widget
                                      .onStatusChange(); // Call the callback function
                                  MyApp.navigatorKey.currentState!
                                      .pushNamed('main');
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.appointment});

  final Map<String, dynamic> appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '${appointment['day']}, ${appointment['date']}',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            width: 30,
          ),
          const Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              appointment['time'],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
