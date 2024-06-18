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
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _bioData = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = user['name'] ?? '';
    _emailController.text = user['email'] ?? '';
    _fetchBioData();
  }

  Future<void> _fetchBioData() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await DioProvider().getUserBio(token);
      if (response != null && response['bio_data'] != null) {
        setState(() {
          _bioData = response['bio_data'];
          _bioController.text = _bioData;
        });
      }
    } catch (e) {
      print("Fetch bio data error: $e");
    }
  }

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
                  Column(
                    children: [
                      const SizedBox(height: 15),
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
                      const SizedBox(height: 5),
                      _isEditing
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Text(
                              user['name'],
                              style: const TextStyle(
                                color: Config.blackColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      const SizedBox(height: 5),
                      _isEditing
                          ? Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            )
                          : Text(
                              user['email'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _toggleEditSave,
                            icon: Icon(
                              _isEditing ? Icons.save : Icons.edit,
                              color: Config.primaryColor,
                            ),
                            label: Text(
                              _isEditing ? 'Save Profile' : 'Edit Profile',
                              style: TextStyle(color: Config.primaryColor),
                            ),
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: Config.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          if (_isEditing)
                            OutlinedButton.icon(
                              onPressed: _exitSave,
                              icon: const Icon(
                                Icons.exit_to_app,
                                color: Config.primaryColor,
                              ),
                              label: const Text(
                                'Exit Save',
                                style: TextStyle(color: Config.primaryColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Config.primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: <Widget>[
                              const TabBar(
                                tabs: [
                                  Tab(
                                    icon: FaIcon(FontAwesomeIcons.infoCircle),
                                  ),
                                  Tab(
                                    icon: FaIcon(FontAwesomeIcons.mapMarkerAlt),
                                  ),
                                ],
                                labelColor: Config.primaryColor,
                                unselectedLabelColor: Colors.grey,
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    _isEditing
                                        ? Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SingleChildScrollView(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height,
                                                ),
                                                child: TextField(
                                                  controller: _bioController,
                                                  maxLines: null,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Bio',
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Center(
                                              child: SingleChildScrollView(
                                                child: Text(_bioData),
                                              ),
                                            ),
                                          ),
                                    Center(
                                      child: MapPage(showControls: false),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  void _toggleEditSave() {
    if (_isEditing) {
      // Save changes to user map
      setState(() {
        user['name'] = _nameController.text;
        user['email'] = _emailController.text;
        _bioData = _bioController.text;
      });
      _saveProfile();
    } else {
      // Load existing data into controllers
      setState(() {
        _nameController.text = user['name'];
        _emailController.text = user['email'];
        _bioController.text = _bioData;
        _isEditing = !_isEditing;
      });
    }
  }

  void _exitSave() {
    if (_isEditing) {
      setState(() {
        user['name'] = _nameController.text;
        user['email'] = _emailController.text;
        _bioController.text = _bioData;
        _isEditing = false;
      });
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await DioProvider().updateUserProfile(
        token,
        _nameController.text,
        _emailController.text,
      );

      final bioResponse = await DioProvider().updateUserBio(
        token,
        _bioController.text,
      );

      if (response != null && response['status'] == 'success') {
        setState(() {
          user['name'] = response['user']['name'];
          user['email'] = response['user']['email'];
          _bioData = _bioController.text;
          _isEditing = false;
        });
      }
    } catch (e) {
      print("Profile update error: $e");
    }
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
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
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
