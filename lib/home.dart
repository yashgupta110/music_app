import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/widgets/navbar.dart';
import 'package:demo/musify/musify.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class HomeScreen extends ConsumerStatefulWidget {
  final oauth2.Client client;

  const HomeScreen({required this.client, super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentPage = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      Musify(widget.client),
      const Navbar(),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _currentPage == 0
                  ? [Colors.green[800]!, Colors.black]
                  : [Colors.red[800]!, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _onPageChanged(0),
                label: Text(
                  'Musify',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _currentPage == 0 ? Colors.white : Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    _currentPage == 0 ? Colors.green[800] : Theme.of(context).colorScheme.onSecondary,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    _currentPage == 0 ? Colors.white : Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _onPageChanged(1),
                label: Text(
                  'YTmusic',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _currentPage == 1 ? Colors.white : Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  backgroundColor: MaterialStatePropertyAll(
                    _currentPage == 1 ? Colors.red[800] : Theme.of(context).colorScheme.onSecondary,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                    _currentPage == 1 ? Colors.white : Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_currentPage],
    );
  }
}
