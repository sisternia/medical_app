import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical/components/map.dart';
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
              child: Stack(
                children: [
                  Padding(
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
                              setState(() {
                                _imageFile = null;
                              });
                            },
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
                        OutlinedButton.icon(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấp vào nút Edit Profile
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Config.primaryColor,
                          ),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(color: Config.primaryColor),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Config.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: DefaultTabController(
                            length: 2,
                            child: Column(
                              children: <Widget>[
                                TabBar(
                                  tabs: [
                                    Tab(
                                      icon: FaIcon(FontAwesomeIcons.infoCircle),
                                      text: 'About Me',
                                    ),
                                    Tab(
                                      icon:
                                          FaIcon(FontAwesomeIcons.mapMarkerAlt),
                                      text: 'Location',
                                    ),
                                  ],
                                  labelColor: Config.primaryColor,
                                  unselectedLabelColor: Colors.grey,
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      Center(child: Text('About Me Content')),
                                      Center(
                                        child: MapPage(showControls: false),
                                      ), // Thay đổi ở đây
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.signOutAlt,
                          color: Config.primaryColor),
                      onPressed: _confirmLogout,
                    ),
                  ),
                ],
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

    if (selectedImage != null) {
      setState(() {
        _imageFile = selectedImage;
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await DioProvider().uploadProfileImage(
        File(_imageFile!.path),
        token,
      );

      if (response != null && response['profile_photo_path'] != null) {
        setState(() {
          user['profile_photo_path'] = response['profile_photo_path'];
        });
      }
    } catch (e) {
      print("Upload error: $e");
    }
  }

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _confirmLogout() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
          backgroundColor:
              Colors.transparent, // Make the AlertDialog background transparent
          contentPadding:
              EdgeInsets.zero, // Remove default padding around content
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text(
                      'Confirm Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Yes'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('No'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (result == true) {
      _logout();
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      final response = await DioProvider().logout(token);

      if (response == 200) {
        await prefs.remove('token');
        setState(() {
          MyApp.navigatorKey.currentState!.pushReplacementNamed('/');
        });
      }
    }
  }
}
