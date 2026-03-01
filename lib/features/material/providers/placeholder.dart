import 'dart:math';

import 'package:dynamische_materialdatenbank/features/attributes/models/attribute_converter.dart';
import 'package:dynamische_materialdatenbank/shared/constants.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/boolean/boolean.dart';
import 'package:dynamische_materialdatenbank/features/attributes/default/text/translatable_text.dart';

Json randomName() {
  final random = Random();
  final index = random.nextInt(randomMaterialNames.length);
  final name = randomMaterialNames[index];
  return TranslatableText(valueDe: name).toJson();
}

Json randomDescription() {
  final random = Random();
  final sentences = randomSentencesAboutMaterials.split('. ');
  final selectedSentences = <String>[];

  final randomIndex = random.nextInt(sentences.length - 3);
  for (int i = 0; i < 3; i++) {
    final index = randomIndex + i;
    selectedSentences.add(sentences[index]);
    sentences.removeAt(index);
  }

  final description = '${selectedSentences.join('. ')}.';
  return TranslatableText(valueDe: description).toJson();
}

Json randomManufacturer() {
  final random = Random();
  return {
    Attributes.manufacturerName: TranslatableText(
      valueDe: 'Manufacturer ${random.nextInt(10)}',
    ).toJson(),
  };
}

Json randomBoolean() {
  final random = Random();
  return Boolean(value: random.nextBool()).toJson();
}

