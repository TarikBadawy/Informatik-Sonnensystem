import java.util.Arrays;

float scale = 2e-9;
float dt = 1.0; // lässt sich durch '.' und ',' verändern
float t = 0;
float[][] RKPlaneten; //[Planet Index][x-pos, y-pos, x-vel, y-vel]
float[] m;

void setup()
{
  background(0);
  frameRate(60);
  size(1000, 1000);
  noStroke();
  RKPlaneten = new float[][]
  {
    {0         , 0, 0, 0         },
    {6.9817e10 , 0, 0, 38859.0408},
    {1.089e11  , 0, 0, 34783.3023},
    {1.5214e11 , 0, 0, 29294.2780},
    {2.4923e11 , 0, 0, 21972.1685},
    {8.16e11   , 0, 0, 12440.0   },
    {1.5068e12 , 0, 0, 9128.0    },
    {3.00366e12, 0, 0, 6500.0    },
    {4.53923e12, 0, 0, 5397.0    },
  };
  
   m = new float[] {2e30, 3301e20, 4869e21, 59723e20, 6419e20, 1.9e27, 5.68e26, 8.683e25, 1.024e26};
}

void draw()
{
  background(0);
  fill(255);
  textSize(20.0);
  text("\n dt: " + dt, 0, 0);
  translate(width/2.0, height/2.0);
  scale(scale);

  fill(0, 255, 255);
  for(int i = 0; i < RKPlaneten.length; i++)
  {
    float x = RKPlaneten[i][0];
    float y = RKPlaneten[i][1];
    ellipse(x, y, 2.0/scale, 2.0/scale);
  }
  
  RKPlaneten = rk(t, RKPlaneten, dt);

  t += dt;
}

float[][] rk(float t, float[][] u, float h)
{
  float[][] k1 = f(t, u);
  float[][] k2 = f(t+h/2, vAdd(u, sMult(h/2.0, k1)));
  float[][] k3 = f(t+h/2, vAdd(u, sMult(h/2.0, k2))); 
  float[][] k4 = f(t, vAdd(u, sMult(h, k3)));
  
  return vAdd(u, sMult(h/6.0, vAdd(vAdd(k1, sMult(2, k2)), vAdd(sMult(2, k3), k4)))); 
}

float[][] f(float t, float[][] u)
{
  float[][] f = new float[u.length][4];
  for (int i = 0; i < u.length; i++)
  { 
    float[] acc = superposition(u[i][0], u[i][1], u);
    f[i][2] = acc[0]; // Ableitung der Geschwindigkeit
    f[i][3] = acc[1];
    
    f[i][0] = u[i][2]; // Ableitung der Position
    f[i][1] = u[i][3];
  }
  
  return f;
}

float[] superposition(float x, float y, float[][] u)
{
  float ax = 0; // Summe aller Kräfte
  float ay = 0;
  for (int i = 0; i < u.length; i++)
  {
    float xi = u[i][0];
    float yi = u[i][1];
    if (!(x == xi && y == yi))
    {
      float d = dist(x, y, xi, yi);
      ax += newton(x, xi, d, m[i]);
      ay += newton(y, yi, d, m[i]);
    }
  }
  return new float[] {ax, ay};
}

float newton(float p1, float p2, float d, float m)
{
  float F = ((6.674e-11 * m * (p2-p1)) / (d*d*d));

  return F;
}

float[][] sMult(float s, float[][] v)
{
  float[][] result = new float[v.length][4];
  for(int i = 0; i < v.length; i++)
  {
    for(int j = 0; j < v[i].length; j++)
    {
      result[i][j] = v[i][j] * s;
    }
  }
  return result;
}

float[][] vAdd(float[][] a, float[][] b)
{
  float[][] result = new float[a.length][4];
  for(int i = 0; i < a.length; i++)
  {
    for(int j = 0; j < a[i].length; j++)
    {
      result[i][j] = a[i][j] + b[i][j];
    }
  }
  return result;
}

void prin(float[][] matrix)
{
  println(Arrays.deepToString(matrix));
}

void keyPressed()
{
  switch(key)
  {
    case('+'):
    scale *= 1.1;
    break;

    case('-'):
    scale /= 1.1;
    break;
    
    case('.'):
    dt *= 2.0;
    break;
    
    case(','):
    dt /= 2.0;
    break;

  default:
    break;
  }
}
