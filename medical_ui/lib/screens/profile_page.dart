import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical/main.dart';
import 'package:medical/models/auth_model.dart';
import 'package:medical/providers/dio_provider.dart';
import 'package:medical/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AuthModel>(context, listen: false).getUser;
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
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile == null
                            ? NetworkImage(
                                "http://127.0.0.1:8000/storage/${user['profile_photo_path']}")
                            : FileImage(File(_imageFile!.path))
                                as ImageProvider,
                        onBackgroundImageError: (_, __) {
                          // Khi không thể tải hình ảnh từ server
                          setState(() {
                            _imageFile = null;
                          });
                        },
                        child: _imageFile == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
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
                            _buildTile(FontAwesomeIcons.signOutAlt, 'Logout',
                                logout: true),
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

  Future<void> _pickImage() async {
    final action = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Select From Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });

    if (action == null) {
      return;
    }

    final XFile? selectedImage = await _picker.pickImage(
      source: action,
    );

    setState(() {
      _imageFile = selectedImage;
    });
  }

  Widget _buildTile(IconData icon, String title, {bool logout = false}) {
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
      onTap: logout
          ? _logout
          : () {
              // Xử lý sự kiện khi nhấp vào ListTile
            },
    );
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      //logout here
      final response = await DioProvider().logout(token);

      if (response == 200) {
        //if successfully delete access token
        //then delete token saved at Shared Preference as well
        await prefs.remove('token');
        setState(() {
          //redirect to login page
          MyApp.navigatorKey.currentState!.pushReplacementNamed('/');
        });
      }
    }
  }
}
