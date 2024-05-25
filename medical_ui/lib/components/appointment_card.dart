import 'package:flutter/material.dart';
import 'package:medical/components/rating_dialog.dart';
import 'package:medical/main.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key, required this.doctor, required this.color});

  final Map<String, dynamic> doctor;
  final Color color;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
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
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        final token = prefs.getString('token') ?? '';

                        final response = await DioProvider()
                            .updateAppointmentStatus(
                                widget.doctor['appointments']['id'],
                                'cancel',
                                token);

                        if (response == 200) {
                          setState(() {
                            widget.doctor['appointments']['status'] = 'cancel';
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Failed to cancel the appointment')));
                        }
                      },
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
                        'Completed',
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
                              image: const FlutterLogo(
                                size: 100,
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
