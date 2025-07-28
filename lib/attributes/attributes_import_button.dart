// ignore_for_file: prefer_single_quotes

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamische_materialdatenbank/constants.dart';
import 'package:dynamische_materialdatenbank/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttributesImportButton extends ConsumerWidget {
  const AttributesImportButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.upload_outlined),
      label: Text('Import'),
      onPressed: () async {
        await importAttributes(ref);
        await importColors(ref);
        await importMaterials(ref);
      },
    );
  }

  Future<void> importAttributes(WidgetRef ref) async {
    await ref
        .read(firestoreProvider)
        .collection(Collections.attributes)
        .doc(Docs.attributes)
        .set(_attributes);
  }

  Future<void> importMaterials(WidgetRef ref) async {
    for (final material in _materials) {
      final id = material['id'] as String;
      await ref
          .read(firestoreProvider)
          .collection(Collections.materials)
          .doc(id)
          .set({Attributes.id: id, ...material}, SetOptions(merge: true));

      for (final attribute in material.keys) {
        await ref
            .read(firestoreProvider)
            .collection(Collections.values)
            .doc(attribute)
            .set({id: material[attribute]}, SetOptions(merge: true));
      }
    }
  }

  Future<void> importColors(WidgetRef ref) async {
    await ref
        .read(firestoreProvider)
        .collection(Collections.colors)
        .doc(Docs.materials)
        .set(_colors);
  }
}

const _attributes = {
  "u-value": {
    "nameDe": "U-Wert",
    "nameEn": "U-value",
    "type": {"unitType": "uValue", "id": "number"},
    "required": false,
    "id": "u-value",
  },
  "0197c15a-3f4e-7ee4-9bd7-2d9288244074": {
    "nameDe": "Bilder",
    "id": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
    "type": {
      "id": "list",
      "attribute": {
        "nameDe": "Bild",
        "required": false,
        "nameEn": "Image",
        "id": "0197c15a-3f4d-7587-b7d6-7c985932bec2",
        "type": {
          "attributes": [
            {
              "nameEn": "",
              "required": false,
              "id": "0197c159-299d-791e-9527-1bd445e2401e",
              "nameDe": "Link",
              "type": {"id": "text", "multiline": false},
            },
            {
              "type": {"id": "text", "multiline": false},
              "nameEn": "",
              "nameDe": "Thumbnail Link",
              "id": "0197c159-7074-7813-ae3b-d8ccc98ee7c2",
              "required": false,
            },
          ],
          "id": "object",
        },
      },
    },
    "nameEn": "Images",
    "required": false,
  },
  "01973a53-3ad6-7e35-b596-3fb50f93cf96": {
    "type": {
      "id": "list",
      "attribute": {
        "type": {
          "id": "object",
          "attributes": [
            {
              "nameEn": null,
              "required": true,
              "type": {"multiline": false, "id": "text", "translatable": true},
              "id": "01973a53-3ad5-7a63-a6fd-d238fa571298",
              "nameDe": "Name",
            },
            {
              "required": true,
              "nameDe": "Anzahl",
              "nameEn": "Count",
              "id": "01973a53-c53f-7ea3-a53f-3d21fffb2ca3",
              "type": {"id": "number", "unitType": null},
            },
          ],
        },
        "id": "01973a53-3ad6-7dc7-a930-eb99b999fe0c",
        "nameEn": null,
        "nameDe": null,
        "required": false,
      },
    },
    "nameDe": "Subjektive Eindrücke",
    "nameEn": "Subjective Impressions",
    "required": false,
    "id": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
  },
  "light reflection": {
    "nameEn": "Light reflection",
    "nameDe": "Lichtreflexion",
    "id": "light reflection",
    "type": {"id": "number", "unitType": "proportion"},
    "required": false,
  },
  "0197c655-720a-795d-9d1b-8b2bc5fa2fe7": {
    "nameEn": null,
    "id": "0197c655-720a-795d-9d1b-8b2bc5fa2fe7",
    "nameDe": "Einsatzgebiet",
    "required": false,
    "type": {"multiline": true, "id": "text", "translatable": true},
  },
  "light transmission": {
    "type": {"unitType": "proportion", "id": "number"},
    "nameEn": "Light transmission",
    "nameDe": "Lichtdurchlässigkeit",
    "required": false,
    "id": "light transmission",
  },
  "01973a84-5f56-71dc-9c18-dc25fc865b33": {
    "nameDe": "Herkunftsland",
    "required": false,
    "type": {
      "attribute": {
        "required": false,
        "nameDe": "Land",
        "id": "01973a84-5f55-714a-82a9-74b50c540259",
        "type": {"id": "text", "multiline": false},
        "nameEn": "Country",
      },
      "id": "list",
    },
    "id": "01973a84-5f56-71dc-9c18-dc25fc865b33",
    "nameEn": "Origin Country",
  },
  "01973a80-8ae1-75ed-ae14-c442187b3955": {
    "nameEn": "Composition",
    "id": "01973a80-8ae1-75ed-ae14-c442187b3955",
    "required": false,
    "type": {
      "id": "list",
      "attribute": {
        "nameDe": "Element",
        "required": false,
        "id": "01973a80-8adf-7a80-b3da-ccf4dd29dfee",
        "type": {
          "id": "object",
          "attributes": [
            {
              "type": {"id": "text", "multiline": false},
              "id": "01973a7f-996f-7d2c-808c-facf1b23abed",
              "nameDe": "Kategorie",
              "nameEn": "Category",
              "required": true,
            },
            {
              "nameDe": "Anteil",
              "type": {"unitType": "proportion", "id": "number"},
              "required": true,
              "nameEn": "Share",
              "id": "01973a80-26ff-7bee-bbc8-c93911d3fa2c",
            },
          ],
        },
        "nameEn": null,
      },
    },
    "nameDe": "Komposition",
  },
  "areal density": {
    "required": false,
    "nameDe": "Flächendichte",
    "type": {"unitType": "arealDensity", "id": "number"},
    "nameEn": "Areal density",
    "id": "areal density",
  },
  "01970d18-7b4f-728e-bec4-11b9a51f07d7": {
    "type": {
      "id": "list",
      "attribute": {
        "nameDe": "Zahl",
        "id": "01970d21-58f6-7f17-8c2a-eac0f8a71b6e",
        "type": {"unitType": "mass", "id": "number"},
        "nameEn": null,
        "required": false,
      },
    },
    "nameDe": "Zahlen",
    "id": "01970d18-7b4f-728e-bec4-11b9a51f07d7",
    "nameEn": null,
    "required": false,
  },
  "light absorption": {
    "nameEn": "Light absorption",
    "type": {"id": "number", "unitType": "proportion"},
    "required": false,
    "id": "light absorption",
    "nameDe": "Lichtabsorption",
  },
  "01973a83-3199-7457-80c9-18fda49d92ec": {
    "nameEn": "Fire Behavior",
    "nameDe": "Brandverhalten",
    "required": false,
    "id": "01973a83-3199-7457-80c9-18fda49d92ec",
    "type": {"multiline": false, "id": "text"},
  },
  "0197c656-6875-7dd9-8ccb-b142aa2e68c4": {
    "type": {"id": "text", "multiline": true, "translatable": true},
    "nameDe": "Herstellung",
    "id": "0197c656-6875-7dd9-8ccb-b142aa2e68c4",
    "required": false,
    "nameEn": null,
  },
  "manufacturer": {
    "required": false,
    "nameDe": "Hersteller",
    "id": "manufacturer",
    "nameEn": "Manufacturer",
    "type": {
      "id": "object",
      "attributes": [
        {
          "nameDe": "Name",
          "nameEn": null,
          "required": true,
          "type": {"id": "text", "multiline": false},
          "id": "name-1",
        },
        {
          "id": "website",
          "nameEn": "Website",
          "nameDe": "Webseite",
          "type": {"id": "text"},
          "required": false,
        },
      ],
    },
  },
  "biodegradable": {
    "id": "biodegradable",
    "nameEn": "Biodegradable",
    "nameDe": "Biologisch abbaubar",
    "type": {"id": "boolean"},
    "required": false,
  },
  "w-value": {
    "nameEn": "W-value",
    "required": false,
    "id": "w-value",
    "type": {"unitType": "wValue", "id": "number"},
    "nameDe": "W-Wert",
  },
  "description": {
    "type": {"multiline": true, "id": "text", "translatable": true},
    "nameEn": "Description",
    "required": true,
    "id": "description",
    "nameDe": "Beschreibung",
  },
  "01971790-34c5-7941-be43-01bd558c20d8": {
    "nameEn": null,
    "id": "01971790-34c5-7941-be43-01bd558c20d8",
    "type": {
      "id": "list",
      "attribute": {
        "nameEn": null,
        "id": "01971790-34c0-7fc1-bfc7-8115276ebe65",
        "required": false,
        "nameDe": "Link",
        "type": {"id": "text", "multiline": true},
      },
    },
    "nameDe": "Links",
    "required": false,
  },
  "density": {
    "nameEn": "Density",
    "required": false,
    "id": "density",
    "type": {"id": "number", "unitType": "density"},
    "nameDe": "Dichte",
  },
  "name": {
    "id": "name",
    "nameEn": "Name",
    "required": true,
    "nameDe": "Name",
    "type": {"id": "text", "multiline": false, "translatable": true},
  },
  "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
    "type": {"multiline": false, "id": "text"},
    "nameEn": "",
    "id": "0197c1d4-79c9-7e48-8208-5b7fc09c51c9",
    "nameDe": "Hauptbild",
    "required": false,
  },
  "0197c5f8-9198-7574-a920-c38a2b27b62c": {
    "type": {"id": "text", "multiline": true, "translatable": true},
    "nameDe": "Bearbeitung",
    "nameEn": null,
    "required": false,
    "id": "0197c5f8-9198-7574-a920-c38a2b27b62c",
  },
  "biobased": {
    "nameDe": "Biobasiert",
    "type": {"id": "boolean"},
    "id": "biobased",
    "required": false,
    "nameEn": "Biobased",
  },
  "recyclable": {
    "id": "recyclable",
    "required": false,
    "type": {"id": "boolean"},
    "nameEn": "Recyclable",
    "nameDe": "Recycelbar",
  },
  "01973a81-f146-7f9b-97c1-97f8b393996a": {
    "nameEn": "Components",
    "nameDe": "Komponenten",
    "required": false,
    "id": "01973a81-f146-7f9b-97c1-97f8b393996a",
    "type": {
      "id": "list",
      "attribute": {
        "nameEn": "Component",
        "type": {
          "id": "object",
          "attributes": [
            {
              "type": {"id": "text", "multiline": false, "translatable": true},
              "id": "01973a81-5717-732f-99c0-97481e1954c5",
              "nameDe": "Name",
              "nameEn": "",
              "required": true,
            },
            {
              "type": {"unitType": "proportion", "id": "number"},
              "required": true,
              "nameEn": "Share",
              "nameDe": "Anteil",
              "id": "01973a81-b8b3-7214-b729-877d3d6cb394",
            },
          ],
        },
        "nameDe": "Komponente",
        "id": "01973a81-f145-782d-ab27-f1fdd28f4d83",
        "required": false,
      },
    },
  },
};

