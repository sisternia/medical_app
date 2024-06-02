import 'package:flutter/material.dart';
import 'package:medical/main.dart';
import 'package:medical/screens/doctor_details.dart';
import 'package:medical/utils/config.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.isFav,
    this.isFavPage = false, // Added this parameter
  });

  final Map<String, dynamic> doctor;
  final bool isFav;
  final bool isFavPage; // Added this variable

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: isFavPage
          ? Config.widthSize - 40
          : (Config.widthSize * 0.5) - 20, // Adjusted width
      height: isFavPage ? 150 : 300, // Adjusted height
      child: GestureDetector(
        child: Card(
            color: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            elevation: 5,
            child: isFavPage
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius as needed
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          ),
                          child: Image(
                            image: NetworkImage(
                                'http://127.0.0.1:8000${doctor['doctor_profile']}'),
                            width: 120,
                            height: 165, // Height of the image
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
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius as needed
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: (Config.widthSize * 0.5) - 20,
                          height: 165,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15.0)),
                            child: Image.network(
                              'http://127.0.0.1:8000${doctor['doctor_profile']}',
                              width: (Config.widthSize * 0.5) -
                                  20, // Set width as needed
                              height: 165, // Set height as needed
                              fit: BoxFit
                                  .cover, // Fit the image to cover the container
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
                  )),
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
