 public void drawVector(PVector centerIn, PVector vectorToDraw, color col, String label)
  {
    if (null != centerIn)
    {
      pushMatrix();
      translate(centerIn.x, centerIn.y);
    }

    stroke(col);
    line(0, 0, vectorToDraw.x, vectorToDraw.y);
    fill(col);
    //ellipse(vectorToDraw.x, vectorToDraw.y, 5, 5);
    pushMatrix();
      translate(vectorToDraw.x,vectorToDraw.y);
      rectMode(CENTER);
      noFill();
      rect(0,0,5,5);
    popMatrix();
    if (label != null)
    {
      
      textSize(12); 
      text(label, vectorToDraw.x, vectorToDraw.y+10);
    }
    if (null != centerIn)
    {
      popMatrix();
    }
  }
