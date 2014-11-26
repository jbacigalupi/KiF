import processing.opengl.*;
import igeo.*;

size(480, 360, IG.GL);



IG.darkBG();
IG.duration(3000); //I've shortend the duration to 3000, which halts the process, but not program, in about 1 min on my desktop
IG.open("curve_field.3dm");
new IGravity(0,0,0);  //instantiate gravity force




IG.p(IG.duration());



/* --- BEGIN GEOMETRIES --- */

ISurface[] fieldSurfaces = IG.layer("field").surfaces();
for(int i=0; i < fieldSurfaces.length; i++)
  {
    new I2DSurfaceSlopeField(fieldSurfaces[i]).gaussian(50).intensity(20); //switched to gaussian field decay, which seems to have moved things along a bit.
  }
  
//new IAttractor(0,45,0).intensity(-2);
//new IAttractor(80,-50,0).intensity(-4);
new IAttractor(100,-10,0).intensity(-10).gaussianDecay(50.0);
//a1.gaussianDecay(5);
new IAttractor(150,0,0).intensity(10);
  
/* --- END GEOMETRIES --- */

new IFieldVisualizer(-100,-50,-50, 100,50,50,20,10,10);
//new IFieldVisualizer(-100,-100,1, 100,100,1, 40,40,1);

IGeometry[] geometries = IG.layer("particle").geometries();
for(int i=0; i < geometries.length; i++){
  println(i);
  IBoid b = new IBoid(geometries[i]).fric(0.05); // reduced .fric(0.2) to .1, which seems to have reduced the birds inertia
//      b.cohesionDist(13);
//      b.cohesionRatio(1.5);
//      b.separationRatio(7.0);
//      b.separationDist(10.0);
//      b.alignmentRatio(7.0);
//      b.alignmentDist(30.0);
//    b.cohesionDist(30);
//    b.cohesionRatio(1.5);
//    b.separationDist(25);
//    b.separationRatio(6);
//    b.alignmentDist(15);
//    b.alignmentRatio(3);
//      b.cohesionDist(30);
//      b.cohesionRatio(1.5);
//      b.separationRatio(4.0);
//      b.separationDist(30.0);
//      b.alignmentRatio(7.0);
//      b.alignmentDist(30.0);
      b.cohesionDist(29);
      b.cohesionRatio(1.5);
      b.separationRatio(4.0);
      b.separationDist(30.0);
      b.alignmentRatio(7.0);
      b.alignmentDist(30.0);     
      
}

IG.p("ping");
