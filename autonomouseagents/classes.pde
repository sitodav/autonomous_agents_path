class Agent
{
  PVector absolutePosition, relativeVelocity, desideredRelativeVelocity;
  PVector relativeSteeringAccel; 
  float mass;  

  public  Agent(PVector position ,float mass )
  {
    relativeVelocity = new PVector(random(100), random(100));
    this.mass = mass;
    this.absolutePosition = position;
    this.relativeSteeringAccel = new PVector(0,0);
  }
  public void _draw()
  {
    pushMatrix();
    translate(absolutePosition.x, absolutePosition.y);
    stroke(0, 255);
    fill(0, 255);
    ellipse(0, 0, 5, 5);
    stroke(255, 0, 0);
    line(0, 0, relativeVelocity.x, relativeVelocity.y);
    fill(255, 0, 0);
    ellipse(relativeVelocity.x, relativeVelocity.y, 5, 5);

    textSize(12); 
    text("relative velocity", relativeVelocity.x, relativeVelocity.y);
    popMatrix();
  }
  
  public PVector computeInternalState(Path path)
  {

    PVector AXIS_START = new PVector(0, 0);

    PVector PATHSTART_ABSOLUTEV = path.start.get();
    PVector PATHEND_ABSOLUTEV = path.end.get();
    PVector PATH_V = PATHEND_ABSOLUTEV.get().sub(PATHSTART_ABSOLUTEV);
    PVector ABSOLUTEPOS_V = absolutePosition.get();
    PVector POSITION_RELATIVETOPATH_V = ABSOLUTEPOS_V.get().sub(PATHSTART_ABSOLUTEV); 
    float POSITIONONPATH_ANGLE = acos(PATH_V.dot(POSITION_RELATIVETOPATH_V)/(PATH_V.mag() * POSITION_RELATIVETOPATH_V.mag()));
    float POSITIONONPATH_SCALARPROJ = POSITION_RELATIVETOPATH_V.mag() * cos(POSITIONONPATH_ANGLE);
    PVector POSITIONONPATH_VECTORIALPROJONPATH = PATH_V.get().normalize().mult(POSITIONONPATH_SCALARPROJ);
  

    PVector VELOCITY_RELATIVEV = relativeVelocity.get();
    PVector PREDICTEDPOSITION_ABSOLUTEV = ABSOLUTEPOS_V.get().add(VELOCITY_RELATIVEV);
    PVector PREDICTEDPOSITION_RELATIVETOPATH_V = PREDICTEDPOSITION_ABSOLUTEV.get().sub(PATHSTART_ABSOLUTEV);
    float PREDICTEDPOSITIONONPATH_ANGLE = acos(PATH_V.dot(PREDICTEDPOSITION_RELATIVETOPATH_V)/(PATH_V.mag() * PREDICTEDPOSITION_RELATIVETOPATH_V.mag()));
    float PREDICTEDPOSITIONONPATH_SCALARPROJ = PREDICTEDPOSITION_RELATIVETOPATH_V.mag() * cos(PREDICTEDPOSITIONONPATH_ANGLE);
    PVector PREDICTEDPOSITIONONPATH_VECTORIALPROJONPATH = PATH_V.get().normalize().mult(PREDICTEDPOSITIONONPATH_SCALARPROJ);
    
    PVector PREDICTED_POSITION_NORMALVECTOR = PATHSTART_ABSOLUTEV.get().add(PREDICTEDPOSITIONONPATH_VECTORIALPROJONPATH).get().sub( PREDICTEDPOSITION_ABSOLUTEV );
    
    drawVector(PATHSTART_ABSOLUTEV, PREDICTEDPOSITIONONPATH_VECTORIALPROJONPATH, color(0, 0, 255), "predicted position vectorial proj");
    drawVector(PATHSTART_ABSOLUTEV, POSITIONONPATH_VECTORIALPROJONPATH, color(0, 255, 0), "actual position vectorial proj");
    if (SHOW_ABSOLUTE)
    {
      drawVector(AXIS_START, PATHSTART_ABSOLUTEV, color(0, 0, 0), "path start");
      drawVector(AXIS_START, PATHEND_ABSOLUTEV, color(0, 0, 0), "path end");
      drawVector(AXIS_START, ABSOLUTEPOS_V, color(0, 0, 0), "absolute actual position");
      drawVector(AXIS_START, PREDICTEDPOSITION_ABSOLUTEV, color(255, 0, 0), "absolute predicted position");
      drawVector(AXIS_START, POSITION_RELATIVETOPATH_V, color(0, 255, 0), "position relative to path");
    }
    if (SHOW_NORMALS)
    {

      drawVector(ABSOLUTEPOS_V, PATHSTART_ABSOLUTEV.get().add(POSITIONONPATH_VECTORIALPROJONPATH).get().sub( ABSOLUTEPOS_V ), color(0, 0, 0, 90), " "); 
      drawVector(PREDICTEDPOSITION_ABSOLUTEV, PREDICTED_POSITION_NORMALVECTOR, color(0, 0, 0, 90), " ");
    }
    return PREDICTED_POSITION_NORMALVECTOR;
  }
  
  public void updatePosition(PVector target)
  {

    PVector desideredVel = PVector.sub(target, absolutePosition);
    /*slow down if in radius */
    float desideredVelMag = desideredVel.mag();
    desideredVel.normalize();
    if (desideredVelMag < 100) //slow down
    {
      desideredVel.mult(map(desideredVelMag, 0, 100, 0, FULL_SPEED));
    } else //...go max speed
    {
      desideredVel.mult(FULL_SPEED);
    }


    PVector steer = PVector.sub(desideredVel, relativeVelocity);

    relativeSteeringAccel.add(steer);
    relativeSteeringAccel.mult(1.0/mass);

    relativeVelocity.add(relativeSteeringAccel);
    relativeVelocity.limit(FULL_SPEED);
    absolutePosition.add(relativeVelocity);
    relativeSteeringAccel.mult(0.0);
  }
}
