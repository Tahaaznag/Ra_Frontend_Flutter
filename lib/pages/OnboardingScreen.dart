import 'package:flutter/material.dart';
import 'package:remote_assist/pages/WelcomePage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      OnboardingPage(
        image: 'lib/icons/images/image1.png',
        title: 'Bienvenue dans BL Remote Assist',
        description: 'Découvrez comment BL Remote Assist révolutionne l\'assistance à distance avec des services de vidéoconférence et de chat pour organiser vos tâches et rendez-vous efficacement.',
      ),
      OnboardingPage(
        image: 'lib/icons/images/image2.png',
        title: 'Accédez aux Meilleurs Spécialistes',
        description: 'Trouvez et consultez les meilleurs spécialistes en un seul endroit, prêts à vous assister via des appels vidéo et des messages instantanés.',
      ),
      OnboardingPage(
        image: 'lib/icons/images/RA.png',
        title: 'Commencez Votre Expérience',
        description: 'Évitez les files d\'attente et planifiez vos rendez-vous rapidement grâce à notre application intuitive, offrant assistance par vidéo et chat en temps réel.',
        lastPage: true,
      ),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _pages[index];
            },
          ),
          Positioned(
            bottom: 100.0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: WormEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                  ),
                ),
                SizedBox(height: 16.0),
                if (_currentPage != _pages.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _pages.length - 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      'Passer',
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 100.0,
            right: 100.0,
            child: _currentPage == _pages.length - 1
                ? ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: Text('Commencer'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool lastPage;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    this.lastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          SizedBox(height: 32.0),
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
