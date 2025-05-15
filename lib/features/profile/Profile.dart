import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:country_flags/country_flags.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project/features/profile/widgets/list_tile_elements.dart';
import '../Services/auth/auth_service.dart';
import '../action_btn.dart';
import '../auth/widgets/registerlogin_field.dart';
import '../auth/widgets/registerlogin_text.dart';
import '../courses/courses.dart';
import '../silver_app_bar_widget.dart';
import 'widgets/drop_down_field.dart';

class EditProfilePage extends StatefulWidget {
  final VoidCallback onBackToHome; // Callback to switch to HomePage
  const EditProfilePage({super.key, required this.onBackToHome});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  File? _image;
  String? _profileImagePath;
  String displayName = 'Guest';
  bool showNote = false;
  bool _isSavingImage = false;
  bool _isDataLoaded = false;

  // Initialize with default values
  String _selectedLevel = 'Level Zero';
  String _selectedDep = 'CCEP';

  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(
        'EditProfilePage initState with defaults - Year: $_selectedLevel, Dep: $_selectedDep');
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user == null || user.email == null) {
      print('No user or email found');
      setState(() {
        displayName = 'Guest';
        showNote = true;
        _firstNameController.text = '';
        _lastNameController.text = '';
        _emailController.text = '';
        _phoneNumberController.text = '';
        _gpaController.text = '';
        _profileImagePath = null;
        _isDataLoaded = true;
      });
      return;
    }

    try {
      print('Fetching profile data for user ID: ${user.uid}');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      print('Document exists: ${doc.exists}');

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('Raw Firestore data: $data');

        final year = data['year'] as String?;
        final department = data['department'] as String?;
        final profileImagePath = data['profileImagePath'] as String?;
        final firstName = data['firstName'] as String?;
        final lastName = data['lastName'] as String?;
        final email = data['email'] as String?;
        final phoneNumber = data['phoneNumber'] as String?;
        final gpa = data['gpa'] as String?;

        print('Extracted values - Year: $year, Department: $department');

        String? validProfileImagePath;
        if (profileImagePath != null) {
          final file = File(profileImagePath);
          if (await file.exists()) {
            validProfileImagePath = profileImagePath;
            print('Profile image exists at path: $profileImagePath');
          } else {
            print('Local image file does not exist: $profileImagePath');
          }
        }

        setState(() {
          final capitalizedFirstName = firstName?.capitalize();
          final capitalizedLastName = lastName?.capitalize();

          displayName =
              (capitalizedFirstName != null && capitalizedLastName != null)
                  ? '$capitalizedFirstName $capitalizedLastName'
                  : capitalizedFirstName ??
                      user.email!.split('@').first.capitalize();

          showNote = firstName == null;
          _firstNameController.text = firstName ?? '';
          _lastNameController.text = lastName ?? '';
          _emailController.text = email ?? user.email!;
          _phoneNumberController.text = phoneNumber ?? '';
          _selectedLevel = year ?? 'Level Zero';
          _selectedDep = department ?? 'CCEP';
          _gpaController.text = gpa ?? '';
          _profileImagePath = validProfileImagePath;
          _isDataLoaded = true;

          print(
              'After loading data - Year: $_selectedLevel, Department: $_selectedDep');
        });
        return;
      } else {
        print('No document found for user ID: ${user.uid}');
      }
    } catch (e) {
      print('Error fetching Firestore data: $e');
    }

    final provider = user.providerData
        .firstWhere((data) => data.providerId != 'firebase',
            orElse: () => user.providerData.first)
        .providerId;

    if (provider == 'microsoft.com') {
      final regex = RegExp(r'([a-zA-Z]+)\d+@feng\.bu\.edu\.eg');
      final match = regex.firstMatch(user.email!);
      final extractedName = match?.group(1)?.capitalize();

      setState(() {
        displayName =
            extractedName ?? user.email!.split('@').first.capitalize();
        showNote = true;
        _firstNameController.text = extractedName ?? '';
        _lastNameController.text = '';
        _emailController.text = user.email!;
        _phoneNumberController.text = '';
        _gpaController.text = '0.0';
        _profileImagePath = null;
        _isDataLoaded = true;
        print(
            'Microsoft provider defaults - Year: $_selectedLevel, Dep: $_selectedDep');
      });
    } else {
      setState(() {
        displayName = user.email!.split('@').first.capitalize();
        showNote = true;
        _firstNameController.text = user.email!.split('@').first;
        _lastNameController.text = '';
        _emailController.text = user.email!;
        _phoneNumberController.text = '';
        _gpaController.text = '';
        _profileImagePath = null;
        _isDataLoaded = true;
        print(
            'Default provider defaults - Year: $_selectedLevel, Dep: $_selectedDep');
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final ImageSource? selectedSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: screenWidth * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Select Image',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Inter",
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Select an image source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF888888),
                      fontFamily: "Inter",
                    ),
                  ),
                ),
                ListTileElements(
                  titleListTile: 'Camera',
                  listTileColor: const Color(0xFF445B70),
                  leadingIcon: Icons.camera_alt,
                  iconColor: const Color(0xFF445B70),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTileElements(
                  titleListTile: 'Gallery',
                  listTileColor: const Color(0xFF445B70),
                  leadingIcon: Icons.photo_library,
                  iconColor: const Color(0xFF445B70),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTileElements(
                  titleListTile: 'Cancel',
                  listTileColor: const Color(0xFF834746),
                  leadingIcon: Icons.cancel,
                  iconColor: const Color(0xFF834746),
                  onTap: () => Navigator.pop(context, null),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        );
      },
    );

    if (selectedSource != null) {
      try {
        final pickedImage = await picker.pickImage(source: selectedSource);
        if (pickedImage != null) {
          setState(() {
            _image = File(pickedImage.path);
          });
        }
      } catch (e) {
        print('Error picking image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    final authService = AuthService();
    final user = authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _isSavingImage = true;
      });
      try {
        String? profileImagePath = _profileImagePath;
        if (_image != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = '${directory.path}/${user.uid}.jpg';
          final newImageFile = await _image!.copy(imagePath);
          print('Image saved locally to: $imagePath');
          profileImagePath = newImageFile.path;
        }

        print(
            'Before saving to Firestore - Year: $_selectedLevel, Department: $_selectedDep');

        final Map<String, dynamic> payload = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
          'year': _selectedLevel,
          'department': _selectedDep,
          'gpa': _gpaController.text,
          'profileImagePath': profileImagePath,
        };

        print('Full payload for Firestore: $payload');

        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        await docRef.set(payload, SetOptions(merge: true));

        final savedDoc = await docRef.get();
        print('Document after save: ${savedDoc.data()}');

        setState(() {
          _profileImagePath = profileImagePath;
          _image = null;
          _isSavingImage = false;
        });

        print(
            'Profile saved successfully - Year=$_selectedLevel, Department=$_selectedDep');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } catch (e) {
        print('Error saving profile: $e');
        setState(() {
          _isSavingImage = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: $e')),
        );
      }
    } else {
      print('No user for saving profile');
      setState(() {
        _isSavingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save profile.')),
      );
    }
  }

  void _handleSaveProfile() {
    if (_formKey.currentState!.validate()) {
      _saveProfile().then((_) {
        widget.onBackToHome();
      }).catchError((e) {
        print('Error in handleSaveProfile: $e');
      });
    }
  }

  Future<bool> _onWillPop() async {
    print(
        'EditProfilePage WillPopScope triggered, canPop: ${Navigator.of(context).canPop()}');
    widget.onBackToHome();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Building EditProfilePage - Year: $_selectedLevel, Dep: $_selectedDep, ImagePath: $_profileImagePath');

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SilverAppBarWidget(
                    appBarText: "Edit Profile",
                    onBackPressed: () {
                      widget.onBackToHome();
                    },
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _isSavingImage ? null : _pickImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : _profileImagePath != null
                                          ? FileImage(File(_profileImagePath!))
                                          : const AssetImage(
                                                  'assets/images/default_profile.png')
                                              as ImageProvider,
                                ),
                                if (_isSavingImage)
                                  const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          RegisterLoginText(
                            regTextContent: displayName,
                            regTextStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          RegisterLoginText(
                            regTextContent: 'Student',
                            regTextStyle: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF888888),
                            ),
                          ),
                          if (showNote) ...[
                            const SizedBox(height: 8),
                            RegisterLoginText(
                              regTextContent:
                                  'Name retrieved from email. Please update it if incorrect.',
                              regTextStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: FormWidget(
                                        labelText: "First Name",
                                        hintText: 'Enter your first name',
                                        keyPad: TextInputType.name,
                                        controller: _firstNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your first name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 9),
                                    Flexible(
                                      child: FormWidget(
                                        labelText: "Last Name",
                                        hintText: 'Enter your last name',
                                        keyPad: TextInputType.name,
                                        controller: _lastNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your last name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                FormWidget(
                                  labelText: "E-mail Address",
                                  hintText: 'Enter your e-mail',
                                  keyPad: TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 22),
                                FormWidget(
                                  labelText: "Phone Number",
                                  hintText: 'Phone number as 1XXXXXXXX',
                                  keyPad: TextInputType.phone,
                                  controller: _phoneNumberController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    if (!RegExp(r'^(\+20|0)?1[0-2,5]\d{8}$')
                                        .hasMatch(value)) {
                                      return "Phone must have 9 digits after 1 (e.g., 1XXXXXXXX)";
                                    }
                                    return null;
                                  },
                                  prefixWidget: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CountryFlag.fromCountryCode(
                                        'EG',
                                        height: 20,
                                        width: 28,
                                        shape: const RoundedRectangle(6),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        '+20',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownFormWidget(
                                        labelText: "Level",
                                        hintText: "Select Level",
                                        value: _selectedLevel,
                                        items: [
                                          'Level Zero',
                                          'Level One',
                                          'Level Two',
                                          'Level Three',
                                          'Level Four'
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            print('Year changed to: $value');
                                            setState(() {
                                              _selectedLevel = value;
                                            });
                                          }
                                        },
                                        itemColor: const Color(0xFF445B70),
                                        itemIcons: {
                                          'Level Zero': FontAwesomeIcons.zero,
                                          'Level One': FontAwesomeIcons.one,
                                          'Level Two': FontAwesomeIcons.two,
                                          'Level Three': FontAwesomeIcons.three,
                                          'Level Four': FontAwesomeIcons.four,
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownFormWidget(
                                        labelText: "Department",
                                        hintText: "Select Department",
                                        value: _selectedDep,
                                        items: [
                                          'CCEP',
                                          'EEC',
                                          'ESEE',
                                          'ISE',
                                          'CSM'
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            print(
                                                'Department changed to: $value');
                                            setState(() {
                                              _selectedDep = value;
                                            });
                                          }
                                        },
                                        itemColor: const Color(0xFF834746),
                                        itemImageIcons: {
                                          'CCEP': 'assets/images/ccep.png',
                                          'EEC': 'assets/images/eec.png',
                                          'ESEE': 'assets/images/esee.png',
                                          'ISE': 'assets/images/ise.png',
                                          'CSM': 'assets/images/csm.png',
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 22),
                                FormWidget(
                                  labelText: "GPA",
                                  hintText: 'Enter your GPA (e.g., 3.50)',
                                  keyPad: TextInputType.number,
                                  controller: _gpaController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your GPA';
                                    }
                                    final gpa = double.tryParse(value);
                                    if (gpa == null || gpa < 0 || gpa > 4) {
                                      return 'Please enter a valid GPA (0.0 to 4.0)';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 22),
                                ActionBtn(
                                  buttonText: "Save Changes",
                                  buttonColor: const Color(0xFF445B70),
                                  buttonTextColor: Colors.white,
                                  onPressed: () {
                                    if (!_isSavingImage) {
                                      print('Save Changes pressed');
                                      print(
                                          'Before save - Year: $_selectedLevel, Dep: $_selectedDep');
                                      _handleSaveProfile();
                                    }
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_isSavingImage)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}
