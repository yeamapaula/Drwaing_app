import 'package:flutter/material.dart';
import 'drawing_screen.dart';
import 'saved_drawings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drawing App')),
       body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/yeama.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  'Welcome to My Drawing App:)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Hello user I am YEAMA PAULA KOROMA",
                  
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 9),
                Text("Computer Sceience Student Year 3",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                
                SizedBox(height: 9),
                Text("ID: 22/CS/TEH/087",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),

Divider(height: 10,),

ElevatedButton.icon(
              icon: const Icon(Icons.brush),
              label: const Text('Start Drawing'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DrawingScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.photo_library),
              label: const Text('View Saved Drawings'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SavedDrawingsScreen()),
                );
              },
            ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}





