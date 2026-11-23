import 'dart:async';

import 'package:flutter/material.dart';

import 'home_news_card.dart';
import 'home_news_item.dart';

class HomeNewsSection extends StatefulWidget {
  const HomeNewsSection({super.key});

  @override
  State<HomeNewsSection> createState() => _HomeNewsSectionState();
}

class _HomeNewsSectionState extends State<HomeNewsSection> {
  final PageController _controller = PageController();

  Timer? _timer;
  int _currentPage = 0;

  static const List<HomeNewsItem> news = [
    HomeNewsItem(
      title: 'استمرار أعمال صيانة المكيفات في عدد من المساجد',
      description:
          'تواصل الجمعية أعمال الصيانة الدورية للمكيفات في عدد من المساجد.',
      image: 'assets/images/home/news_ac.png',
      date: '12 يناير 2025',
    ),
    HomeNewsItem(
      title: 'جهود متواصلة في نظافة وتعطير المساجد',
      description:
          'فرق العناية الميدانية تواصل أعمال النظافة والتعطير لخدمة بيوت الله.',
      image: 'assets/images/onboarding_2.jpg',
      date: 'بيانات تجريبية',
    ),
    HomeNewsItem(
      title: 'استمرار برنامج سقيا الماء',
      description: 'توفير مياه الشرب للمصلين ضمن برامج العناية بالمساجد.',
      image: 'assets/images/home/need_water.png',
      date: 'بيانات تجريبية',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!_controller.hasClients) return;

      final nextPage = (_currentPage + 1) % news.length;

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'آخر الأخبار والمشاريع',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
              TextButton(
                onPressed: () {
                  // صفحة جميع الأخبار لاحقًا.
                },
                child: const Text('عرض المزيد'),
              ),
            ],
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 145,
            child: PageView.builder(
              controller: _controller,
              itemCount: news.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                final item = news[index];

                return HomeNewsCard(
                  title: item.title,
                  description: item.description,
                  image: item.image,
                  date: item.date,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              news.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? const Color(0xFF4A2A16)
                      : const Color(0xFFD9B98A),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
