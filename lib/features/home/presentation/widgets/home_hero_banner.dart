import 'dart:async';

import 'package:flutter/material.dart';

import 'hero_banner_item.dart';

class HomeHeroBanner extends StatefulWidget {
  const HomeHeroBanner({super.key});

  @override
  State<HomeHeroBanner> createState() => _HomeHeroBannerState();
}

class _HomeHeroBannerState extends State<HomeHeroBanner> {
  final PageController _controller = PageController();

  Timer? _timer;
  int _currentPage = 0;
  double? _bannerRatio;
  ImageStream? _imageStream;
  ImageStreamListener? _imageListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_imageStream != null) return;

    _imageStream = AssetImage(banners.first.image)
        .resolve(createLocalImageConfiguration(context));

    _imageListener = ImageStreamListener((info, _) {
      if (!mounted) return;

      setState(() {
        _bannerRatio = info.image.width / info.image.height;
      });
    });

    _imageStream!.addListener(_imageListener!);
  }

  static const banners = [
    HeroBannerItem(
      image: 'assets/images/home/banner_1.png',
      title: 'رِواق للعناية ببيوت الله',
      description: 'نظافة وصيانة وعناية مستدامة بالمساجد',
    ),
    HeroBannerItem(
      image: 'assets/images/home/banner_2.png',
      title: 'نظافة وتعطير المساجد',
      description: 'عناية مستمرة ببيوت الله وراحة المصلين',
    ),
    HeroBannerItem(
      image: 'assets/images/home/banner_3.png',
      title: 'صيانة مرافق المساجد',
      description: 'صيانة المكيفات والكهرباء والسباكة',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;

      final nextPage = (_controller.page ?? 0).round() + 1;

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    if (_imageListener != null) {
      _imageStream?.removeListener(_imageListener!);
    }
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_bannerRatio != null)
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: _bannerRatio!,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index % banners.length;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    banners[index % banners.length].image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
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
    );
  }
}