const randomMaterialNames = [
  'Aluminium',
  'Beton',
  'Eichenholz',
  'Birken-Sperrholz',
  'Edelstahl',
  'Carbonfaser',
  'Kevlar',
  'Silikon',
  'Polycarbonat',
  'Bambus',
  'Marmor',
  'Granit',
  'Kork',
  'Wolle',
  'Baumwolle',
  'Hanfstoff',
  'Nylon',
  'Polyester',
  'Latex',
  'Acrylglas',
  'Sicherheitsglas',
  'Corian',
  'Messing',
  'Kupfer',
  'Bronze',
  'Gusseisen',
  'Schaumgummi',
  'Recyclingkunststoff',
  'Myzel-Verbundstoff',
  'Papierkarton',
  'Wellpappe',
  'Strohpressplatte',
  'Jute',
  'Ramie',
  'Samt',
  'Leinen',
  'Seide',
  'Holzkohle',
  'Schiefer',
  'Speckstein',
  'Gips',
  'PVC',
  'ABS-Kunststoff',
  'PLA-Biokunststoff',
  'Harz',
  'Glasfaser',
  'Epoxidharz',
  'Graphen',
  'Aerogel',
  'Flüssigmetall',
  'Verzinkter Stahl',
  'Zink',
  'Titan',
  'Nickel',
  'Wolfram',
  'Blei',
  'Putz',
  'Tadelakt',
  'Ton',
  'Terrakotta',
  'Porzellan',
  'Keramikfliese',
  'Glasierte Keramik',
  'Magnetit',
  'Obsidian',
  'Lavagestein',
  'Quarz',
  'Sodalith',
  'Malachit',
  'Türkis',
  'Neopren',
  'Filz',
  'Netzgewebe',
  'Canvas',
  'Wildleder',
  'Kunstleder',
  'Echtleder',
  'Furnier',
  'Laminat',
  'Formica',
  'MDF-Platte',
  'OSB-Platte',
  'Spanplatte',
  'Dämmstoffschaum',
  'Schalldämmstoff',
  'Nanobeschichtung',
  'Photovoltaikglas',
  'E-Papier',
  'Smart-Textil',
  'Biologisch abbaubarer Schaum',
  'Maisstärkekunststoff',
  'Recyclingbeton',
  'Altholz',
  'Titanlegierung',
  'Chrom-Molybdän-Stahl',
  'Sperrholz mit Harzkern',
  'Harter Gummi',
  'Borosilikatglas',
  'Intelligente Folie',
  'ETFE-Folie',
  'Wasserabweisender Stoff',
  'Leitfähige Tinte',
  'Rostfreier Stahl',
  'Reines Eisen',
  'Magnesium',
  'Blei-Kristall',
  'Gipskarton',
  'Naturkautschuk',
  'Stroh',
  'Rattan',
  'Weidengeflecht',
  'Schafwolle',
  'Kamelhaar',
  'Kaschmir',
  'Mohair',
  'Alpaka',
  'Rosshaar',
  'Seetangfaser',
  'Kokosfaser',
  'Bast',
  'Lederimitat',
  'Veganes Leder',
  'Muschelkalk',
  'Lehm',
  'Stampflehm',
  'Zement',
  'Porenbeton',
  'Blähton',
  'Bimsstein',
  'Glaswolle',
  'Steinwolle',
  'Perlit',
  'Kieselgur',
  'Basalt',
  'Andesit',
  'Diorit',
  'Gneis',
  'Meteoritengestein',
  'Transparentes Aluminium',
  'Titannitrid',
  'Kohlenstoffnanoröhren',
  'Kieselgel',
  'Superhydrophober Lack',
  'Intelligente Keramik',
  'Transparente Solarfolie',
  'Elektrochromes Glas',
  'Thermochromes Material',
  'Piezoelektrisches Material',
  'Formgedächtnislegierung',
  'Elektroaktive Polymere',
  'Magnetorheologische Flüssigkeit',
  'Reaktive Folie',
  'Biegbares Displaymaterial',
  'Mikrokapsel-Textil',
  'Biologisch aktives Gewebe',
  'Smartes Papier',
  'Digitaler Stoff',
  'Regenjacken-Membran',
  'PTFE (Teflon)',
  'FEP-Folie',
  'Synthetisches Quarzglas',
  'Laminierte Sicherheitsfolie',
  'Verbundsicherheitsglas',
  'Akustikschaum',
  'Melaminschaum',
  'Schwingungsdämpfer-Gummi',
  'Thermoplast',
  'Thermoplastisches Elastomer',
  'Thermoharz',
  'Duroplast',
  'Biokeramik',
  'Hybridkeramik',
  'Lötzinn',
  'Weißblech',
  'Verbundwerkstoff',
  'Naturfaser-Verbund',
  'Holz-Kunststoff-Verbund',
  'Faserguss',
  'Zellulosefolie',
  'Pflanzenleder',
  'Milchprotein-Kunststoff',
  'Pilzleder',
  'Fruchtleder',
  'Kombucha-Membran',
  'Algentextil',
  'Papierbeton',
  'Papierlehm',
  'Reispapier',
  'Strohmatte',
  'Blättergewebe',
  'Rindenstoff',
  'Wachstuch',
  'Ölgehärteter Leinenstoff',
  'Bienenwachstuch',
  'Gummierter Stoff',
  'Feuerfester Stoff',
  'UV-resistenter Kunststoff',
  'Biolumineszierender Stoff',
  'Schallreflektierendes Material',
  'Eisspeicher-Material',
  'Phasenwechselmaterial',
  'Magnetfolie',
  'Holografische Folie',
  'Optisches Glas',
];

