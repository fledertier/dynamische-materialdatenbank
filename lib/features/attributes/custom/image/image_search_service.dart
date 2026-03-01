import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dynamische_materialdatenbank/features/attributes/custom/image/image_search_result.dart';
import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageSearchServiceProvider = Provider((ref) => ImageSearchService());

class ImageSearchService {
  Future<ImageSearchResult?> searchImages(String query) async {
    final result = await FirebaseFunctions.instanceFor(
      region: region,
    ).httpsCallable(Functions.search).call({'query': query});
    final json = result.data as Json?;
    if (json == null) {
      return null;
    }
    return ImageSearchResult.fromJson(json);
  }
}
