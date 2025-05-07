import '../../../types.dart';
import '../composition/proportion.dart';

class Component extends Proportion {
  const Component({
    required this.id,
    required super.nameDe,
    required super.nameEn,
    required super.share,
  });

  final String id;

  factory Component.fromJson(Json json) {
    return Component(
      id: json['id'],
      nameDe: json['nameDe'],
      nameEn: json['nameEn'],
      share: json['share'],
    );
  }

  Json toJson() {
    return {'id': id, 'nameDe': nameDe, 'nameEn': nameEn, 'share': share};
  }

  @override
  int get hashCode {
    return Object.hash(id, nameDe, nameEn, share);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Component) return false;

    return id == other.id &&
        nameDe == other.nameDe &&
        nameEn == other.nameEn &&
        share == other.share;
  }
}
