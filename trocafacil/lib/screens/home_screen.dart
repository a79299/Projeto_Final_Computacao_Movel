import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'add_item_screen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Modelo para representar um item
class Item {
  final String title;
  final String description;
  final String imageUrl;
  final String owner;
  final DateTime createdAt;

  Item({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.owner,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'owner': owner,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      owner: map['owner'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}

// Lista de itens de exemplo
final List<Item> _sampleItems = [
  Item(
    title: 'Livro Usado - Ficção Científica',
    description: 'Em bom estado, lido apenas uma vez.',
    imageUrl: 'assets/images/book.jpg',
    owner: 'Ana Silva',
  ),
  Item(
    title: 'Jogo de Tabuleiro - Estratégia',
    description: 'Completo, com todas as peças.',
    imageUrl: 'assets/images/board_game.jpg',
    owner: 'Bruno Costa',
  ),
  Item(
    title: 'Fone de Ouvido Bluetooth',
    description: 'Pouco uso, funcionando perfeitamente.',
    imageUrl: 'assets/images/headphone.jpg',
    owner: 'Carla Dias',
  ),
];


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  // Lista para armazenar os itens do usuário
  static List<Item> _userItems = [];

  // Define screen widgets directly for clarity
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const ExploreItemsScreen(),
      MyItemsScreen(
        items: _userItems,
        onDeleteItem: _deleteItem,
        onEditItem: _editItem,
      ),
      const ProfileScreen(),
    ];
  }

  // Método para excluir um item
  void _deleteItem(int index) {
    setState(() {
      _userItems.removeAt(index);
      // Atualiza a tela de itens do usuário
      _screens[1] = MyItemsScreen(
        items: _userItems,
        onDeleteItem: _deleteItem,
        onEditItem: _editItem,
      );
    });
  }

  // Método para editar um item
  void _editItem(int index, Map<String, dynamic> updatedData) {
    setState(() {
      _userItems[index] = Item.fromMap(updatedData);
      // Atualiza a tela de itens do usuário
      _screens[1] = MyItemsScreen(
        items: _userItems,
        onDeleteItem: _deleteItem,
        onEditItem: _editItem,
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para adicionar novo item
  void _addNewItem(Map<String, dynamic> itemData) {
    final newItem = Item.fromMap(itemData);
    setState(() {
      _userItems.add(newItem);
      // Atualiza a tela de itens do usuário
      _screens[1] = MyItemsScreen(
        items: _userItems,
        onDeleteItem: _deleteItem,
        onEditItem: _editItem,
      );
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
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(
                      onItemAdded: (Map<String, dynamic> newItem) {
                        _addNewItem(newItem);
                      },
                    ),
                  ),
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
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.asset(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.description),
                const SizedBox(height: 4),
                Text(
                  'Oferecido por: ${item.owner}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/item_detail', arguments: item.toMap());
            },
          ),
        );
      },
    );
  }
}

class MyItemsScreen extends StatelessWidget {
  final List<Item> items;
  final Function(int) onDeleteItem;
  final Function(int, Map<String, dynamic>) onEditItem;

  const MyItemsScreen({
    super.key,
    required this.items,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "Você ainda não tem itens cadastrados.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Toque no botão + para adicionar um item.",
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: item.imageUrl.startsWith('assets/')
                        ? Image.asset(
                            item.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildErrorImage(),
                          )
                        : Image.file(
                            File(item.imageUrl),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildErrorImage(),
                          ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item.description),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) async {
                      if (value == 'delete') {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: const Text('Tem certeza que deseja excluir este item?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        );
                        if (shouldDelete == true) {
                          onDeleteItem(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item excluído com sucesso')),
                          );
                        }
                      } else if (value == 'edit') {
                        final currentItem = items[index];
                        final titleController = TextEditingController(text: currentItem.title);
                        final descriptionController = TextEditingController(text: currentItem.description);
                        String? newImagePath = currentItem.imageUrl;

                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Editar Item'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration: const InputDecoration(labelText: 'Título'),
                                  ),
                                  TextField(
                                    controller: descriptionController,
                                    decoration: const InputDecoration(labelText: 'Descrição'),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                      if (image != null) {
                                        newImagePath = image.path;
                                      }
                                    },
                                    child: const Text('Alterar Imagem'),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Salvar'),
                              ),
                            ],
                          ),
                        );

                        if (result == true) {
                          final updatedData = {
                            'title': titleController.text,
                            'description': descriptionController.text,
                            'imageUrl': newImagePath,
                            'owner': currentItem.owner,
                          };
                          onEditItem(index, updatedData);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item atualizado com sucesso')),
                          );
                        }

                        titleController.dispose();
                        descriptionController.dispose();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20),
                            SizedBox(width: 8),
                            Text('Excluir'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/item_detail', arguments: item.toMap());
                  },
                ),
              );
            },
          );
  }

  Widget _buildErrorImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}

