import 'package:flutter/material.dart';
import 'dart:io';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the item data passed as arguments
    final item = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    // Handle cases where arguments might be null (though ideally shouldn't happen)
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Erro")),
        body: const Center(child: Text("Item não encontrado.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item['title'] ?? 'Detalhes do Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            Center(
              child: item['imageUrl'] != null
                  ? Image.file(
                      File(item['imageUrl']),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image, size: 100, color: Colors.grey)),
                      ),
                    )
                  : Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.image_not_supported, size: 100, color: Colors.grey)),
                    ),
            ),
            const SizedBox(height: 20),

            // Item Title
            Text(
              item['title'] ?? 'Título Indisponível',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Item Description
            Text(
              item['description'] ?? 'Sem descrição.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            // Owner Information
            Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Oferecido por: ${item['owner'] ?? 'Desconhecido'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Negotiation Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Iniciar Negociação"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                onPressed: () {
                  // TODO: Pass necessary info (e.g., item ID, owner ID) to chat screen
                  Navigator.pushNamed(context, '/chat', arguments: {'otherUserName': item['owner'] ?? 'Usuário'});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
