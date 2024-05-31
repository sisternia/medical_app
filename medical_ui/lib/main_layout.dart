// main_layout.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/screens/appointment_page.dart';
import 'package:medical/screens/fav_page.dart';
import 'package:medical/screens/home_page.dart';
import 'package:medical/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:medical/models/auth_model.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  //variable declaration
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context).getUser;
    final isDoctor = user['type'] == 'doctor';

    return Scaffold(
      body: PageView(
        controller: _page,
        onPageChanged: ((value) {
          setState(() {
            currentPage = value;
          });
        }),
        children: <Widget>[
          const HomePage(),
          if (!isDoctor) const FavPage(),
          const AppointmentPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (page) {
          setState(() {
            currentPage = page;
            _page.animateToPage(
              page,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.houseChimneyMedical),
            label: 'Home',
          ),
          if (!isDoctor)
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidHeart),
              label: 'Favorite',
            ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
            label: 'Appointment',
          ),
          const BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
