import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_item_screen.dart';

// Placeholder data for items
final List<Map<String, dynamic>> _sampleItems = [
  {
    'title': 'Livro Usado - Ficção Científica',
    'description': 'Em bom estado, lido apenas uma vez.',
    'imageUrl': 'https://via.placeholder.com/150/771796',
    'owner': 'Ana Silva'
  },
  {
    'title': 'Jogo de Tabuleiro - Estratégia',
    'description': 'Completo, com todas as peças.',
    'imageUrl': 'https://via.placeholder.com/150/24f355',
    'owner': 'Bruno Costa'
  },
  {
    'title': 'Fone de Ouvido Bluetooth',
    'description': 'Pouco uso, funcionando perfeitamente.',
    'imageUrl': 'https://via.placeholder.com/150/d32776',
    'owner': 'Carla Dias'
  },
  {
    'title': 'Vaso Decorativo de Cerâmica',
    'description': 'Ideal para plantas pequenas.',
    'imageUrl': 'https://via.placeholder.com/150/f66b97',
    'owner': 'Daniel Alves'
  },
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Define screen widgets directly for clarity
  final List<Widget> _screens = [
    const ExploreItemsScreen(), // Screen for exploring items
    const MyItemsScreen(),      // Screen for user's items
    const ProfileScreen(),      // Screen for user profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TrocaFácil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              print("Search button pressed");
            },
          ),
        ],
      ),
      body: IndexedStack( // Use IndexedStack to keep state of screens
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Meus Itens"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
      floatingActionButton: _selectedIndex == 1 // Show FAB only on 'Meus Itens' tab
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddItemScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// --- Screen Widgets --- //

class ExploreItemsScreen extends StatelessWidget {
  const ExploreItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _sampleItems.length,
      itemBuilder: (context, index) {
        final item = _sampleItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Image.network(
              item['imageUrl'],
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50), // Placeholder on error
            ),
            title: Text(item['title']),
            subtitle: Text(item['description']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/item_detail', arguments: item);
            },
          ),
        );
      },
    );
  }
}

class MyItemsScreen extends StatelessWidget {
  const MyItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch and display user's items
    return const Center(child: Text("Aqui aparecerão os seus itens cadastrados."));
  }
}

