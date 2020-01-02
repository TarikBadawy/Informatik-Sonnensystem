/**
 * Komponenete des Features Planeten einzufügen. Ein Probekörper
 * ist nur temporär Instanziert (solange der Benutzer im Prozess ist
 * ein Probekörper einzufügen). Erbt von der Klasse Himmelskoerper, da
 * beide Klassen viele Felder und Methoden teilen.
 */
class Probekoerper extends Himmelskoerper
{
  int preview_amount = 500; // Anzahl der Angezeigten zukünftigen Punkte;
  PVector pos0, vel0;

  Probekoerper(PVector start_pos, float _masse, float _durchmesser)
  {
    pos0 = start_pos;
    masse = _masse;
    durchmesser = _durchmesser;
    name = "Probe";
  }

  /**
   * Stellt ,ähnlich wie beim Planeten, den Probekörper auf dem Bilschirm dar.
   */
  void Display()
  {
    vel0 = PVector.sub(pos0, new PVector(smouseX, smouseY)).mult(scale*1e3);

    pos = pos0.copy();
    vel = vel0.copy();

    //kopiert die Werte der Instanzen, um eine Art simlutiertes Sonnensystem zu erlangen.
    ArrayList<Himmelskoerper> simulierte_planeten = new ArrayList<Himmelskoerper>();
    for (Himmelskoerper planet : planeten)
    {
      Himmelskoerper sim_planet = new Himmelskoerper(
        planet.masse,
        planet.pos.copy(),
        planet.vel.copy(),
        planet.durchmesser,
        planet.name,
        planet.rgb,
        0
      );
      simulierte_planeten.add(sim_planet);
    }
    simulierte_planeten.add(this);

    for (int i = 0; i < preview_amount; i++)
    {
      for (Himmelskoerper sim_planet : simulierte_planeten)
      {
        sim_planet.Euler(simulierte_planeten, dt);
      }

      float farbe = map(i, 0, preview_amount, 0, 255);
      fill(farbe);
      ellipse(pos.x, pos.y, durchmesser, durchmesser);
    }
  }
}
