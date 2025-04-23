import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Usuário';
  String _email = '';
  String _imageUrl = '';
  int _age = 0;
  DateTime _joinDate = DateTime.now();
  int _totalTrades = 0;
  List<Map<String, dynamic>> _tradeHistory = [
    {
      'productImage': 'https://via.placeholder.com/150',
      'productName': 'Exemplo de Produto',
      'chatHistory': ['Olá, tenho interesse no seu produto', 'Podemos combinar a troca?'],
      'date': '2024-01-20',
    }
  ];
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _emailController.text = _email;
    _ageController.text = _age.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isEditing ? _buildEditForm() : _buildProfile(),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Center(
      child: Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _imageUrl.isNotEmpty
              ? NetworkImage(_imageUrl)
              : null,
          child: _imageUrl.isEmpty
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          _name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Idade: $_age anos',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Email: $_email',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Membro desde: ${_joinDate.day}/${_joinDate.month}/${_joinDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _tradeHistory.map((trade) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(
                              trade['productImage'],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              trade['productName'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Text('Chat:'),
                            ...trade['chatHistory'].map((msg) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(msg),
                            )),
                            Text('Data: ${trade['date']}'),
                          ],
                        ),
                      ),
                    )).toList(),
                  ),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Total de trocas: $_totalTrades',
              style: const TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                  _nameController.text = _name;
                  _emailController.text = _email;
                  _ageController.text = _age.toString();
                });
              },
              child: const Text('Editar Perfil'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implementar lógica de exclusão de perfil
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar Exclusão'),
                    content: const Text('Tem certeza que deseja excluir seu perfil? Esta ação não pode ser desfeita.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO: Implementar lógica de exclusão
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                        child: const Text('Excluir'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Excluir Perfil'),
            ),
          ],
        ),
      ],
    ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              
              if (image != null) {
                setState(() {
                  _imageUrl = image.path;
                });
              }
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _imageUrl.isNotEmpty
                  ? NetworkImage(_imageUrl)
                  : null,
              child: _imageUrl.isEmpty
                  ? const Icon(Icons.add_a_photo, size: 30)
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Por favor, insira um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Idade',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua idade';
              }
              final age = int.tryParse(value);
              if (age == null || age < 0 || age > 120) {
                return 'Por favor, insira uma idade válida';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _name = _nameController.text;
                      _email = _emailController.text;
                      _age = int.parse(_ageController.text);
                      _isEditing = false;
                    });
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}