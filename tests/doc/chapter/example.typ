#import "@preview/htl3r-da:0.1.0" as htl3r

#htl3r.author("Julian Burger")
= Einführung Typst
Typst ist ein Markup-basierter Schrifftsatz, welcher entwickelt wurde, um genau so mächtig wie LaTeX zu sein, während er gleichzeitig simpel und einfach zu benutzen ist. Bei Unklarheiten ist die Dokumentation unter https://typst.app/docs/ aufzufinden. Falls allgemeine Fragen zur Umsetzung gewisser Konzepte aufkommen, so ist entweder das Forum (https://forum.typst.app/) oder der Discord-Server (https://discord.gg/2uDybryKPe) aufzusuchen.

== Warum wurde sich für Typst entschieden?
Innerhalb der Klasse 5CN im Schuljahr 2024/25 gab es mehrere Diplomarbeiten, welche Interesse an LaTeX gezeigt haben.
Allerdings war die existierende LaTeX-Vorlage unbrauchbar und die hohe Komplexität von LaTeX selbst ist für viele eine Zumutung.
Somit war klar, dass etwas neues gebraucht wird. Typst ist somit der perfekte Ersatz für LaTeX.

== Kompilierung einer Typst-Datei
Typst hat eine CLI, über welche die Quellcodedateien zu PDF kompiliert werden. Um eine Datei zu kompilieren, kann diese CLI folgend aufgerufen werden:
```bash
typst compile $DATEI
```

#htl3r.author("Viktor Kreuzer")
= Grundlagen

Der Autor des Kapitels muss explizit angegeben werden!

#htl3r.code()[
  ```typ
  #htl3r.author("Max Mustermann")
  ```
]

== Abbildungen
Damit die Abbildungen mit richtigem Spacing auf der Seite angezeigt werden, müssen sie mit der `fspace`-Funktion gewrappt werden.

Damit kann die Breite der Figure angepasst werden.

#htl3r.code()[
  ```typ
  #htl3r.fspace(
    total-width: 50%,
    figure(image("../assets/16x9.png"), caption: [Bild mit 16:9]),
  )
  ```
]

resultiert in:

#htl3r.fspace(
  total-width: 50%,
  figure(image("../assets/16x9.png"), caption: [Bild mit 16:9]),
)

#pagebreak()
Mit der `fspace`-Funktion können auch mehrere Figures nebeneinander gestellt werden.

#htl3r.code()[
  ```typ
  #htl3r.fspace(
    figure(image("../assets/16x9.png"), caption: [Bild mit 16:9]),
    figure(image("../assets/1x1.png"), caption: [Bild mit 1:1]),
  )
  ```
]

resultiert in:

#htl3r.fspace(
  figure(image("../assets/16x9.png"), caption: [Bild mit 16:9]),
  figure(image("../assets/1x1.png"), caption: [Bild mit 1:1]),
)

== Tabellen
Tabellen müssen auch mit der `fspace`-Funktion gewrappt werden.

#htl3r.code(caption: none, description: none, skips: ((3, 3),))[
  ```typ
  #htl3r.fspace(
    total-width: 100%,
    figure(table(columns: 3,
    ), caption: [Beispieltabelle])
  )
  ```
]

#htl3r.fspace(
  total-width: 100%,
  figure(
    table(
      columns: 3,
      table.header([Column1], [Column2], [Column3]),
      [Test1], [Test2], [Test3],
      [Daten1], [Daten2], [Daten3],
    ),
    caption: [Beispieltabelle],
  ),
)

== Codeblöcke
Für Codeblöcke gibt es eine eigene Funktion:

#htl3r.code()[
  #raw(
    block: true,
    lang: "typ",
    "#htl3r.code(caption: [Advanced Bash Skript], description: [Beispielcode])[
```bash
rm -rf /
```
]",
  )
]

Output:
"#htl3r.code(caption: [Advanced Bash Skript], description: [Beispielbefehl])[
  ```bash
  rm -rf /
  ```
]

#htl3r.code-file(lang: "bash", text: read("../assets/code-example.sh"))

== Abkürzungen
Die verwendeten Abkürzungen werden zentral in einer YAML-Datei definiert. \
Mithilfe dieser YAML-Datei wird das Abkürzungsverzeichnis generiert.

Beispiel:
```yaml
da: # <- Das ist der Key für die Abkürzung
  short:
    singular: DA
    plural: DA
  long:
    singular: Diplomarbeit
    plural: Diplomarbeiten
  description: Abschlussarbeit an einer HTL # Beschreibung für das Glossar
```

Diese Abkürzungen können im Dokument verwendet werden.

```typ
#htl3r.abbr.short[da] - // Kurzform Singular
#htl3r.abbr.shortpl[da] - // Kurzform Plural
#htl3r.abbr.long[da] - // Langform Singular
#htl3r.abbr.longpl[da] // Langform Plural
```

#htl3r.abbr.short[da] -
#htl3r.abbr.shortpl[da] -
#htl3r.abbr.long[da] -
#htl3r.abbr.longpl[da]
