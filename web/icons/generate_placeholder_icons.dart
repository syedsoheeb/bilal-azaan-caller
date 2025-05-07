import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

void main() {
  final sizes = [192, 512];
  final colors = ['4CAF50', '2E7D32'];
  
  for (final size in sizes) {
    for (var i = 0; i < 2; i++) {
      final masked = i == 1;
      final filename = masked ? 'Icon-maskable-$size.png' : 'Icon-$size.png';
      // For this simple script, just create a colored square
      // In a real app, you'd generate proper icons
      createPlaceholderIcon(filename, size, colors[i % colors.length]);
    }
  }
  
  // Create favicon
  createPlaceholderIcon('favicon.png', 32, '4CAF50');
}

void createPlaceholderIcon(String filename, int size, String colorHex) {
  // Create a simple file with a note
  final file = File('web/icons/$filename');
  file.writeAsStringSync('Placeholder for $filename\nSize: ${size}x$size\nColor: #$colorHex');
  print('Created placeholder for $filename');
}
