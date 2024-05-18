import 'package:flutter/material.dart';
import 'package:medical/main.dart';
import 'package:medical/screens/doctor_details.dart';
import 'package:medical/utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isFav,
  });

  final Map<String, dynamic> doctor;
  final bool isFav;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: (Config.widthSize * 0.5) -
          20, // Điều chỉnh width để hiển thị 2 DoctorCard trên một hàng
      height: 300, // Chiều cao của DoctorCard
      child: GestureDetector(
        child: Card(
          color: Colors.white, // Thay đổi màu sắc
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(15.0)), // Bo góc cho hình vuông
          ),
          elevation: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: (Config.widthSize * 0.5) - 20,
                height: 165, // Chiều cao của hình ảnh
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.circular(15.0)), // Bo góc cho hình vuông
                  child: Image(
                    image: NetworkImage(
                      "http://127.0.0.1:8000${doctor['doctor_profile']}",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Dr ${doctor['doctor_name']}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${doctor['category']}',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.star_border,
                color: Colors.yellow,
                size: 16,
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('4.5'),
                  SizedBox(width: 5),
                  Text('Reviews'),
                  SizedBox(width: 5),
                  Text('(20)'),
                ],
              )
            ],
          ),
        ),
        onTap: () {
          MyApp.navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => DoctorDetails(
                    doctor: doctor,
                    isFav: isFav,
                  )));
        },
      ),
    );
  }
}
