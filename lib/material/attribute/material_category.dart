import 'dart:ui' show Color;

enum MaterialCategory {
  minerals,
  metals,
  woods,
  plantsAndAnimals,
  plastics,
  textiles,
}

extension MaterialCategoryExtension on MaterialCategory {
  String get label => switch (this) {
    MaterialCategory.minerals => 'Mineralien',
    MaterialCategory.metals => 'Metalle',
    MaterialCategory.woods => 'Hölzer',
    MaterialCategory.plantsAndAnimals => 'Pflanzen & Tiere',
    MaterialCategory.plastics => 'Kunststoffe',
    MaterialCategory.textiles => 'Textilien',
  };

  Color get color => switch (this) {
    MaterialCategory.minerals => Color(0xff8EBC62),
    MaterialCategory.metals => Color(0xffad3761),
    MaterialCategory.woods => Color(0xff769B7B),
    MaterialCategory.plantsAndAnimals => Color(0xffF8DE82),
    MaterialCategory.plastics => Color(0xff4c6391),
    MaterialCategory.textiles => Color(0xffbdb5f1),
  };
}
