import 'package:flutter/material.dart';
import 'package:medical/main.dart';
import 'package:medical/screens/doctor_details.dart';
import 'package:medical/utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isFav,
    this.isFavPage = false, // Thêm tham số này
  });

  final Map<String, dynamic> doctor;
  final bool isFav;
  final bool isFavPage; // Thêm biến này

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: isFavPage
          ? Config.widthSize - 40
          : (Config.widthSize * 0.5) - 20, // Điều chỉnh width
      height: isFavPage ? 150 : 300, // Điều chỉnh height
      child: GestureDetector(
        child: Card(
          color: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          elevation: 5,
          child: isFavPage
              ? Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      ),




                      child:
                        Image(
                          image: doctor['doctor_profile'] == null
                              ? NetworkImage(doctor['doctor_profile']) :
                          NetworkImage('https://cdn3d.iconscout.com/3d/premium/thumb/doctor-avatar-10107433-8179550.png?f=webp'),
                          width: 100,
                          height: 100, // Chiều cao của ảnh
                          fit: BoxFit.cover,
                        ),


                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr ${doctor['doctor_name']}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${doctor['category']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                SizedBox(width: 5),
                                Text('4.5'),
                                SizedBox(width: 5),
                                Text('Reviews'),
                                SizedBox(width: 5),
                                Text('(20)'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: (Config.widthSize * 0.5) - 20,
                      height: 165,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15.0)),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${doctor['category']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
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
                    ),
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
