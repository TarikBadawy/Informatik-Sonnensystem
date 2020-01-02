ArrayList<Himmelskoerper> planeten = new ArrayList<Himmelskoerper>(); //<>//
final float G = 6.674e-11;
float dt = 1.0; //Die Delta-Zeit
float x0, y0, scale, smouseX, smouseY;
int probe_mass = 24; //in Zehnerpotenzen
int probe_radius = 10; //in Zehnerpotenzen
boolean paused, probe_aktiv, zeige_distanz;
PVector dist1, dist2;
Probekoerper probe;
Himmelskoerper deletion, fokus;

void setup() {
  frameRate(60);
  size(1000, 1000);

  //Die beiliegende JSON-Datei "planeten-info.json" besitzt die Informationen zu den Planeten
  JSONArray data = loadJSONArray("../planeten-info.json");

  for (int i = 0; i < data.size(); i++) {
    planeten.add(new Himmelskoerper(data.getJSONObject(i)));
  }
  
  scale = 2.2e-9;
  y0 = (width/2.0)/scale;
  x0 = (width/2.0)/scale;
}

void draw() {
  background(0);
  shapeMode(CENTER);
  textSize(20.0);
  fill(255);
  
  String planet_info = "";
  if(fokus != null) {
    planet_info =
      "\n Planet: " + fokus.name +
      "\n Masse: " + fokus.masse + " kg" +
      "\n Geschwindigkeit: " + fokus.vel.mag() + " m/s" +
      "\n Durchmesser: " + fokus.durchmesser + " m";
  }
  
  text(
    "\n Delta t: "+dt+ " s  'SHIFT, STRG'"+
    "\n Probekörper Masse: 10^"+ probe_mass +" kg  'UP, DOWN'"+
    "\n Probekörper Radius: 10^"+ probe_radius +" m  'LEFT, RIGHT'"+
    "\n Zoom: 'SCROLL'"+
    "\n" + planet_info
  , 0, 0);
  
  scale(scale);
  Update_sMouse_Pos();

  for (Himmelskoerper planet : planeten) {
    if (!paused) {
      planet.Euler(planeten, dt);
    }
    if (planet.Ausschneiden()) {
      deletion = planet;
    }
  }
  if (deletion != null) {
    planeten.remove(deletion); 
    deletion = null;
  }

  if (fokus == null) {
    translate(x0, y0);
  } else
  {
    x0 = lerp(x0, (width/2.0)/scale - fokus.pos.x, constrain(scale*1e7, 0.03, 1));
    y0 = lerp(y0, (width/2.0)/scale - fokus.pos.y, constrain(scale*1e7, 0.03, 1));
    translate(x0, y0);
  }

  for (Himmelskoerper planet : planeten)
  {
    planet.Display(); //Stellt die Planeten dar
  }

  if (probe_aktiv && probe == null) {
    ellipse(smouseX, smouseY, width/(scale*100), height/(scale*100));
  }
  if (probe != null) {
    probe.Display();
  }
  if (zeige_distanz) {
    Zeige_Distanz();
  }
}

/**
 * Berechnet die Beschleunigung mit Newtons Gravitationsgesetz.
 * @param planet  Planet zu dem beschleunigt wird
 * @param x       x-Position auf die die Beschleunigung wirkt
 * @param y       y-Position auf die die Beschleunigung wirkt
 * @return Beschleunigung von P(x,y) zum Planeten
 */
PVector Newtonsches_Gravitationsgesetz (Himmelskoerper planet, float x, float y)
{
  if (planet.pos.x == x && planet.pos.y == y)
  {
    return new PVector();
  }
  PVector r = PVector.sub(planet.pos, new PVector(x, y)); //Riichtungsvektor von diesem Punkt (x,y) zum gegebenen Planeten
  float mag = G * planet.masse / sq(r.mag());
  PVector a = r.setMag(mag);
  return a;
}

/**
 * Berechnet die summe aller Kräfte die auf dieses Objekt wirken auch "Superpositionsprinzip"
 * @param planeten  Liste der Planeten im System zu den beschleunigt wird.
 * @param x         x-Position auf die die Beschleunigung wirkt
 * @param y         y-Position auf die die Beschleunigung wirkt
 * @return Durchschnittliche Bechleuningung im System
 */
PVector Superposition(ArrayList<Himmelskoerper> planeten, float x, float y)
{
  PVector acc = new PVector();
  for (Himmelskoerper planet : planeten)
  {
    acc.add(Newtonsches_Gravitationsgesetz(planet, x, y));
  }
  return acc;
}


/**
 * Aktualisiert die globalen Variabeln "smouseX" und "smouseY", welche
 * ähnlich wie "mouseX" und "mouseY", jedoch nicht relativ zum Bildschirm
 * sondern relativ zum Sonnensystem im realen Maßstab, sind.
 */
private void Update_sMouse_Pos()
{
  PVector pos = Bildschirm_zu_Sonnensystem(mouseX, mouseY);
  smouseX = pos.x;
  smouseY = pos.y;
}

private PVector Bildschirm_zu_Sonnensystem(float x, float y)
{
  return  new PVector((x/scale)-x0, (y/scale)-y0);
}

