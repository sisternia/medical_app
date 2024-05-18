import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/components/button.dart';
import 'package:medical/components/custom_appbar.dart';
import 'package:medical/models/auth_model.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({super.key, required this.doctor, required this.isFav});

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  Map<String, dynamic> doctor = {};
  bool isFav1 = false;
  bool isFav2 = false;

  @override
  void initState() {
    doctor = widget.doctor;
    isFav1 = widget.isFav;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final doctor = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        appTitle: 'Doctor Details',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: () async {
              final list =
                  Provider.of<AuthModel>(context, listen: false).getFav;

              if (list.contains(doctor['doc_id'])) {
                list.removeWhere((id) => id == doctor['doc_id']);
              } else {
                list.add(doctor['doc_id']);
              }

              Provider.of<AuthModel>(context, listen: false).setFavList(list);

              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              if (token.isNotEmpty && token != '') {
                final response = await DioProvider().storeFavDoc(token, list);

                if (response == 200) {
                  setState(() {
                    isFav1 = !isFav1;
                  });
                }
              }
            },
            icon: FaIcon(
              isFav1 ? Icons.favorite_rounded : Icons.favorite_outline,
              color: Colors.red[600],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isFav2 = !isFav2;
              });
            },
            icon: FaIcon(
              isFav2 ? Icons.message_rounded : Icons.message_outlined,
              color: Colors.blue[600],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AboutDoctor(
              doctor: doctor,
            ),
            DetailBody(
              doctor: doctor,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Button(
                width: double.infinity,
                title: 'Book Appointment',
                onPressed: () {
                  Navigator.of(context).pushNamed('booking_page',
                      arguments: {"doctor_id": doctor['doc_id']});
                },
                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AboutDoctor extends StatelessWidget {
  const AboutDoctor({super.key, required this.doctor});

  final Map<dynamic, dynamic> doctor;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 65.0,
            backgroundImage: NetworkImage(
                "http://127.0.0.1:8000${doctor['doctor_profile']}"),
            backgroundColor: Colors.white,
          ),
          Config.spaceMedium,
          Text(
            'Dr ${doctor['doctor_name']}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 0.75,
            child: Text(
              '${doctor['location']}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          Config.spaceSmall,
          SizedBox(
            width: Config.widthSize * 1.0,
            child: Text(
              '${doctor['category']}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({super.key, required this.doctor});

  final Map<dynamic, dynamic> doctor;
  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Config.spaceSmall,
          DoctorInfo(
            patients: doctor['patients'],
            exp: doctor['experience'],
          ),
          Config.spaceMedium,
          const Text(
            'About Doctor',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Config.spaceSmall,
          Text(
            "Dr ${doctor['doctor_name']} có kinh nghiệm ${doctor['experience']} năm là ${doctor['category']} địa chỉ ${doctor['location']} ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            softWrap: true,
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key, required this.patients, required this.exp});

  final int patients;
  final int exp;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        InfoCard(label: 'Patients', value: '$patients'),
        const SizedBox(
          width: 15,
        ),
        InfoCard(label: 'Experients', value: '$exp Year'),
        const SizedBox(
          width: 15,
        ),
        const InfoCard(label: 'Rating', value: '4.5'),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Config.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
