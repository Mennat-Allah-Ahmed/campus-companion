// lib/features/events/join_us_page.dart

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:project/features/auth/widgets/registerlogin_field.dart';
import 'package:project/features/action_btn.dart';
import 'package:project/features/profile/widgets/drop_down_field.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import 'package:project/features/auth/widgets/registerlogin_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoinUsPage extends StatefulWidget {
  const JoinUsPage({Key? key});

  @override
  State<JoinUsPage> createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameCtrl = TextEditingController();
  final TextEditingController _wsphoneNumberController =
      TextEditingController();
  final TextEditingController _tlphoneNumberController =
      TextEditingController();

  // Dropdown state
  String? _selectedLevel;
  String? _selectedDep;
  String? _selectedgradYear;
  String? _selectedrole;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _wsphoneNumberController.dispose();
    _tlphoneNumberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO: send data to your backend or service
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your information has been submitted!')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SilverAppBarWidget(
                appBarText: "Join Us",
                onBackPressed: () => Navigator.of(context).pop()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormWidget(
                        labelText: 'Full name',
                        hintText: 'Enter your full name',
                        keyPad: TextInputType.name,
                        controller: _nameCtrl,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),
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
                                setState(() {
                                  _selectedLevel = value;
                                });
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
                              items: ['CCEP', 'EEC', 'ESEE', 'ISE', 'CSM'],
                              onChanged: (value) {
                                setState(() {
                                  _selectedDep = value;
                                });
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownFormWidget(
                              labelText: "Graduation Year",
                              hintText: "Select Graduation Year",
                              value: _selectedgradYear,
                              items: List.generate(5,
                                  (i) => (DateTime.now().year + i).toString()),
                              onChanged: (value) {
                                setState(() {
                                  _selectedgradYear = value;
                                });
                              },
                              itemColor: const Color(0xFF445B70),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownFormWidget(
                              labelText: "Role",
                              hintText: "Select Role",
                              value: _selectedrole,
                              items: ['HR', 'PR', 'Member'],
                              onChanged: (value) {
                                setState(() {
                                  _selectedrole = value;
                                });
                              },
                              itemColor: const Color(0xFF834746),
                              itemIcons: {
                                'HR': FontAwesomeIcons.userTie,
                                'PR': FontAwesomeIcons.userTie,
                                'Member': FontAwesomeIcons.peopleGroup,
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const SizedBox(height: 30),

                      //Numbers
                      FormWidget(
                        labelText: "WhatsApp Number",
                        hintText: 'WhatsApp number as 1XXXXXXXX',
                        keyPad: TextInputType.phone,
                        controller: _wsphoneNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your WhatsApp number';
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
                            CountryFlag.fromCountryCode('EG',
                                height: 20,
                                width: 28,
                                shape: const RoundedRectangle(6)),
                            const SizedBox(width: 6),
                            const Text('+20',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Telegram Number (Optional)
                      FormWidget(
                        labelText: "Telegram Number",
                        hintText: 'Telegram number as 1XXXXXXXX',
                        keyPad: TextInputType.phone,
                        controller: _tlphoneNumberController,
                        validator: (_) => null,
                        prefixWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CountryFlag.fromCountryCode('EG',
                                height: 20,
                                width: 28,
                                shape: const RoundedRectangle(6)),
                            const SizedBox(width: 6),
                            const Text('+20',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Submit button
                      ActionBtn(
                        buttonText: 'Submit',
                        onPressed: _submit,
                        buttonColor: const Color(0xFF445B70),
                        buttonTextColor: Colors.white,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