const _materials = [
  {
    "image": {
      "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
        "valueEn": null,
        "valueDe":
            "https://www.schott.com/-/media/project/onex/products/o/optical-glass/product-highlights/bottom-690x470.jpg?rev=f9e4c10db34e45e38b82dfa0b30a356f",
      },
      "0197c159-299d-791e-9527-1bd445e2401e": {
        "valueEn": null,
        "valueDe":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRgnLb36jaBig0zOPUhSOzYdPlXsNjvfh5RvMxTKvVgtLcrPIcNm71G8o&s",
      },
    },
    "density": {"displayUnit": null, "value": 234},
    "recyclable": {"value": false},
    "light absorption": {"displayUnit": null, "value": 0.7},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein hochreines, besonders gleichmäßig hergestelltes Glas mit präzise definierter Lichtbrechung. Es wird primär in Linsen, Prismen und anderen optischen Komponenten verwendet – z. B. in Kameras, Teleskopen oder Lasern.",
    },
    "light transmission": {"displayUnit": null, "value": 99.9},
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
        "valueEn": null,
        "valueDe":
            "https://hoyaoptics.com/wp-content/uploads/2019/10/optical_glass_5.jpg",
      },
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRgnLb36jaBig0zOPUhSOzYdPlXsNjvfh5RvMxTKvVgtLcrPIcNm71G8o&s",
      "0197c159-299d-791e-9527-1bd445e2401e": {
        "valueEn": null,
        "valueDe":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSP-SSQJtrkFGQeInJhDoS2BkoQInXBfRSnAbeXTAMhHcOsZ0CauZHvU0Y&s",
      },
    },
    "manufacturer": {
      "name-1": {"valueEn": null, "valueDe": "Manufacturer 0"},
    },
    "01973a83-3199-7457-80c9-18fda49d92ec": {
      "valueEn": null,
      "valueDe": "C-s1,d0",
    },
    "light reflection": {"displayUnit": null, "value": 2},
    "0197c656-6875-7dd9-8ccb-b142aa2e68c4": {
      "valueEn": null,
      "valueDe":
          "Optisches Glas besteht aus besonders reinen Rohstoffen (häufig Quarzsand, Boroxide, Alkali- und Erdalkalimetalle). Es wird unter kontrollierten Bedingungen geschmolzen, langsam abgekühlt und homogenisiert, um innere Spannungen und Unregelmäßigkeiten zu vermeiden. Je nach Anwendungszweck wird die Zusammensetzung genau angepasst, um gewünschte Brechungsindizes und Dispersionseigenschaften zu erreichen.",
    },
    "name": {"valueEn": null, "valueDe": "Optisches Glas"},
    "0197c655-720a-795d-9d1b-8b2bc5fa2fe7": {
      "valueEn": null,
      "valueDe":
          "Optisches Glas wird in Geräten eingesetzt, bei denen Licht gezielt gelenkt, gebrochen oder fokussiert werden muss – z. B. in Kameralinsen, Mikroskopen, Ferngläsern, Lasern oder Teleskopen. In der Architektur findet es selten direkt Verwendung, kommt aber bei Spezialverglasungen oder Lichtlenksystemen in High-End-Gebäuden (z. B. Museen, Labore) zum Einsatz.",
    },
    "id": "0197c06c-3fa0-75cc-af35-420b9bdd0d32",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {
              "attributeId": "01973a83-3199-7457-80c9-18fda49d92ec",
              "size": "large",
              "card": "textCard",
            },
            {"attributeId": "description", "size": "large", "card": "textCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "cards": [
            {"attributeId": "density", "size": "large", "card": "densityCard"},
            {
              "attributeId": "recyclable",
              "size": "large",
              "card": "booleanCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "0197c656-6875-7dd9-8ccb-b142aa2e68c4",
              "size": "large",
              "card": "textCard",
            },
            {
              "attributeId": "0197c655-720a-795d-9d1b-8b2bc5fa2fe7",
              "size": "large",
              "card": "textCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "light absorption",
              "size": "large",
              "card": "lightAbsorptionCard",
            },
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
          ],
          "nameDe": "",
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
              "card": "imageCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.schott.com/-/media/project/onex/products/o/optical-glass/product-highlights/bottom-690x470.jpg?rev=f9e4c10db34e45e38b82dfa0b30a356f",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRgnLb36jaBig0zOPUhSOzYdPlXsNjvfh5RvMxTKvVgtLcrPIcNm71G8o&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://hoyaoptics.com/wp-content/uploads/2019/10/optical_glass_5.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSP-SSQJtrkFGQeInJhDoS2BkoQInXBfRSnAbeXTAMhHcOsZ0CauZHvU0Y&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.hoyaoptics.eu/wp-content/uploads/2021/05/Material_20210111.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRgXGs8jrTYgnUcVvewEGpi8PSGmthWAcIl5abk1wTUzymn7Ud0sUwTC4&s",
        },
      },
    ],
  },
  {
    "u-value": {"displayUnit": null, "value": 0.5},
    "w-value": {"displayUnit": null, "value": 6.2},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Bauschaum"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein metamorphes Gestein, das hauptsächlich aus Serpentinmineralen besteht. Es wurde früher z. B. als Naturstein für Fassaden oder Bodenplatten verwendet – sieht ein bisschen aus wie Marmor, aber in grünlich-schwarzen Tönen.",
    },
    "id": "0197c085-3521-79ea-b3f1-a3f234f42485",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {"attributeId": "u-value", "size": "large", "card": "uValueCard"},
            {"attributeId": "w-value", "size": "large", "card": "wValueCard"},
            {
              "attributeId": "01971790-34c5-7941-be43-01bd558c20d8",
              "size": "large",
              "card": "listCard",
            },
            {
              "attributeId": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
              "size": "large",
              "card": "subjectiveImpressionsCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameDe": "Bestandteile",
          "nameEn": null,
        },
      ],
    },
    "01971790-34c5-7941-be43-01bd558c20d8": [
      {"valueDe": "https://www.obi.de/search/bauschaum/"},
      {
        "valueDe":
            "https://www.hornbach.de/p/soudal-pistolenschaum-b2-beige-750-ml/259609/",
      },
    ],
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "woods",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 40,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "plastics",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "minerals",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 58,
          "displayUnit": null,
        },
      },
    ],
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "id": "2345",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Schwedische Fichte",
          "valueEn": "Wood Swedish fir",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 31,
          "displayUnit": null,
        },
      },
      {
        "id": "3456",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Wasser",
          "valueEn": "Water",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 12,
          "displayUnit": null,
        },
      },
      {
        "id": "4567",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Kalksteinmehl",
          "valueEn": "Limestone powder",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 9,
          "displayUnit": null,
        },
      },
      {
        "id": "5678",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Farbe, wasserbasiert",
          "valueEn": "Paint, water based",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "id": "1234",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Portlandzement",
          "valueEn": "Portland cement",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 44,
          "displayUnit": null,
        },
      },
    ],
    "01973a53-3ad6-7e35-b596-3fb50f93cf96": [
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "rau",
          "valueEn": "rough",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 4,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "kalt",
          "valueEn": "cold",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "warm",
          "valueEn": "warm",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 3,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "weich",
          "valueEn": "soft",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "hart",
          "valueEn": "hard",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "glatt",
          "valueEn": "smooth",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "density": {"displayUnit": null, "value": 510},
    "areal density": {"displayUnit": null, "value": 742},
    "light absorption": {"displayUnit": null, "value": 24},
    "description": {
      "valueEn": "",
      "valueDe":
          "BAUX Acoustic Wood Wool is a functional, natural material made from two of the world’s oldest building materials, \nwood and cement. The combination is simple and ingenious. Wood fiber offers excellent insulation, heat retention \nand sound absorption. Cement, a proven and popular building material, is the binder that provides strength, \nmoisture resistance and fire protection. Therefore, BAUX acoustic products are versatile and durable in all \nclimates",
    },
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "DE"},
      {"valueDe": "FR"},
    ],
    "light transmission": {"displayUnit": null, "value": 32},
    "manufacturer": {
      "name-1": {"valueEn": null, "valueDe": "Baux"},
      "website": {"valueDe": "https://www.baux.com"},
    },
    "01973a83-3199-7457-80c9-18fda49d92ec": {
      "valueEn": null,
      "valueDe": "A1-s1,d0",
    },
    "light reflection": {"displayUnit": null, "value": 17},
    "biobased": {"value": true},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Holzwolle"},
    "id": "0197c08a-4ef1-7dac-ac94-3fc5e94bcb18",
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "manufacturer",
              "size": "large",
              "card": "objectCard",
            },
            {
              "attributeId": "01973a83-3199-7457-80c9-18fda49d92ec",
              "size": "large",
              "card": "textCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": "Lichteinfluss",
          "cards": [
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
            {
              "attributeId": "light absorption",
              "size": "large",
              "card": "lightAbsorptionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
              "size": "large",
              "card": "subjectiveImpressionsCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "originCountryCard",
            },
          ],
          "nameEn": null,
        },
        {
          "cards": [
            {"attributeId": "density", "size": "large", "card": "densityCard"},
            {
              "attributeId": "areal density",
              "size": "large",
              "card": "arealDensityCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "woods",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 40,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "plastics",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "minerals",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 58,
          "displayUnit": null,
        },
      },
    ],
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "id": "2345",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Schwedische Fichte",
          "valueEn": "Wood Swedish fir",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 31,
          "displayUnit": null,
        },
      },
      {
        "id": "3456",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Wasser",
          "valueEn": "Water",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 12,
          "displayUnit": null,
        },
      },
      {
        "id": "4567",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Kalksteinmehl",
          "valueEn": "Limestone powder",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 9,
          "displayUnit": null,
        },
      },
      {
        "id": "5678",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Farbe, wasserbasiert",
          "valueEn": "Paint, water based",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "id": "1234",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Portlandzement",
          "valueEn": "Portland cement",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 44,
          "displayUnit": null,
        },
      },
    ],
    "01973a53-3ad6-7e35-b596-3fb50f93cf96": [
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "rau",
          "valueEn": "rough",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 4,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "kalt",
          "valueEn": "cold",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "warm",
          "valueEn": "warm",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 3,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "weich",
          "valueEn": "soft",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "hart",
          "valueEn": "hard",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "glatt",
          "valueEn": "smooth",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "density": {"displayUnit": null, "value": 604},
    "areal density": {"displayUnit": null, "value": 342},
    "light absorption": {"displayUnit": null, "value": 54},
    "w-value": {"displayUnit": null, "value": 9.3},
    "description": {
      "valueEn": null,
      "valueDe":
          "Blähton ist ein leichter, poröser Baustoff aus gebranntem Ton. Durch das Erhitzen auf über 1000 °C blähen sich die Tonkügelchen auf und bekommen eine harte Außenschale mit einem luftgefüllten Inneren. Blähton ist druckfest, wärme- und schalldämmend sowie feuchtigkeitsbeständig. Er wird unter anderem in Leichtbeton, als Schüttung zur Dämmung und im Gartenbau als Pflanzsubstrat eingesetzt.",
    },
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "DZ"},
      {"valueDe": "AL"},
    ],
    "light transmission": {"displayUnit": null, "value": 0},
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQNubRaA2i2OaTcidlQsXAF6fQyC7cjMOXgV0MkY98tH9AGV8Dqq5XFOWA&s",
    },
    "light reflection": {"displayUnit": null, "value": 27},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Blähton"},
    "0197c655-720a-795d-9d1b-8b2bc5fa2fe7": {
      "valueEn": null,
      "valueDe":
          "Blähton wird vielseitig im Hoch- und Tiefbau sowie im Garten- und Landschaftsbau eingesetzt. Im Bauwesen dient er als Zuschlagstoff für Leichtbeton, als wärme- und schalldämmende Schüttung in Decken, Böden oder Hohlräumen sowie zur Drainage",
    },
    "id": "0197c236-95d2-7b6d-bea3-69adbfa5f52b",
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "originCountryCard",
            },
            {"attributeId": "density", "size": "large", "card": "densityCard"},
          ],
          "nameEn": null,
        },
        {
          "nameDe": "Lichteinfluss",
          "cards": [
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
            {
              "attributeId": "light absorption",
              "size": "large",
              "card": "lightAbsorptionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "0197c655-720a-795d-9d1b-8b2bc5fa2fe7",
              "size": "large",
              "card": "textCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
              "card": "imageCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a83-3199-7457-80c9-18fda49d92ec",
              "size": "large",
              "card": "fireBehaviorStandardCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://m.media-amazon.com/images/I/71d08Djc3aL._UF894,1000_QL80_.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQNubRaA2i2OaTcidlQsXAF6fQyC7cjMOXgV0MkY98tH9AGV8Dqq5XFOWA&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://upload.wikimedia.org/wikipedia/commons/f/f5/Hydroton.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSm6YdF2HOirx17Q64Dgldlgpa4oLd37f9pYQOMcSke7c2hkKv13x2k8Q&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.gardens4you.eu/media/catalog/product/cache/3a7af0a8e0e317723249dc9098669163/f/d/fd18726wh.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDBdM6EO4zsEDtp9GWVPLuD2-L1_RincbntqWCKcN7Iko7qC_UIUepI6GX&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://m.media-amazon.com/images/I/81QvdzOop5L._UF1000,1000_QL80_.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQz1Vqy2JbioK5AE18RKuZSz_EY6REaoL1DLPblVS6Y4-Udl_JcUNiFJq4&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://climagruen.com/wp-content/uploads/elementor/thumbs/Schuettgut-Blaehton-CG-BT-5-12-qzua46j8pfy0lvannopmtzx5qchxuv3wf96kr9z14w.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKjMIj_GXCUfAag2lxw4Z2-rSCC8vvysAQNBf4w32uPT4zVmjOI_1BrA&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.biolaboratorium.com/cdn/shop/files/0782384986005c8b12fa15b8c6275191_1200x.jpg?v=1745325172",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNUEcsMN6tAfzClqOeFp7qFc1WrcI36j76XvPU2PPT28xOFuo7X82gwJ3r&s",
        },
      },
    ],
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "minerals",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 58,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "plastics",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "woods",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 40,
          "displayUnit": null,
        },
      },
    ],
    "01973a83-3199-7457-80c9-18fda49d92ec": {
      "valueEn": null,
      "valueDe": "B-s2,d1",
    },
  },
  {
    "light reflection": {"displayUnit": null, "value": 1.7},
    "light absorption": {"displayUnit": null, "value": 0.3},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Schaumglas"},
    "0197c655-720a-795d-9d1b-8b2bc5fa2fe7": {
      "valueEn": null,
      "valueDe":
          "Schaumglas wird vor allem als Dämmstoff eingesetzt – überall dort, wo hohe Druckfestigkeit, Feuchtebeständigkeit und Nichtbrennbarkeit gefragt sind.",
    },
    "description": {
      "valueEn": null,
      "valueDe":
          "Schaumglas ist ein leichter, dämmender Baustoff aus recyceltem Glas. Bei der Herstellung wird Glaspulver mit einem Treibmittel erhitzt, wodurch sich Gasbläschen bilden und das Material aufschäumt. Das Ergebnis ist ein festes, geschlossenporiges Glas mit sehr guter Wärmedämmung. Schaumglas ist druckfest, wasser- und dampfdicht sowie nicht brennbar.",
    },
    "id": "0197c5ec-9056-7b0a-baaf-d4ee9e3f7e8a",
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
            {
              "attributeId": "light absorption",
              "size": "large",
              "card": "lightAbsorptionCard",
            },
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "0197c655-720a-795d-9d1b-8b2bc5fa2fe7",
              "size": "large",
              "card": "textCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
              "card": "imageCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
              "size": "large",
              "card": "subjectiveImpressionsCard",
            },
            {
              "attributeId": "01973a83-3199-7457-80c9-18fda49d92ec",
              "size": "large",
              "card": "fireBehaviorStandardCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
    },
    "light transmission": {"displayUnit": null, "value": 43},
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.foamglas.com/-/media/project/foamglas/public/corporate/foamglascom/images/advice/general/cellular-glass-and-production/zoom-fg-slab-corner.jpg?h=300&iar=0&w=500&hash=66B1A6C569A3FAFFE1BCE44DCEE5446F",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPFv9Bqdeakn__bJ6bD-xjuC_1XRCAkb5KB-SHVgmhcn0v_fwM8CuKXZ8&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://image.invaluable.com/housePhotos/schwab/00/709400/H18949-L267058715.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRD7fgpilHieyfRBaVccJ4aTSkFyAI3CzQZvq5dyckE18Ey6D-ULHgTML0b&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://upload.wikimedia.org/wikipedia/commons/7/7f/Foamglas.JPG",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3I_OcdCk-iaQ2wJCJJ_otRPmDNQoiFYwEq55QnQuUzEl0zUfsfb8DLxM&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://image.invaluable.com/housePhotos/schwab/52/731952/H18949-L303098779.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSD4mcXTjmVJO_Bz_XhmWtsqSTJ3MJBK27zV6eHUPdG5xObve5X7AVw9zw&s",
        },
      },
    ],
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPFv9Bqdeakn__bJ6bD-xjuC_1XRCAkb5KB-SHVgmhcn0v_fwM8CuKXZ8&s",
    },
    "01973a83-3199-7457-80c9-18fda49d92ec": {
      "valueEn": null,
      "valueDe": "B-s2,d1",
    },
    "01973a53-3ad6-7e35-b596-3fb50f93cf96": [
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "glatt",
          "valueEn": "smooth",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "kalt",
          "valueEn": "cold",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "warm",
          "valueEn": "warm",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 3,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "weich",
          "valueEn": "soft",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "hart",
          "valueEn": "hard",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "rau",
          "valueEn": "rough",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 4,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "01973a83-3199-7457-80c9-18fda49d92ec": {
      "valueEn": null,
      "valueDe": "A2-s2,d0",
    },
    "light reflection": {"displayUnit": null, "value": 33},
    "density": {"displayUnit": null, "value": 3.6},
    "light absorption": {"displayUnit": null, "value": 49},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Calciumsilikatplatte"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Calciumsilikatplatte ist ein leichter, nicht brennbarer Baustoff, der aus Kalk, Sand und Zellulose besteht. Durch chemische Reaktion entsteht ein poröses Material mit hoher Alkalität und Kapillarwirkung. Die Platten sind besonders gut geeignet zur Innendämmung von Außenwänden, da sie Feuchtigkeit aufnehmen und wieder abgeben können.",
    },
    "id": "0197c5f0-c33e-70e8-b136-ce5d6611e529",
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "density", "size": "large", "card": "densityCard"},
            {
              "attributeId": "01973a83-3199-7457-80c9-18fda49d92ec",
              "size": "large",
              "card": "textCard",
            },
            {
              "attributeId": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
              "size": "large",
              "card": "subjectiveImpressionsCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "light absorption",
              "size": "large",
              "card": "lightAbsorptionCard",
            },
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "light transmission": {"displayUnit": null, "value": 84},
    "01973a53-3ad6-7e35-b596-3fb50f93cf96": [
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "rau",
          "valueEn": "rough",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 4,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "kalt",
          "valueEn": "cold",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "warm",
          "valueEn": "warm",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 3,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "weich",
          "valueEn": "soft",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "hart",
          "valueEn": "hard",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "glatt",
          "valueEn": "smooth",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "density": {"displayUnit": "kg/m³", "value": 35},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Porenbeton"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Porenbeton (auch bekannt als Gasbeton oder unter dem Markennamen Ytong) ist ein leichter, mineralischer Baustoff aus Kalk, Zement, Sand, Wasser und Aluminiumpulver. Durch eine chemische Reaktion entstehen kleine Luftbläschen, die den Beton aufschäumen – daher die porige Struktur.",
    },
    "id": "0197c5f7-5b2d-7353-81ad-baa30511b9fa",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {
              "attributeId": "0197c5f8-9198-7574-a920-c38a2b27b62c",
              "size": "large",
              "card": "textCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {"attributeId": "density", "size": "large", "card": "densityCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {"cards": [], "nameDe": null, "nameEn": null},
      ],
      "primary": [
        {
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
              "card": "imageCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://media.istockphoto.com/id/452202635/photo/lightweight-concrete-block.jpg?s=170667a&w=0&k=20&c=y8nOuQtpKkY7hkDwBR_GWxohOABxDC25lIPSOXv_GDo=",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUJAxJIM883tbDvW_1_CglbVcc9Qk0amPGxQt5610yZ90gEzZdElTMwCs&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://media.licdn.com/dms/image/v2/D5612AQGPG0GxsuSZBA/article-cover_image-shrink_720_1280/B56ZXWKvDwGsAI-/0/1743054894060?e=2147483647&v=beta&t=wq2mvI-qwwrK1g3P_qHP1OzGxOEPr75o8AzFByz06GU",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSLZV6s0XNRsG0GVq2XnUK7Kc62b0FMgrHyzyAv5AYMNWJvabR2b9ya65k&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://admincontent.bimobject.com/public/productimages/d0e71dd1-4489-495c-85fd-39c89508802a/052753a9-6c7c-43f9-bece-5cac38abae7e/92694?width=675&height=675&compress=true",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSj7e5ey8cZ-Q7PPrJ3pBQQ4C5eOkJIczUoNRIaA0qQM0hB-byPlFD1tdrN&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://cdn.cdn-ad-media.de/67c/67c1acbdaa0e31788c0f88407020db76_Fig._2_final.jpg.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqI0JaBFD0t__mgqw5whWG2bA7UeTkqE2FRiYr9lzEMW2NNes1AYi_mA&s",
        },
      },
    ],
    "0197c5f8-9198-7574-a920-c38a2b27b62c": {
      "valueEn": null,
      "valueDe":
          "Porenbeton ist einfach zu verarbeiten: Man kann ihn sägen, bohren, raspeln und kleben",
    },
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUJAxJIM883tbDvW_1_CglbVcc9Qk0amPGxQt5610yZ90gEzZdElTMwCs&s",
    },
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "woods",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 40,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "plastics",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "minerals",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 58,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "biodegradable": {"value": true},
    "biobased": {"value": false},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Kalksandstein"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein massiver Mauerstein aus Sand, Kalk und Wasser, unter Dampfdruck gehärtet. Er ist sehr druckfest, schalldämmend und nicht brennbar. Wird oft im Mauerwerksbau für tragende und aussteifende Wände verwendet.",
    },
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "AF"},
    ],
    "id": "0197c5fc-eca9-7aac-a2fb-a22b915a5320",
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "listCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
              "card": "imageCard",
            },
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameEn": null,
        },
        {"cards": [], "nameDe": null, "nameEn": null},
      ],
    },
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://d6ytrkhvpcrff.cloudfront.net/1000x1000/materialarchiv/imported_1486_8141_material00.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZw5Q4oQpdew0ana6cyOTqgOTAhOg3DSrTutDoTBP2WQCbd3_fLDb8G9R3&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://stanlux.de/environment/cache/images/500_500_productGfx_1990/Silka-EQ10-800.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSL1KTN8yTdCV9CH-07eZoGiYodF9GQT-6mF9VvlxME5nK55LD-5MX58E&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://i5.walmartimages.com/asr/8b25a185-141d-4d13-8d31-9ad5709edd4a.50a6e3607355d9538e822e19c7fdde8e.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKJmkoeiRYzrhzmXO7u9PtQRjkzLVE48-giCvxSWM_m33cRxLt1A1eq4fn&s",
        },
      },
    ],
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZw5Q4oQpdew0ana6cyOTqgOTAhOg3DSrTutDoTBP2WQCbd3_fLDb8G9R3&s",
    },
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "id": "2345",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Schwedische Fichte",
          "valueEn": "Wood Swedish fir",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 31,
          "displayUnit": null,
        },
      },
      {
        "id": "3456",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Wasser",
          "valueEn": "Water",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 12,
          "displayUnit": null,
        },
      },
      {
        "id": "4567",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Kalksteinmehl",
          "valueEn": "Limestone powder",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 9,
          "displayUnit": null,
        },
      },
      {
        "id": "5678",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Farbe, wasserbasiert",
          "valueEn": "Paint, water based",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "id": "1234",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Portlandzement",
          "valueEn": "Portland cement",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 44,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "biobased": {"value": true},
    "u-value": {"displayUnit": null, "value": 3.6},
    "areal density": {"displayUnit": null, "value": 0.5},
    "w-value": {"displayUnit": null, "value": 7.1},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Vermiculit"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein aufgeschäumtes, mineralisches Granulat, das aus Glimmerschiefer entsteht. Es ist extrem hitzebeständig, leicht und wird als Schüttdämmstoff oder in Brandschutzplatten eingesetzt – z. B. für Rohrabschottungen oder Decken.",
    },
    "id": "0197c604-adfa-7123-a5cb-2f96cca84dd0",
    "0197c15a-3f4e-7ee4-9bd7-2d9288244074": [
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://image.made-in-china.com/2f0j00gMzoTuQAbqbm/Factory-Direct-Supply-High-Temperature-Resistance-Ud-Bronze-Unidirectional-Basalt-Fiber-Fabric-Vermiculit-Coated-Basalt-Fiber-Cloth.webp",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR634yh2cfQWS4MW1JAmy-Jd3xmDGQjIJdvv7y70L7VQ07d_B38GxzWKEI&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://m.media-amazon.com/images/I/51I3zVc06KL._AC_SY580_.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHTc_D8IIX2Z-4bBMxSdoe7ISVE5xLI0Scnq-HbS2qcfdh2lDF7c6r1g&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://www.shutterstock.com/image-photo/closeup-hand-holding-vermiculite-potting-260nw-2415465843.jpg",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9Rv9dzxf7zqDLkx811-DbgVAn2lFQ227yxbma9OuHw46MCL8UaQHm&s",
        },
      },
      {
        "0197c159-7074-7813-ae3b-d8ccc98ee7c2": {
          "valueEn": null,
          "valueDe":
              "https://rebelplants.co.uk/cdn/shop/products/vermiculite-horticultural-vermiculitte-soil-rebel-plants-639827.jpg?v=1736957779",
        },
        "0197c159-299d-791e-9527-1bd445e2401e": {
          "valueEn": null,
          "valueDe":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3_NM-K7NncrQp7pHRQThsi51aSJeTsIcY-9MpLlyOA7OqbPgsSoIkynU&s",
        },
      },
    ],
    "0197c1d4-79c9-7e48-8208-5b7fc09c51c9": {
      "valueEn": null,
      "valueDe":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR634yh2cfQWS4MW1JAmy-Jd3xmDGQjIJdvv7y70L7VQ07d_B38GxzWKEI&s",
    },
    "cardSections": {
      "secondary": [
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "areal density",
              "size": "large",
              "card": "arealDensityCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "nameEn": null,
          "cards": [
            {"card": "nameCard", "attributeId": "name", "size": "large"},
            {
              "card": "imageCard",
              "attributeId": "0197c15a-3f4e-7ee4-9bd7-2d9288244074",
              "size": "large",
            },
          ],
        },
        {
          "nameDe": null,
          "nameEn": null,
          "cards": [
            {"card": "wValueCard", "attributeId": "w-value", "size": "large"},
            {"card": "uValueCard", "attributeId": "u-value", "size": "large"},
          ],
        },
      ],
    },
  },
  {
    "biodegradable": {"value": true},
    "density": {"displayUnit": null, "value": 650},
    "biobased": {"value": true},
    "recyclable": {"value": true},
    "u-value": {"displayUnit": null, "value": 0.18},
    "w-value": {"displayUnit": "kg/m²√s", "value": 54},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Bambusfaserplatte"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Die Bambusfaserplatte ist ein umweltfreundliches, biobasiertes Plattenmaterial aus gepressten Bambusfasern und einem natürlichen Bindemittel. Sie vereint hohe Stabilität mit einem geringen Gewicht und eignet sich hervorragend für Möbelbau, Innenausbau oder dekorative Anwendungen. Ihre natürliche Maserung verleiht jedem Produkt eine warme, organische Anmutung.",
    },
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "CN"},
      {"valueDe": "VN"},
    ],
    "id": "0197c616-cc74-77a1-bea1-254c2b64f2e1",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {"attributeId": "density", "size": "large", "card": "densityCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "nameDe": "Nachaltigkeit",
          "cards": [
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {
              "attributeId": "recyclable",
              "size": "large",
              "card": "booleanCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {"attributeId": "u-value", "size": "large", "card": "uValueCard"},
            {"attributeId": "w-value", "size": "large", "card": "wValueCard"},
          ],
          "nameEn": null,
        },
        {
          "nameDe": "Herstellung",
          "cards": [
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "originCountryCard",
            },
            {
              "attributeId": "manufacturer",
              "size": "large",
              "card": "objectCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "manufacturer": {
      "name-1": {"valueEn": null, "valueDe": "EcoPanel GmbH"},
      "website": {"valueDe": "https://www.ecopanel.de"},
    },
  },
  {
    "light reflection": {"displayUnit": null, "value": 85},
    "biodegradable": {"value": false},
    "density": {"displayUnit": null, "value": 2700},
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {"value": 100},
        "01973a7f-996f-7d2c-808c-facf1b23abed": {"valueDe": "metals"},
      },
    ],
    "biobased": {"value": false},
    "recyclable": {"value": true},
    "areal density": {"displayUnit": null, "value": 2700},
    "name": {
      "valueEn": "Unnamed Material",
      "valueDe": "Recyceltes Aluminiumblech",
    },
    "description": {
      "valueEn": null,
      "valueDe":
          "Flachblech aus 100 % recyceltem Aluminium. Wird für Fassaden, Gehäuse und industrielle Bauteile verwendet. Hohe Festigkeit, gute Korrosionsbeständigkeit, vollständig wiederverwertbar.",
    },
    "id": "0197c62c-a325-7d95-afbc-3f5f3c1e748a",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {
              "attributeId": "recyclable",
              "size": "large",
              "card": "booleanCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "cards": [
            {"attributeId": "density", "size": "large", "card": "densityCard"},
            {
              "attributeId": "areal density",
              "size": "large",
              "card": "arealDensityCard",
            },
            {
              "attributeId": "light reflection",
              "size": "large",
              "card": "lightReflectionCard",
            },
          ],
          "nameDe": "Eigenschaften",
          "nameEn": null,
        },
      ],
    },
  },
  {
    "biodegradable": {"value": false},
    "density": {"displayUnit": null, "value": 12.9},
    "recyclable": {"value": true},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Magnesitboden"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein mineralischer Estrich aus Magnesit, Sand und Füllstoffen. Wird fugenlos gegossen, ist druckfest und hat ein warmes Laufgefühl. Vor allem in öffentlichen Gebäuden und Werkstätten zu finden – aber auch ästhetisch in modernen Innenräumen.",
    },
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "PT"},
      {"valueDe": "SG"},
    ],
    "id": "0197c631-c4d7-76f0-ac45-be4272926749",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "listCard",
            },
            {"attributeId": "u-value", "size": "large", "card": "uValueCard"},
            {"attributeId": "density", "size": "large", "card": "densityCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
        {
          "nameDe": "Nachhaltigkeit",
          "cards": [
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "recyclable",
              "size": "large",
              "card": "booleanCard",
            },
          ],
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a53-3ad6-7e35-b596-3fb50f93cf96",
              "size": "large",
              "card": "subjectiveImpressionsCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": null,
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameEn": null,
        },
        {"cards": [], "nameDe": null, "nameEn": null},
      ],
    },
    "01973a53-3ad6-7e35-b596-3fb50f93cf96": [
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "glatt",
          "valueEn": "smooth",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "kalt",
          "valueEn": "cold",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "warm",
          "valueEn": "warm",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 3,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "weich",
          "valueEn": "soft",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 1,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "hart",
          "valueEn": "hard",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a53-3ad5-7a63-a6fd-d238fa571298": {
          "valueDe": "rau",
          "valueEn": "rough",
        },
        "01973a53-c53f-7ea3-a53f-3d21fffb2ca3": {
          "value": 4,
          "displayUnit": null,
        },
      },
    ],
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "woods",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 40,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "plastics",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "01973a7f-996f-7d2c-808c-facf1b23abed": {
          "valueDe": "minerals",
          "valueEn": null,
        },
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {
          "value": 58,
          "displayUnit": null,
        },
      },
    ],
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "id": "2345",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Schwedische Fichte",
          "valueEn": "Wood Swedish fir",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 31,
          "displayUnit": null,
        },
      },
      {
        "id": "3456",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Wasser",
          "valueEn": "Water",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 12,
          "displayUnit": null,
        },
      },
      {
        "id": "4567",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Kalksteinmehl",
          "valueEn": "Limestone powder",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 9,
          "displayUnit": null,
        },
      },
      {
        "id": "5678",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Farbe, wasserbasiert",
          "valueEn": "Paint, water based",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 2,
          "displayUnit": null,
        },
      },
      {
        "id": "1234",
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueDe": "Portlandzement",
          "valueEn": "Portland cement",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {
          "value": 44,
          "displayUnit": null,
        },
      },
    ],
  },
  {
    "biobased": {"value": true},
    "areal density": {"displayUnit": "g/m²", "value": 0.25},
    "name": {
      "valueEn": "Unnamed Material",
      "valueDe": "Recycelter Baumwollstoff",
    },
    "description": {
      "valueEn": null,
      "valueDe":
          "Weicher, textiler Stoff aus recycelten Baumwollfasern. Ideal für nachhaltige Mode oder Innenausstattung. Hoher Tragekomfort, atmungsaktiv und ressourcenschonend hergestellt.",
    },
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Recycelte Baumwolle",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 90},
        "id": "1234",
      },
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Polyester",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 10},
        "id": "2345",
      },
    ],
    "id": "0197c635-fc79-7563-aaa2-d341d69a0d88",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {
              "attributeId": "manufacturer",
              "size": "large",
              "card": "objectCard",
            },
            {
              "attributeId": "areal density",
              "size": "large",
              "card": "arealDensityCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
          ],
          "nameEn": null,
        },
        {
          "cards": [
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
    },
    "manufacturer": {
      "name-1": {"valueEn": null, "valueDe": "Textura Green"},
      "website": {"valueDe": "https://www.texturagreen.com"},
    },
  },
  {
    "biodegradable": {"value": true},
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {"value": 60},
        "01973a7f-996f-7d2c-808c-facf1b23abed": {"valueDe": "plantsAndAnimals"},
      },
      {
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {"value": 40},
        "01973a7f-996f-7d2c-808c-facf1b23abed": {"valueDe": "plastics"},
      },
    ],
    "biobased": {"value": true},
    "name": {"valueEn": "Unnamed Material", "valueDe": "Algen-Biopolymer"},
    "description": {
      "valueEn": null,
      "valueDe":
          "Ein innovativer Werkstoff aus Makroalgen-Extrakten und biologisch abbaubaren Polymeren. Leicht, halbtransparent und gut formbar, eignet sich dieses Material für Verpackungen, Möbelkomponenten oder dekorative Anwendungen.",
    },
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Makroalgenextrakt",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 60},
        "id": "1234",
      },
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "PLA",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 30},
        "id": "0197c645-b31c-75fc-986b-0b91f1713290",
      },
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Glyzerin",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 10},
        "id": "0197c645-d805-7763-8cd8-4824a70890f9",
      },
    ],
    "id": "0197c63f-6d05-7317-91a4-50496fc0d124",
    "cardSections": {
      "secondary": [],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "light transmission",
              "size": "large",
              "card": "lightTransmissionCard",
            },
          ],
          "nameEn": null,
        },
        {
          "nameDe": "",
          "cards": [
            {
              "attributeId": "biodegradable",
              "size": "large",
              "card": "booleanCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
          ],
          "nameEn": null,
        },
        {
          "nameDe": "Zusammensetzung",
          "cards": [
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameEn": null,
        },
      ],
    },
    "light transmission": {"displayUnit": null, "value": 40},
  },
  {
    "density": {"displayUnit": null, "value": 320},
    "01973a80-8ae1-75ed-ae14-c442187b3955": [
      {
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {"value": 25},
        "01973a7f-996f-7d2c-808c-facf1b23abed": {"valueDe": "minerals"},
      },
      {
        "01973a80-26ff-7bee-bbc8-c93911d3fa2c": {"value": 70},
        "01973a7f-996f-7d2c-808c-facf1b23abed": {"valueDe": "plantsAndAnimals"},
      },
    ],
    "biobased": {"value": true},
    "u-value": {"displayUnit": null, "value": 0.07},
    "name": {
      "valueEn": "Unnamed Material",
      "valueDe": "Hanf-Kalk-Verbundplatte",
    },
    "description": {
      "valueEn": null,
      "valueDe":
          "Diese ökologische Platte kombiniert Hanffasern mit einem natürlichen Kalkbinder. Sie bietet gute Dämmwerte, Feuchtigkeitsregulierung und Schallschutz. Ideal für den ökologischen Innenausbau und als diffusionsoffenes Baumaterial einsetzbar.",
    },
    "01973a81-f146-7f9b-97c1-97f8b393996a": [
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Hanffasern",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 70},
        "id": "1234",
      },
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Hydraulischer Kalk",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 25},
        "id": "0197c64f-d4cc-7713-87a8-a51512aa1784",
      },
      {
        "01973a81-5717-732f-99c0-97481e1954c5": {
          "valueEn": null,
          "valueDe": "Pflanzliche Additive",
        },
        "01973a81-b8b3-7214-b729-877d3d6cb394": {"value": 5},
        "id": "0197c650-022d-71fc-a90a-f6d141906213",
      },
    ],
    "01973a84-5f56-71dc-9c18-dc25fc865b33": [
      {"valueDe": "DE"},
      {"valueDe": "FR"},
    ],
    "id": "0197c648-508e-78f7-9974-f05b615214a6",
    "cardSections": {
      "secondary": [
        {
          "cards": [
            {"attributeId": "u-value", "size": "large", "card": "uValueCard"},
            {"attributeId": "density", "size": "large", "card": "densityCard"},
            {
              "attributeId": "recyclable",
              "size": "large",
              "card": "booleanCard",
            },
            {"attributeId": "biobased", "size": "large", "card": "booleanCard"},
          ],
          "nameDe": null,
          "nameEn": null,
        },
      ],
      "primary": [
        {
          "nameDe": null,
          "cards": [
            {"attributeId": "name", "size": "large", "card": "nameCard"},
            {
              "attributeId": "01973a84-5f56-71dc-9c18-dc25fc865b33",
              "size": "large",
              "card": "originCountryCard",
            },
            {
              "attributeId": "description",
              "size": "large",
              "card": "descriptionCard",
            },
            {
              "attributeId": "01973a80-8ae1-75ed-ae14-c442187b3955",
              "size": "large",
              "card": "compositionCard",
            },
            {
              "attributeId": "01973a81-f146-7f9b-97c1-97f8b393996a",
              "size": "large",
              "card": "componentsCard",
            },
          ],
          "nameEn": null,
        },
        {"cards": [], "nameDe": "", "nameEn": null},
      ],
    },
    "manufacturer": {
      "name-1": {"valueEn": null, "valueDe": "GreenBuild Naturbaustoffe"},
      "website": {"valueDe": "https://www.greenbuild.eu"},
    },
  },
];