/**
 * Ein Feature, welches Distanzen im Sonnensystem anzeigen kann.
 */
void Zeige_Distanz()
{
  fill(255);
  stroke(255);
  strokeWeight(width/(scale*250));

  if (dist1 == null && dist2 == null)
  {
    point(smouseX, smouseY);
  } else if (dist1 != null)
  {
    PVector pointer;
    if (dist2 != null) {
      pointer = dist2;
    } else {
      pointer = new PVector(smouseX, smouseY);
    }

    float distanz = dist(dist1.x, dist1.y, pointer.x, pointer.y);
    line(dist1.x, dist1.y, pointer.x, pointer.y);
    Text(" Distanz: " + distanz +" Meter", -x0, (height/2)/scale-y0);
  }
}

/**
 * Stellt einen Text an den gegebenen Koordinaten dar.
 * verwendet "translate" zur Positionierung, da die Parameter der "text"
 * Funktion Fehler aufweisen
 * @param str Text, welcher auf dem bildschirm dargestellt werden soll
 * @param x   x-Position des Textes
 * @param y   y-Position des Textes
 * @return Durchschnittliche Bechleuningung im System
 */
void Text(String str, float x, float y)
{
  translate(x, y);
  text(str, 0, 0);
  translate(-x, -y);
}

float getExponent(float x) {
  return (float)Math.log10(x);
}

//Der Rest der Datei ist Benutzer-Input
//Die Input Möglichkeiten werden in README erklärt
void keyPressed()
{
  if (key == '+') {
    scale *= 1.05;
  } else if (key == '-') {
    scale /= 1.05;
  } else if (key == 'p' && probe == null && !zeige_distanz) {
    probe_aktiv = !probe_aktiv;
  } else if (key == 'd' && !zeige_distanz && !probe_aktiv) {
    zeige_distanz = true;
  } else if (key == 'd' && zeige_distanz) {
    zeige_distanz = false; 
    dist1 = null; 
    dist2 = null;
  }
  switch(keyCode)
  {
  case SHIFT:
    dt *= 2;           
    break;
  case CONTROL:
    dt /= 2;           
    break;
  case UP:
    probe_mass += 1;    
    break;
  case DOWN:
    probe_mass -= 1;    
    break;
  case RIGHT:
    probe_radius += 1;  
    break;
  case LEFT:
    probe_radius -= 1;  
    break;
  case 32: // Leertaste
    paused = !paused;   
    break;
  default:
    break;
  }
}

void mousePressed()
{
  if (mouseButton == LEFT)
  {
    Himmelskoerper clicked_planet = null;
    for (Himmelskoerper planet : planeten)
    {
      if (planet.Hover()) {
        clicked_planet = planet;
      }
    }

    if (probe == null && probe_aktiv)
    {
      PVector pos = new PVector(smouseX, smouseY);
      float mass = pow(10.0, probe_mass);
      float radius = pow(10.0, probe_radius);
      probe = new Probekoerper(pos, mass, radius);
    }

    if (zeige_distanz)
    {
      if (dist1 == null && clicked_planet != null) {
        dist1 = clicked_planet.pos;
      } else if (dist2 == null && clicked_planet != null) {
        dist2 = clicked_planet.pos;
      } else if (dist1 == null) {
        dist1 = new PVector(smouseX, smouseY);
      } else if (dist2 == null) {
        dist2 = new PVector(smouseX, smouseY);
      }
    }

    if (!zeige_distanz && !probe_aktiv && clicked_planet != null)
    {
      fokus = clicked_planet;
    }
  } else if (mouseButton == RIGHT) // Aktion abbrechen
  {
    if (probe_aktiv && probe == null) {
      probe_aktiv = false;
    } else if (probe_aktiv && probe != null) {
      probe = null;
    }

    if (zeige_distanz && dist1 == null) {
      zeige_distanz = false;
    } else if (zeige_distanz && dist2 == null) {
      dist1 = null;
    } else if (zeige_distanz) {
      dist2 = null;
    }
  }
}

void mouseReleased()
{
  if (probe != null)
  {
    Himmelskoerper probePlanet = new Himmelskoerper(
      probe.masse,
      probe.pos0,
      probe.vel0,
      probe.durchmesser,
      probe.name,
      color(255),
      0
    );
    planeten.add(probePlanet);
    probe = null;
    probe_aktiv = false;
    paused = false;
  }
}

void mouseDragged()
{
  if ((!probe_aktiv && !zeige_distanz) || (dist1 != null && dist2 != null))
  {
    if (fokus != null) {
      fokus = null;
    }
    x0 += (mouseX - pmouseX)/scale;
    y0 += (mouseY - pmouseY)/scale;
  }
}

void mouseWheel(MouseEvent event)
{
  if (event.getCount() < 0)
  {
    x0 -= +mouseX/(scale*11);
    y0 -= +mouseY/(scale*11);
    scale *= 1.1;
  } else
  {
    x0 += mouseX/(scale*10);
    y0 += mouseY/(scale*10);
    scale /= 1.1;
  }
}
