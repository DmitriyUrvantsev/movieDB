import 'package:flutter/material.dart';
import 'package:movie_db_hard/domain/data_providers/session_data_provider.dart';
import '../../../domain/api_client/api_client.dart';
import 'main_screen_model.dart';
import 'movi_screen.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({super.key});

  @override
  State<MainScreenWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  final movieScreenModel = MovieScreenModel();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      if (index == _selectedIndex) {
        return;
      }
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    movieScreenModel.setupLocale(context);
    //установка локали + загрузка фильмов.
  }

  @override
  Widget build(BuildContext context) {
    const text = 'Movies';
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text(text)),
        actions: [
          IconButton(
              onPressed: () => SessionDataProvider().setSessionId(
                  null), //!временная болванка, для удаления авторизации
              icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: IndexedStack(
        // !!!!!! ВАЖНО!!!!! --IndexStack держит в памяти эти виджеты и
        // !!!!ребилд не происходит
        index: _selectedIndex,
        children: [
          MovieScreenModelProvider(
              model: movieScreenModel, child: const MovieWidget()),
          Image.network(
            ApiClient.imageUrl(
                'https://image.tmdb.org/t/p/w500/mOX5O6JjCUWtlYp5D8wajuQRVgy.jpg'),
            width: 95,
          ),
          const Text(
            'Index 2: School',
            style: optionStyle,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_outlined),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
