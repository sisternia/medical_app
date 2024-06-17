import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel, confirm }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming; // initial status
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];

  // get appointments details
  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    if (appointment != 'Error') {
      setState(() {
        schedules = json.decode(appointment);
        print(schedules);
      });
    }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Color _getStatusColor(FilterStatus status) {
    switch (status) {
      case FilterStatus.upcoming:
        return const Color.fromARGB(255, 59, 209, 255);
      case FilterStatus.complete:
        return Colors.green;
      case FilterStatus.cancel:
        return Colors.red;
      case FilterStatus.confirm:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(FilterStatus status) {
    switch (status) {
      case FilterStatus.upcoming:
        return 'UP';
      case FilterStatus.complete:
        return 'CO';
      case FilterStatus.cancel:
        return 'CA';
      case FilterStatus.confirm:
        return 'CF';
      default:
        return 'NA';
    }
  }

  String _getFullStatusLabel(FilterStatus status) {
    switch (status) {
      case FilterStatus.upcoming:
        return 'UPCOMING';
      case FilterStatus.complete:
        return 'COMPLETE';
      case FilterStatus.cancel:
        return 'CANCEL';
      case FilterStatus.confirm:
        return 'CONFIRM';
      default:
        return 'NA';
    }
  }

  Alignment _getAlignment(FilterStatus status) {
    switch (status) {
      case FilterStatus.upcoming:
        return Alignment(-1.0, 0);
      case FilterStatus.complete:
        return Alignment(-0.33, 0);
      case FilterStatus.cancel:
        return Alignment(0.33, 0);
      case FilterStatus.confirm:
        return Alignment(1.0, 0);
      default:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredSchedules = schedules.where((var schedule) {
      switch (schedule['status']) {
        case 'upcoming':
          schedule['status'] = FilterStatus.upcoming;
          break;
        case 'complete':
          schedule['status'] = FilterStatus.complete;
          break;
        case 'cancel':
          schedule['status'] = FilterStatus.cancel;
          break;
        case 'confirm':
          schedule['status'] = FilterStatus.confirm;
          break;
      }
      return schedule['status'] == status;
    }).toList();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Config.spaceSmall,
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                status = filterStatus;
                                _alignment = _getAlignment(filterStatus);
                              });
                            },
                            child: Center(
                              child: Text(
                                status == filterStatus
                                    ? _getFullStatusLabel(filterStatus)
                                    : _getStatusLabel(filterStatus),
                                style: TextStyle(
                                  color: _getStatusColor(filterStatus),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 80,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Config.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        _getFullStatusLabel(status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Config.spaceSmall,
            Expanded(
              child: ListView.builder(
                itemCount: filteredSchedules.length,
                itemBuilder: ((context, index) {
                  var schedule = filteredSchedules[index];
                  bool isLastElement = filteredSchedules.length + 1 == index;
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: !isLastElement
                        ? const EdgeInsets.only(bottom: 20)
                        : EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://127.0.0.1:8000${schedule['doctor_profile']}"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule['doctor_name'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      schedule['category'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                        schedule['status'] as FilterStatus),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    _getStatusLabel(
                                        schedule['status'] as FilterStatus),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ScheduleCard(
                              date: schedule['date'],
                              day: schedule['day'],
                              time: schedule['time'],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard(
      {super.key, required this.date, required this.day, required this.time});
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Config.primaryColor,
            size: 15,
          ),
          Text(
            '$day, $date',
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            time,
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          )),
        ],
      ),
    );
  }
}
