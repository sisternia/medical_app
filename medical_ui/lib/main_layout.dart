import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/screens/appointment_page.dart';
import 'package:medical/screens/fav_page.dart';
import 'package:medical/screens/home_page.dart';
import 'package:medical/screens/profile_page.dart';
import 'package:medical/screens/user_booking.dart'; // Import the user_booking page
import 'package:provider/provider.dart';
import 'package:medical/models/auth_model.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Variable declaration
  int currentPage = 0;
  final PageController _page = PageController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthModel>(context).getUser;
    final isDoctor = user['type'] == 'doctor';
    final isUser = user['type'] == 'user';

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
          if (!isDoctor) const AppointmentPage(),
          if (!isUser)
            UserBookingPage(
                docId: user['id'].toString()), // Provide the docId here
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
          if (!isDoctor)
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidCalendarCheck),
              label: 'Appointment',
            ),
          if (!isUser)
            const BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidCalendar),
              label: 'Bookings',
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
