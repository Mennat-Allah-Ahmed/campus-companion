import 'package:flutter/material.dart';
import 'package:project/features/silver_app_bar_widget.dart';
import 'event_page.dart';
import 'join_us_page.dart';

class DynamicPage extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String description;

  const DynamicPage({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        Icon(Icons.calendar_month, color: Colors.pink.shade700),
        'Events',
        Colors.pink.shade50,
      ),
      _ActionItem(
        Icon(Icons.person_add, color: Colors.teal.shade700),
        'Join Us',
        Colors.teal.shade50,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SilverAppBarWidget(
              appBarText: title,
              onBackPressed: () => Navigator.of(context).pop(),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventPage(imageAsset: imageAsset),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        clipBehavior: Clip.hardEdge,
                        color: imageAsset.contains('4.png')
                            ? Colors.black
                            : Colors.white,
                        child: Image.asset(
                          imageAsset,
                          width: 350,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final buttonWidth = (constraints.maxWidth - 16) / 2;
                        return Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: actions.map((action) {
                            return SizedBox(
                              width: buttonWidth,
                              height: 56,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (action.label == 'Events') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EventPage(imageAsset: imageAsset),
                                      ),
                                    );
                                  } else if (action.label == 'Join Us') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JoinUsPage(),
                                      ),
                                    );
                                  }
                                },
                                icon: action.icon,
                                label: Text(
                                  action.label,
                                  style: TextStyle(
                                    color: action.label == 'Events'
                                        ? Colors.pink.shade700
                                        : action.label == 'Join Us'
                                            ? Colors.teal.shade700
                                            : Colors.black87,
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: action.background,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class
class _ActionItem {
  final Widget icon;
  final String label;
  final Color background;
  const _ActionItem(this.icon, this.label, this.background);
}
