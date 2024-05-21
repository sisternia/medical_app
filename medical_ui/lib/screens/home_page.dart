import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/components/appointment_card.dart';
import 'package:medical/components/doctor_card.dart';
import 'package:medical/models/auth_model.dart';
import 'package:medical/utils/config.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
    },
    {
      "icon": FontAwesomeIcons.lungs,
    },
    {
      "icon": FontAwesomeIcons.hand,
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
    },
    {
      "icon": FontAwesomeIcons.teeth,
    },
  ];

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;
    print('user data is: $user');
    print('favo list is: $favList');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 15), // Adjust the height as needed
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        user['name'],
                        style: const TextStyle(
                            color: Config.blackColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:user['profile_photo_path'] != null ? NetworkImage(
                            "http://127.0.0.1:8000/storage/${user['profile_photo_path']}??"
                        ) :NetworkImage('https://static-00.iconduck.com/assets.00/avatar-default-symbolic-icon-479x512-n8sg74wg.png') ,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Config.spaceSmall,
                          const Text(
                            'Category',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Config.spaceSmall,
                          SizedBox(
                            height: Config.heightSize * 0.06,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  List<Widget>.generate(medCat.length, (index) {
                                return Card(
                                  margin: const EdgeInsets.only(right: 20),
                                  color: Config.primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        FaIcon(
                                          medCat[index]['icon'],
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Config.spaceMedium,
                          const Text(
                            'Appointment Today',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Config.spaceSmall,
                          doctor.isNotEmpty
                              ? AppointmentCard(
                                  doctor: doctor,
                                  color: Config.primaryColor,
                                )
                              : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        'No Appointment Today',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Config.spaceMedium,
                          const Text(
                            'Top Doctor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Config.spaceSmall,
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                List.generate(user['doctor'].length, (index) {
                              return DoctorCard(
                                doctor: user['doctor'][index],
                                  isFav: favList.contains(
                                        user['doctor'][index]['doc_id'])
                                    ? true
                                    : false,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
