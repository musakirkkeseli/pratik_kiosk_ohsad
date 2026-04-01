import 'package:flutter/material.dart';

class InsuranceLogoCarousel extends StatefulWidget {
  const InsuranceLogoCarousel({super.key});

  @override
  State<InsuranceLogoCarousel> createState() => _InsuranceLogoCarouselState();
}

class _InsuranceLogoCarouselState extends State<InsuranceLogoCarousel> {
  late ScrollController _scrollController;

  final List<String> _logos = [
    'assets/sigorta/1.png',
    'assets/sigorta/2.png',
    'assets/sigorta/3.png',
    'assets/sigorta/4.png',
    'assets/sigorta/5.png',
    'assets/sigorta/6.png',
    'assets/sigorta/7.png',
    'assets/sigorta/8.png',
    'assets/sigorta/9.png',
    'assets/sigorta/10.png',
    'assets/sigorta/11.png',
    'assets/sigorta/12.png',
    'assets/sigorta/13.jpeg',
    'assets/sigorta/14.png',
    'assets/sigorta/15.png',
    'assets/sigorta/16.png',
    'assets/sigorta/17.png',
    'assets/sigorta/18.png',
    'assets/sigorta/19.png',
  ];

  double _scrollPosition = 0;
  bool _isAnimating = true;
  bool _isAutoScrollRunning = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    if (!mounted || _isAutoScrollRunning) return;
    _isAutoScrollRunning = true;

    Future.doWhile(() async {
      if (!mounted || !_isAnimating) return false;

      await Future.delayed(const Duration(milliseconds: 30));

      if (!mounted || !_scrollController.hasClients) return false;

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (!maxScroll.isFinite || maxScroll <= 0) return true;

      _scrollPosition += 0.5;

      if (_scrollPosition >= maxScroll) {
        _scrollPosition = 0;
      }

      final target = _scrollPosition.clamp(0.0, maxScroll);
      if (target.isFinite) {
        _scrollController.jumpTo(target);
      }
      return true;
    }).whenComplete(() {
      _isAutoScrollRunning = false;
    });
  }

  @override
  void dispose() {
    _isAnimating = false;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _isAnimating = false;
          } else if (notification is ScrollEndNotification) {
            _scrollPosition = _scrollController.offset;
            _isAnimating = true;
            _startAutoScroll();
          }
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: _logos.length * 100,
          itemBuilder: (context, index) {
            final logo = _logos[index % _logos.length];
            return Container(
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Center(
                child: Image.asset(
                  logo,
                  height: 55,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
