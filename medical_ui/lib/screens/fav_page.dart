import "package:flutter/material.dart";
import "package:medical/components/doctor_card.dart";
import "package:provider/provider.dart";

import "../models/auth_model.dart";

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            const Text(
              'My Favorite Doctors',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Consumer<AuthModel>(
                builder: (context, auth, child) {
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const DoctorCard(
                          route: 'doctor_details', doctor: {});
                    },
                  );
                },
                //child:
              ),
            ),
          ],
        ),
      ),
    );
  }
}
