/**
 * @author Tarik
 */

class Himmelskoerper
{ 
  Himmelskoerper() {
  }
  float masse, durchmesser, grosse_halbachse;
  PVector pos, vel;
  String name;
  color rgb;
  Himmelskoerper(JSONObject obj)
  {
    float masse = obj.getFloat("mass");
    float durchmesser = obj.getFloat("diameter");
    float[] pos = obj.getJSONArray("position").getFloatArray();
    float[] vel = obj.getJSONArray("velocity").getFloatArray();
    String name = obj.getString("name");
    int[] rgb = obj.getJSONArray("rgb").getIntArray();
    float grosse_halbachse = obj.getFloat("grosse-halbachse");

    this.masse = masse;
    this.pos = new PVector(pos[0], pos[1]);
    this.vel = new PVector(vel[0], vel[1]);
    this.durchmesser = durchmesser;
    this.name = name;
    this.rgb = color(rgb[0], rgb[1], rgb[2]);
    this.grosse_halbachse = grosse_halbachse;
  }
  
  Himmelskoerper(float masse, PVector pos, PVector vel, float durchmesser, String name, color rgb, float grosse_halbachse)
  {
    this.masse = masse;
    this.pos = pos;
    this.vel = vel;
    this.durchmesser = durchmesser;
    this.name = name;
    this.rgb = rgb;
    this.grosse_halbachse = grosse_halbachse;
  }
  /**
   * Ein Verfahren um Differntialgleichungen numerisch zu lösen.
   * @param planeten  Liste der Planeten im System
   * @param h         Die Schrittweite für die Annäherung. Je niedriger desto genuaer
   */
  protected void Euler(ArrayList<Himmelskoerper> planeten, float h)
  {
    PVector acc = Superposition(planeten, pos.x, pos.y);
    vel.add(PVector.mult(acc, h));
    pos.add(PVector.mult(vel, h));
  }

  /**
   * @return boolean Gibt zurück ob der Benutzer das Obejkt löscht
   */
  boolean Ausschneiden()
  {
    return keyPressed && key == 'x' && Hover();
  }

  /**
   * @return boolean Gibt zurück ob die Maus über dem Objekt ist
   */
  boolean Hover()
  {
    return dist(smouseX, smouseY, pos.x, pos.y) < (max(durchmesser / 2.0, 15.0/scale));
  }

  /**
   * Stellt den Planeten auf dem Bilschirm dar.
   */
  void Display()
  { 
    float rahmen = max(durchmesser, 30.0/scale); //Durchmesser des Runden Kreises um den Planeten, wenn dieser nicht zu sehen ist.
    
    noFill();
    strokeWeight(2.0/scale);
    stroke(rgb);
    ellipse(pos.x, pos.y, rahmen, rahmen);
    
    fill(rgb);
    noStroke();
    ellipse(pos.x, pos.y, durchmesser, durchmesser);
    
    if (Hover() == true) { fill(rgb); }
    else { fill(255); }
    textSize(20.0/scale);
    Text(name, pos.x + rahmen, pos.y);
  }
}
