import processing.opengl.*;
import igeo.*;

void setup(){
  size(480, 360, IG.GL);
 
  IG.darkBG();
  IG.duration(3000); //I've shortend the duration to 3000, which halts the process, but not program, in about 1 min on my desktop
  IG.open("curve_field.3dm");
//  new IGravity(0,0,0);  //instantiate gravity force
  
  
  
  
  IG.p(IG.duration());
  
  
  
  /* --- BEGIN GEOMETRIES --- */
  
  //ISurface[] fieldSurfaces = IG.layer("field").surfaces();
  //for(int i=0; i < fieldSurfaces.length; i++)
  //  {
  //    new ISurfaceSlopeField(fieldSurfaces[i]).gaussian(50).intensity(15); //switched to gaussian field decay, which seems to have moved things along a bit.
  //  }
  
  /* --- curve attractor ---*/
    /*----------------first curve------------*/
//ICompoundField field = new ICompoundField();
  for(int i=0; i< IG.layer("curve").curveNum(); i++){
    new ICurveTangentField(IG.curve(i)).intensity(40).gaussian(100);
  }
  for(int i=0; i< IG.layer("normalCurve").curveNum(); i++){
//    new ICurveAttractorField(IG.curve(i)).intensity(13).gaussian(50);  //adds field normal to the curve
    new ICurveAttractorField(IG.curve(i)).intensity(40).gaussian(100);  //adds field normal to the curve
  }
    /*----------------END first curve------------*/
    /*----------------Repellers------------*/
  for(int i=0; i< IG.layer("repel").curveNum(); i++){
    new ICurveAttractorField(IG.curve(i)).intensity(-200).gaussian(40);
  }

    /*----------------END repellers------------*/
  /* --- END curve attractor ---*/
  new IAttractor(300,0,10).intensity(18);
    
  /* --- END GEOMETRIES --- */
  
  /* --- BEGIN VISUALIZATION OF FIELD --- */
  
  IFieldVisualizer visualizer = new IFieldVisualizer(-150,-100,-100, 150,100,100,20,10,10);
  //new IFieldVisualizer(-100,-100,1, 100,100,1, 40,40,1);
  visualizer.fixLength(false);  //changed magnitude of field vectors to be proportional to the slope of the surface
  
  /* --- END VISUALIZATION OF FIELD --- */
  
  IGeometry[] geometries = IG.layer("particle").geometries();
  for(int i=0; i < geometries.length; i++){
    println(i);
    IBoid b = new IBoid(geometries[i]).fric(0.03); // reduced .fric(0.2) to .1, which seems to have reduced the birds inertia
        b.cohesionDist(20);
        b.cohesionRatio(1.2);
        b.separationRatio(4.0);
        b.separationDist(30.0);
        b.alignmentRatio(3.0);
        b.alignmentDist(30.0);     
  }
  
  IG.p("ping");
}

class MyBoid extends IParticle{
  double cohesionDist;
  double cohesionRatio;
  double separationDist;
  double separationRatio;
  double alignmentDist;
  double alignmentRatio;

  IVec prevPos;

  MyBoid(IVec p, IVec v){ super(p,v); }

  void cohere(ArrayList< IDynamics > agents){
    IVec center = new IVec(); //zero vector
    int count = 0;
    for(int i=0; i < agents.size(); i++){
      if(agents.get(i) instanceof MyBoid && agents.get(i)!=this){
        MyBoid b = (MyBoid)agents.get(i);
        if(b.pos().dist(pos()) < cohesionDist){
          center.add(b.pos());
          count++;
        }
      }
    }
    if(count > 0){
      push(center.div(count).sub(pos()).mul(cohesionRatio));
    }
  }

  void separate(ArrayList< IDynamics > agents){
    IVec separationForce = new IVec(); //zero vector
    int count = 0;
    for(int i=0; i < agents.size(); i++){
      if(agents.get(i) instanceof MyBoid && agents.get(i)!=this){
        MyBoid b = (MyBoid)agents.get(i);
        double dist = b.pos().dist(pos());
        if(dist < separationDist && dist!=0 ){
          separationForce.add(pos().dif(b.pos()).len(separationDist - dist));
          count++;
        }
      }
    }
    if(count > 0){
      push(separationForce.mul(separationRatio/count));
    }
  }

  void align(ArrayList< IDynamics > agents){
    IVec averageVelocity = new IVec(); //zero vector
    int count = 0;
    for(int i=0; i < agents.size(); i++){
      if(agents.get(i) instanceof MyBoid && agents.get(i) != this){
        MyBoid b = (MyBoid)agents.get(i);
        if(b.pos().dist(pos()) < alignmentDist){
          averageVelocity.add(b.vel());
          count++;
        }
/* limit rotation angle inin positive rotation direction*/
//        if((b.rot().ANGLE(SECOND ARGUMENT)) > (PI/12)) && (b.rot().(SECOND ARGUMENT)) < (11*PI/12))){
//          b.rot(ROTATION AXIS, PI/12);
//        }
// how do you access just the second argument so we can limit just the angle and keep the rotation vector
/* limit rotation angle */
      }
    }
    if(count > 0){
      push(averageVelocity.div(count).sub(vel()).mul(alignmentRatio));
    }
  }
  
  void interact(ArrayList< IDynamics > agents){
    cohere(agents);
    separate(agents);
    align(agents);
  }

  void update(){ //drawing line
    IVec curPos = pos().cp();
    if(prevPos!=null){ IG.crv(prevPos, curPos).clr(clr()); }
    prevPos = curPos;
  }
}
