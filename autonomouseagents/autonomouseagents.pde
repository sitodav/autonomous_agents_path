
PVector last; 
Path path;
Agent agent;
boolean SHOW_ABSOLUTE = false;
boolean SHOW_NORMALS = false;
float FULL_SPEED = 15;
float MASS =  50;
float PATH_RAY = 25;
boolean ANIMATE = false;

void setup()
{
  size(800, 800);
  println("PRESS : \n-FIRST MOUSE CLICK => PATH START POINT\n-SECOND MOUSE CLICK => PATH END POINT\n-TAB => SPAWN AUTONOMOUSE AGENT IN MOUSE LOCATION\n-BACKSPACE => SHOW ABSOLUTE VECTORS\n-ALT => SHOW NORMALS ON PATH\n-ENTER => ANIMATE");
}

void draw()
{
  background(255);

  if (path != null)
  {
    path._draw();
  }
  if (null != agent)
  {
    agent._draw();
  }

  if (null != path && null != agent)
  {
    PVector normalPredictedVector = agent.computeInternalState(path);
    if (!ANIMATE)
      return;
    if (PATH_RAY < normalPredictedVector.mag())
    {
      PVector target = agent.absolutePosition.get().add(normalPredictedVector);
      agent. updatePosition(target);
    } else 
    {
      PVector target = agent.relativeVelocity.get().add(agent.absolutePosition);
      agent.updatePosition(target);
    }
  }
}

void keyPressed()
{
  if (SHIFT == keyCode)
  {
    last = null;
    path = null;
  } else if (TAB == keyCode)
  {
    agent = new Agent(new PVector(mouseX, mouseY), MASS);
  } else if (BACKSPACE == keyCode)
  { 
    SHOW_ABSOLUTE = !SHOW_ABSOLUTE;
  } else if (ALT == keyCode)
  { 
    SHOW_NORMALS = !SHOW_NORMALS;
  } else if (ENTER == keyCode)
  { 
    ANIMATE = !ANIMATE;
  }
}
void mousePressed()
{
  if (last == null)
  {
    last = new PVector(mouseX, mouseY);
  } else if (null == path)
  {
    path = new Path(last, new PVector(mouseX, mouseY));
  }
}



class Path
{
  PVector start, end;

  public Path(PVector start, PVector end)
  {
    this.start = start; 
    this.end=end;
  }

  public void _draw()
  {
    pushMatrix();
    //translate(start.x,start.y);
    stroke(0, 250);
    line(start.x, start.y, end.x, end.y);
    popMatrix();
  }

  public PVector getAbsoluteVector()
  {
    return end.get().sub(start);
  }
}