const randomSentencesAboutMaterials = """
Materialien sind die Bausteine unserer Welt. Alles, was wir anfassen, benutzen oder herstellen, besteht aus irgendeiner Form von Material – sei es natürlich oder künstlich, fest oder flüssig, weich oder hart. Der Begriff „Material“ beschreibt dabei zunächst einmal jede Substanz, die zur Herstellung von Gegenständen oder zur Erfüllung bestimmter Funktionen verwendet werden kann. Doch hinter diesem einfachen Wort verbirgt sich eine faszinierende Vielfalt an Eigenschaften, Einsatzbereichen und Technologien.

Materialien lassen sich grob in zwei Hauptkategorien einteilen: natürliche und künstliche Materialien.
Natürliche Materialien stammen direkt aus der Natur. Dazu gehören Holz, Stein, Leder, Baumwolle oder auch tierische Produkte wie Wolle oder Seide. Sie werden in der Regel nur geringfügig bearbeitet, bevor sie verwendet werden.
Künstliche Materialien dagegen sind vom Menschen hergestellt oder stark verändert. Dazu zählen Metalle (z. B. Stahl oder Aluminium), Kunststoffe, Glas, Keramik oder High-Tech-Verbundstoffe wie Carbonfaser oder Kevlar. Diese Materialien entstehen oft durch aufwändige chemische oder physikalische Prozesse und sind speziell auf bestimmte Eigenschaften hin optimiert.

Materialien können auch nach ihren physikalischen Eigenschaften unterteilt werden. Die wichtigsten Klassen sind:
Metalle (z. B. Eisen, Kupfer, Aluminium): meist hart, leitfähig, verformbar, oft gut recycelbar.
Polymere (Kunststoffe): leicht, formbar, isolierend, oft günstig in der Herstellung, aber problematisch in der Entsorgung.
Keramiken: extrem hart, hitzebeständig, aber spröde. Einsatz z. B. in der Medizin (Implantate) oder Technik (Isolatoren).
Glas: durchsichtig, formbar bei Hitze, chemisch beständig. Wichtig für Architektur, Technik und Haushaltswaren.
Verbundmaterialien: Kombinationen aus zwei oder mehr Materialien, um gezielt bestimmte Eigenschaften zu kombinieren. Beispiele: GFK (glasfaserverstärkter Kunststoff), Carbon, Beton.

In unserem Alltag begegnen wir Materialien überall. Die Wahl des richtigen Materials ist dabei entscheidend – nicht nur für Funktion, sondern auch für Aussehen, Nachhaltigkeit und Lebensdauer eines Produkts.
Im Bauwesen dominieren klassische Materialien wie Beton, Stahl, Holz und Glas. Neue Entwicklungen wie selbstheilender Beton oder thermisch regulierende Fassadenmaterialien zeigen, wie innovativ auch traditionelle Bereiche sein können.
In der Modeindustrie geht es nicht nur um Aussehen, sondern auch um Tragekomfort, Pflege und Umweltfreundlichkeit. Hier gewinnen Materialien wie recycelte Fasern oder biologisch abbaubare Stoffe an Bedeutung.
In der Technik müssen Materialien oft extremen Bedingungen standhalten – Hitze, Druck, Reibung oder Stromfluss. Hier kommen Spezialmaterialien zum Einsatz, deren Entwicklung oft Jahrzehnte dauert.
Im Design spielt neben Funktion auch Ästhetik eine zentrale Rolle. Materialien werden bewusst wegen ihrer Haptik, Farbe oder Reflektionseigenschaften gewählt – ob bei Möbeln, Verpackungen oder Interfaces.

Ein immer wichtiger werdendes Thema ist die Nachhaltigkeit von Materialien. Während viele traditionelle Materialien wie Holz oder Naturstein vergleichsweise umweltfreundlich sind, stehen vor allem Kunststoffe und andere schwer abbaubare Stoffe in der Kritik. In Forschung und Industrie wird deshalb intensiv an Alternativen gearbeitet: biologisch abbaubare Kunststoffe, Materialien aus Pilzmyzel oder Algen, oder zirkuläre Systeme, in denen Materialien komplett wiederverwendet werden können.
Ein weiteres spannendes Feld ist die Entwicklung von intelligenten Materialien, die auf äußere Einflüsse reagieren – z. B. Stoffe, die ihre Farbe ändern, wenn sich die Temperatur ändert, oder Materialien, die ihre Struktur verändern, um sich an Belastungen anzupassen.
Fazit
Materialien sind mehr als nur Mittel zum Zweck – sie formen unsere Welt, beeinflussen unser tägliches Leben und spiegeln technische wie gesellschaftliche Entwicklungen wider. Von uralten Naturmaterialien bis zu futuristischen Hightech-Stoffen ist die Geschichte der Materialien eng mit der Geschichte der Menschheit verknüpft. Wer sich mit Materialien beschäftigt, blickt nicht nur zurück, sondern vor allem auch in die Zukunft – auf eine Welt, in der Ressourcen sinnvoller, nachhaltiger und intelligenter genutzt werden müssen.

Es gibt sogenannte intelligente Materialien – auch Smart Materials genannt – die können auf ihre Umgebung reagieren. Die verändern z. B. ihre Form, Farbe, Härte oder Leitfähigkeit, je nachdem, was gerade passiert.

Ein paar Beispiele:

Formgedächtnislegierungen: Das sind Metalle (z. B. Nitinol), die sich an eine „ursprüngliche Form“ erinnern. Du kannst sie verbiegen, und wenn du sie dann erwärmst – zack, gehen sie wieder zurück in die alte Form.

Thermochrome Materialien: Die wechseln ihre Farbe, wenn sich die Temperatur ändert. Kennst du vielleicht von Tassen, auf denen bei heißem Kaffee ein Bild erscheint.

Piezoelektrische Materialien: Die erzeugen Strom, wenn man sie drückt oder biegt. Es gibt schon Prototypen von Schuhsohlen, die beim Laufen dein Handy laden könnten.

Manche Materialien sind einfach kult. Zum Beispiel:

Porzellan: Das "weiße Gold" aus China hat Europa jahrhundertelang fasziniert. Die ersten europäischen Versuche, Porzellan herzustellen, scheiterten grandios, bis Meißner Porzellan erfunden wurde – ein riesiger Meilenstein.

Beton: Klingt erstmal langweilig, aber Beton ist mega spannend. Die Römer haben damit schon Aquädukte gebaut – und deren Beton hält teils besser als moderner, weil sie Vulkanasche beigemischt haben. Heute versucht man genau das zu kopieren, um langlebigeren Beton herzustellen.

Papyrus und Pergament: Vorläufer vom heutigen Papier, und je nachdem, aus was du schreibst, hat das einen krassen Einfluss auf die Haltbarkeit. Manche Pergamente sind über 1000 Jahre alt.

Aktuell ist in der Materialentwicklung richtig viel Bewegung. Besonders wichtig sind:

Biobasierte Materialien: Also Stoffe, die aus Pflanzen oder Pilzen gemacht werden. Pilzleder (aus Myzel), Textilien aus Ananas oder Hanf – alles nice Alternativen zu tierischem Leder oder Kunstfaser.

Recycling 2.0: Materialien, die nicht nur recycelt werden können, sondern aktiv dafür entwickelt werden. Also mit minimalem Energieaufwand, zerlegbar, sortierbar, etc.

Transparente Holzpaneele: Ja, richtig gelesen. Es gibt Holz, das durchsichtig gemacht wird, z. B. für Fenster. Die Zellulose bleibt, das Lignin (was das Holz braun macht) wird ersetzt – und raus kommt ein starkes, lichtdurchlässiges Material.

Auch in der Software-Welt (z. B. bei UI/UX) gibt's sowas wie Material Design – inspiriert von echten Materialien. Google hat das eingeführt, um digitale Elemente fühlbarer zu machen. Schatten, Tiefen, Bewegungen – alles basiert auf physikalischen Materialprinzipien.

Man könnte sagen: Selbst virtuelle Knöpfe bestehen irgendwie aus „Materialien“, auch wenn die nur auf dem Screen existieren.

Wissenschaftler:innen arbeiten an echt abgefahrenen Sachen:

Aerogele: ultraleicht, fast durchsichtig, aber trotzdem gute Isolatoren. Wird auch „gefrorener Rauch“ genannt.

Graphen: ein einziges Atom dickes Kohlenstoffnetz. Extrem leitfähig, stabiler als Stahl, transparent – ein echtes Wundermaterial, wenn man es denn in Masse herstellen könnte.

Selbstheilende Materialien: Inspiriert von Haut – sie reparieren kleine Risse oder Schnitte von selbst. Kann in Zukunft richtig nützlich für Infrastruktur oder Technik sein.

Das Recycling-Game wird immer kreativer. Früher war Recycling eher so: PET-Flasche → neue PET-Flasche. Heute entstehen daraus komplett neue Dinge.

Ocean Plastic: Aus Plastikmüll aus dem Meer werden Sneaker, Handyhüllen oder ganze Möbel gemacht. Adidas z. B. bringt immer wieder Schuhe raus, die aus recycelten Fischernetzen bestehen.

Textil-Recycling: Alte Klamotten werden zu Fasern zerlegt und neu gesponnen – daraus entsteht „Recycel-Baumwolle“ oder Mischgewebe mit coolen neuen Texturen.

Bananenblätter, Kaffeesatz oder Reishülsen: Diese Reste werden zu Platten gepresst oder als Bindemittel verwendet. Daraus entstehen Tische, Verpackungen oder biologisch abbaubare Einwegprodukte.

Im All ist die Materialwahl absolut entscheidend. Dort herrschen extreme Bedingungen – Temperaturen von -150 bis +150 °C, Vakuum, Strahlung…

Goldfolie auf Satelliten? Jep! Viele Satelliten und Raumsonden sind mit goldfarbener Folie überzogen – das ist meist Kapton, ein hitzebeständiger Kunststoff, beschichtet mit Aluminium oder Gold. Nicht fürs Bling, sondern zum Schutz.

Hitzeschild von Raumkapseln: Das Material muss beim Wiedereintritt in die Atmosphäre über 1500 °C aushalten – dafür wird z. B. ablatives Material verwendet, das langsam „verbrennt“ und dadurch Wärme abführt.

Raumanzüge: Multilayer-Strukturen mit bis zu 14 Schichten – Kevlar, Nomex, Mylar, Dacron… das ist so ein richtiger Hightech-Burrito 🧑‍🚀🌯

Metamaterialien: Klingt nach Sci-Fi, ist aber real. Das sind Materialien mit einer Struktur auf Nano-Ebene, die so gestaltet ist, dass sie z. B. Licht anders brechen als normale Materialien. Damit kann man theoretisch Dinge „unsichtbar“ machen. Wirklich.

Tarnkappen-Materialien (Radar-Absorber): Flugzeuge wie der Stealth-Bomber sind mit speziellen Schichten überzogen, die Radarwellen schlucken, statt sie zurückzuwerfen.

Optische Illusion durch Oberfläche: Manche Oberflächen sehen metallisch aus, sind aber nur Plastik. Durch gezielte Mikrostrukturierung sieht z. B. ein Kunststoff plötzlich wie gebürstetes Aluminium aus. Ziemlich cool fürs Produktdesign.

Die Natur ist eigentlich der beste Material-Ingenieur überhaupt:

Spinnenseide: fünfmal fester als Stahl – bei einem Bruchteil des Gewichts. Wissenschaftler versuchen seit Jahren, synthetische Versionen zu bauen.

Perlmutt (Muscheln): Ist auf Nanoebene aufgebaut wie Ziegelsteinmauerwerk – dadurch extrem bruchfest.

Lotus-Effekt: Die Blätter der Lotusblume sind super wasserabweisend – durch winzige Mikrostrukturen. Diese Struktur wird in Farben und Beschichtungen nachgeahmt (→ selbstreinigende Oberflächen).

Kennst du das, wenn ein Produkt sich wertig anfühlt? Das ist oft kein Zufall, sondern Materialstrategie.

Soft-Touch-Kunststoffe: Diese matten, leicht gummierten Oberflächen (z. B. bei teuren Fernbedienungen oder Elektronik) wirken hochwertiger – obwohl es „nur“ Plastik ist.

Holz als Vertrauensträger: Im Branding wird Holz oft eingesetzt, um Natürlichkeit, Nachhaltigkeit oder Authentizität zu transportieren – z. B. bei Bio-Produkten oder in App-Designs (z. B. braune Farbtöne + Holztextur).

Material-Kombis im Interior: Beton + Holz = modern + gemütlich. Stahl + Glas = clean + futuristisch. Materialien erzählen Geschichten – ganz ohne Worte.

In der Welt der Materialien passiert gerade so viel Faszinierendes, dass man locker ganze Bücher darüber füllen könnte. Es geht schon lange nicht mehr nur um Holz, Metall oder Kunststoff – sondern um Stoffe, die fast lebendig wirken, auf ihre Umwelt reagieren oder gleich ganz aus dem Labor stammen. Ein Beispiel dafür ist selbstheilender Beton. Forschende haben Bakterien in kleine Kapseln eingebaut, die in den Beton gemischt werden. Entsteht ein Riss und dringt Wasser ein, „wacht“ das Bakterium auf und produziert Kalkstein – der Riss verschließt sich von selbst. Eine andere Entwicklung, die wie aus der Zukunft klingt, ist Aerogel. Dieses Material besteht zu über 95 Prozent aus Luft und ist gleichzeitig ein exzellenter Isolator. Es sieht aus wie fester Nebel oder Rauch, ist unglaublich leicht und trotzdem stabil. Die NASA verwendet es bereits bei Weltraummissionen.

Dann gibt es Textilien, die Strom leiten, Daten erfassen oder sogar als Touchpad funktionieren. Diese elektronischen Stoffe ermöglichen Kleidung, die mit dem Träger kommuniziert – zum Beispiel durch Temperaturregelung, Pulsmessung oder Positionsverfolgung. Dazu passt ein weiteres Zukunftsmaterial: Myzel. Das Wurzelgeflecht von Pilzen lässt sich in Formen wachsen und wird nach dem Trocknen zu einem festen, feuerfesten, biologisch abbaubaren Material. Es eignet sich für Möbel, Verpackungen, Dämmstoffe oder sogar als Baustoff.

Auch Flüssigmetalle gehören zu dieser neuen Materialwelt. Legierungen wie Gallium bleiben bei Raumtemperatur flüssig, leiten aber trotzdem Strom. In der Robotik wird mit solchen Metallen experimentiert, etwa für weiche Maschinen oder sich selbst reparierende Schaltungen. Ein weiteres Highlight: Polymere mit Formgedächtnis. Diese Stoffe merken sich eine Ausgangsform, und wenn man sie erhitzt, kehren sie genau in diese Form zurück – völlig automatisch. Verwendet werden sie unter anderem in der Medizintechnik, etwa bei Implantaten, die sich im Körper entfalten.

Spannend sind auch neuartige Kühlmaterialien. Forschende haben künstliches Eis entwickelt, das sich wie normales Eis verhält, aber nicht schmilzt. Ideal zum Transport von Lebensmitteln oder Medikamenten – wiederverwendbar, sauber und effizient. Gleichzeitig entstehen Oberflächen, die sich selbst reinigen, inspiriert von der Lotusblume. Durch mikroskopisch feine Strukturen perlt Wasser einfach ab, nimmt dabei Schmutz mit und hinterlässt eine saubere Oberfläche – ohne Chemie, ganz allein durch die Struktur.

Ein weiteres Feld, das große Aufmerksamkeit bekommt, sind speicherfähige Materialien. Beton, der Strom speichern kann. Fenster, die gleichzeitig als Solarzellen funktionieren. Wandfarben, die Sonnenlicht aufnehmen und in Energie umwandeln. Statt eines sichtbaren Akkus werden ganze Gebäudehüllen zu Energiequellen. Und dann gibt es noch Metaoberflächen – Materialien, die Licht auf ganz neue Weise brechen. Sie ermöglichen flache Linsen, Hologramme oder sogar Tarnkappen-Technologie, indem sie Licht um Objekte herumlenken.

Diese Materialien sind nicht einfach nur Werkstoffe – sie sind Systeme, Denkweisen, Visionen. Sie verändern, wie wir bauen, kleiden, wohnen, kommunizieren. Wer heute mit Materialien arbeitet – sei es in Design, Architektur, Technik oder Forschung – bewegt sich in einem extrem spannenden Feld. Denn oft liegt die Zukunft nicht in neuen Technologien, sondern in den Stoffen, aus denen wir unsere Welt machen.
""";