const _colors = {
  "Schwedische Fichte": "#b39579",
  "Blähton": "#c8c2bc",
  "PLA": "#9aa292",
  "Magnesitboden": "#65625d",
  "Bauschaum": "#928d87",
  "Holzwolle": "#9f8c79",
  "Bambusfaserplatte": "#979792",
  "Schaumglas": "#8f8e90",
  "Pflanzliche Additive": "#d1d0c7",
  "Glyzerin": "#6f6d6a",
  "Recyceltes Aluminiumblech": "#cbd4d9",
  "Algen-Biopolymer": "#6e7567",
  "Porenbeton": "#a2a2aa",
  "Recycelter Baumwollstoff": "#58729b",
  "Recycelte Baumwolle": "#b1aead",
  "Unbenanntes Material": "#797876",
  "Calciumsilikatplatte": "#cfc9c4",
  "Farbe, wasserbasiert": "#b8aca5",
  "Polyester": "#687e7a",
  "Vermiculit": "#b5aca6",
  "Optisches Glas": "#9ea4b0",
  "Hanf-Kalk-Verbundplatte": "#a89a8b",
  "Portlandzement": "#969194",
  "Wasser": "#afa39e",
  "Hanffasern": "#c6c5ba",
  "Kalksteinmehl": "#9ea3a9",
  "Makroalgenextrakt": "#ad9f9e",
  "Kalksandstein": "#898a89",
  "Hydraulischer Kalk": "#aaa096",
};
