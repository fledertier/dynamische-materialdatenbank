import 'package:dynamische_materialdatenbank/material/attribute/custom/density/density_visualization.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DensityPlayground()));
}

class DensityPlayground extends StatefulWidget {
  const DensityPlayground({super.key});

  @override
  State<DensityPlayground> createState() => _DensityPlaygroundState();
}

class _DensityPlaygroundState extends State<DensityPlayground> {
  double density = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Density: ${density.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: 200,
            height: 200,
            child: DensityVisualization(
              density: density,
              isThreeDimensional: true,
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Slider(
              value: density,
              min: 0,
              max: 1,
              onChanged: (value) => setState(() => density = value),
            ),
          ),
        ],
      ),
    );
  }
}
