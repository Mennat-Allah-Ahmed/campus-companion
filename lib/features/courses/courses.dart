import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import '../action_btn.dart';
import '../profile/widgets/drop_down_field.dart';
import 'add_course_page.dart';
import '../database/Database.dart';
import '../Services/auth/auth_service.dart';

class CoursesPage extends StatefulWidget {
  final VoidCallback onBackToHome; // Callback to switch to HomePage
  const CoursesPage({super.key, required this.onBackToHome});

  @override
  _CoursesPageState createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String? _selectedLevel;
  String? _selectedGroup;
  List<Map<String, dynamic>> _enrolledCourses = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadEnrolledCourses();
  }

  Future<void> _loadEnrolledCourses() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final studentId = await _dbHelper.ensureStudentExists(
        user.uid,
        user.displayName ?? 'Unknown',
        user.email ?? '',
      );
      print('Fetching enrolled courses for student ID: $studentId');
      final courses = await _dbHelper.readData(
        'SELECT course.course_ID, course.name, course.credit_hours FROM enrollment JOIN course ON enrollment.course_ID = course.course_ID WHERE enrollment.student_id = ?',
        [studentId],
      );
      print('Enrolled courses: $courses');
      setState(() {
        _enrolledCourses = List<Map<String, dynamic>>.from(courses);
      });
    } else {
      print('No user logged in');
      setState(() {
        _enrolledCourses = [];
      });
    }
  }

  Future<void> _deleteCourse(String courseId) async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      final studentId = await _dbHelper.ensureStudentExists(
        user.uid,
        user.displayName ?? 'Unknown',
        user.email ?? '',
      );
      final result = await _dbHelper.deleteEnrollment(studentId, courseId);
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course removed successfully!')),
        );
        await _loadEnrolledCourses();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove course.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to remove courses.')),
      );
    }
  }

  // Handle physical back button
  Future<bool> _onWillPop() async {
    widget.onBackToHome(); // Switch to HomePage
    return false; // Prevent default pop
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SilverAppBarWidget(
              appBarText: "Courses",
              onBackPressed: widget.onBackToHome, // Switch to HomePage
            ),
            SliverToBoxAdapter(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5),
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
                                itemColor: Color(0xFF445B70),
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
                                labelText: "Group",
                                hintText: "Select Group",
                                value: _selectedGroup,
                                items: [
                                  'G1',
                                  'G2',
                                  'G3 "Communication Major Only"',
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGroup = value;
                                  });
                                },
                                itemColor: Color(0xFF834746),
                                itemIcons: {
                                  'G1': Icons.looks_one,
                                  'G2': Icons.looks_two,
                                  'G3 "Communication Major Only"':
                                      Icons.looks_3,
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ActionBtn(
                          buttonText: "Add Course",
                          icon: Icon(Icons.add_box_outlined),
                          buttonColor: Color(0xFF445B70),
                          buttonTextColor: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCoursePage(),
                              ),
                            ).then((result) {
                              if (result == true) {
                                _loadEnrolledCourses();
                              }
                            });
                          },
                        ),
                        SizedBox(height: 24),
                        Text(
                          "Enrolled Courses",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Inter"),
                        ),
                        SizedBox(height: 10),
                        _enrolledCourses.isEmpty
                            ? Center(
                                child: Text(
                                "No courses enrolled.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF888888),
                                    fontFamily: "Inter"),
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _enrolledCourses.length,
                                itemBuilder: (context, index) {
                                  final course = _enrolledCourses[index];
                                  return ListTile(
                                    title: Text(course['name']),
                                    subtitle: Text(
                                        'ID: ${course['course_ID']} | Credits: ${course['credit_hours']}'),
                                    trailing: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteCourse(course['course_ID']);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
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
