##### Tarik Badawy 02.01.2020
# Sonnensystem Euler

Für die berechnung der Gravitationskraft wurde Newton verwendet. Die entstehenden Differentialgleichungenwerden mit dem expliziten Euler-Verfahren numerisch gelöst.

Die Anwendung kann ohne weiteres gestartet werden zudem 
der Code ist einigermaßen kommentiert 

Die Anwendung lässt sich ein wenig durch Eingabe kontrollieren:

| Input                                       | Funktion                        |
| --------------------------------------------|---------------------------------|
| **<kbd>+</kbd>, <kbd>-</kbd>, Mausrad**     | Rein- und rauszoomen            |
| **<kbd>RECHTE Maustaste</kbd>+Ziehen**      | Umsehen                         |
| **<kbd>RECHTE Maustaste</kbd> auf Planeten**| Planeten fokusieren             |
| **<kbd>D</kbd>+<kbd>RECHTE Maustaste</kbd>**| Lineal                          |
| **<kbd>P</kbd> Clicken und Ziehen**         | Probekörper einfügen            |
| **<kbd>CTRL</kbd>,<kbd>SHIFT</kbd>**        | Delta-Zeit ändern               |
| **<kbd>LEER</kbd>**                         | Simulation pausieren            |
| **<kbd>&uarr;</kbd> und <kbd>&darr;</kbd>** | Probekörper Masse manipulieren  |
| **<kbd>&larr;</kbd> und <kbd>&rarr;</kbd>** | Probekörper Radius manipulieren |
| **<kbd>LINKE Maustaste</kbd>**              | Aktion abbrechen                |

## Delta-Zeit
Die *Delta-Zeit* ist die Schrittweite die das *Explizite Euler-Verfahren* als Parameter für die Annäherung nimmt. Das *Explizite Euler-Verfahren* ist ein Numerisches Verfahren 1. Ordnung: es gilt je höher die Schrittweite (*Delta-Zeit*)
desto stärker weicht die numerische Lösung von der tatsächlichen ab.

## Lineal
Mit dem *Lineal* lassen sich Kann man sich die Distanz zwischen zwei Punkten ausgeben lassen. Wendet man das Tool auf einen Planeten an, so folgt es diesem.

## Probekörper
Die Masse und der Radius des Probekörpers lassen sich vor dem einfügen mithlfe der Tasten <kbd>&uarr;</kbd>, <kbd>&darr;</kbd>, <kbd>&larr;</kbd> und <kbd>&rarr;</kbd> festlegen. Die Geschwindigkeit des Probekörpers wird von der Distanz der Mausposition zwischen Click und Loslassen der Maus bestimmt. Während der Körper eingefügt wird, sieht wo sich dieser in den nächsten 500 Frames befindet. Auch hier ist die Schrittweite von der Delta-Zeit abhängig.
