import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_path.dart';
import 'package:dynamische_materialdatenbank/features/sort/models/sort_direction.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sortDirectionProvider = StateProvider((ref) => SortDirection.ascending);

final sortAttributeProvider = StateProvider<AttributePath?>((ref) => null);
