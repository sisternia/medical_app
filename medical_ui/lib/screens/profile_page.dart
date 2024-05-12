import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};

  Future<void> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      final response = await DioProvider().getUser(token);
      if (response != null) {
        setState(() {
          user = json.decode(response);
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Thay thế bằng đường dẫn đến ảnh của bạn
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user['name'],
                      style: const TextStyle(
                        color: Config.blackColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user['email'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Config.primaryColor, // Thay đổi màu nền ở đây
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton.icon(
                        onPressed: () {
                          // Xử lý sự kiện khi nhấp vào nút
                        },
                        icon: const Icon(Icons.edit, color: Config.whiteColor),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Config.whiteColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView(
                          children: [
                            _buildTile(FontAwesomeIcons.cogs, 'Settings'),
                            _buildTile(FontAwesomeIcons.user, 'User Details'),
                            _buildTile(FontAwesomeIcons.mapLocation, 'Map'),
                            const Divider(color: Colors.grey),
                            _buildTile(
                                FontAwesomeIcons.infoCircle, 'Information'),
                            _buildTile(FontAwesomeIcons.signOutAlt, 'Logout'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTile(IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Config.primaryColor,
        child: FaIcon(icon, size: 20.0, color: Config.whiteColor),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Config.blackColor),
      ),
      trailing: const CircleAvatar(
        backgroundColor: Config.whiteColor,
        child: Icon(Icons.arrow_forward, color: Config.primaryColor),
      ),
      onTap: () {
        // Xử lý sự kiện khi nhấp vào ListTile
      },
    );
  }
}
