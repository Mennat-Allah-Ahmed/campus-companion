// Sample news data (replace with Firestore or API data in production)

import 'package:project/features/home/view/models/news_model.dart';

final List<News> newsItems = [
  News(
    imagePath: 'assets/images/news1.png',
    description:
        'Dr. Tamer Samir inspects Aptitude Tests at Faculties of Applied Arts and Physical Education',
    date: 'Feb 15, 2025',
  ),
  News(
    imagePath: 'assets/images/news1.png',
    description: 'New engineering lab opens at Faculty of Engineering',
    date: 'Feb 16, 2025',
  ),
  News(
    imagePath: 'assets/images/news1.png',
    description: 'Annual student conference scheduled for March',
    date: 'Feb 17, 2025',
  ),
];
