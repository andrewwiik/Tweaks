// Andrew Wiik
// Java Lab 4 part b?
// I am extremely tired so don't expect tons of comments
// least i gave you correct tabbing


import java.awt.*;
import java.applet.*;
public class Lab04bvst extends Applet {
    public void paint(Graphics g)
    {
        // DRAW CUBE

        int cubeXOrigin = 10;
        int cubeYOrigin= 20;
        int cubeSize = 200;
        g.drawRect(cubeXOrigin,cubeYOrigin,cubeSize,cubeSize);


        int cubeOffset = 80;
        g.drawRect(cubeXOrigin+cubeOffset,cubeYOrigin +cubeOffset,cubeSize,cubeSize);

         //top
        g.drawLine(cubeXOrigin,cubeYOrigin,cubeXOrigin+cubeOffset,cubeYOrigin +cubeOffset);
        g.drawLine( (cubeXOrigin+cubeSize),cubeYOrigin,cubeXOrigin+cubeOffset+cubeSize,cubeYOrigin +cubeOffset);
        //bottom
        g.drawLine(cubeXOrigin,cubeYOrigin+cubeSize,cubeXOrigin+cubeOffset,cubeYOrigin +cubeOffset +cubeSize);
        g.drawLine(cubeXOrigin+cubeSize,cubeYOrigin+cubeSize,cubeXOrigin+cubeOffset+cubeSize,cubeYOrigin +cubeOffset +cubeSize);

        // DRAW SPHERE
        int sXOrigin = cubeXOrigin + (int)(cubeOffset *.5);
        int sYOrigin= cubeYOrigin + (int)(cubeOffset *.5);
        int sSize = cubeSize;
        int sMidY = (int)(.5*sSize) + sYOrigin;
        int sMidX = (int)(.5*sSize) + sXOrigin;

        g.drawOval(sXOrigin,sYOrigin,sSize,sSize);


        double heightCoefficient  = .5;
        g.drawOval(sXOrigin, sMidY-(int)(.5*(sSize*heightCoefficient)),sSize,((int)(heightCoefficient*sSize)));

        heightCoefficient  = .75;
        g.drawOval(sXOrigin, sMidY-(int)(.5*(sSize*heightCoefficient)),sSize,((int)(heightCoefficient*sSize)));

        heightCoefficient  = .25;
        g.drawOval(sXOrigin, sMidY-(int)(.5*(sSize*heightCoefficient)),sSize,((int)(heightCoefficient*sSize)));


        double widthCoefficient  = .5;
        g.drawOval(sMidX-(int)(.5*(sSize*widthCoefficient)), sYOrigin,((int)(widthCoefficient*sSize)),sSize);

        widthCoefficient  = .25;
        g.drawOval(sMidX-(int)(.5*(sSize*widthCoefficient)), sYOrigin,((int)(widthCoefficient*sSize)),sSize);

        widthCoefficient  = .75;
        g.drawOval(sMidX-(int)(.5*(sSize*widthCoefficient)), sYOrigin,((int)(widthCoefficient*sSize)),sSize);


        // DRAW INSCRIBED/CIRCUMSCRIBED TRIANGLE
        // don't have the brain power left to do this with math ugh
	   g.drawOval(400,400,200,200);
		int[] triX = {500,425,575};
		int[] triY = {400,566,566};
		g.drawPolygon( triX,triY, triX.length);
		g.drawOval(451,468,98,98);



        // DRAW APCS
		int wordXOrigin = 20;
		int wordYOrigin = 400;

		int axPoly[] = {0,  0, 20,20,40, 40, 60, 60,0};
		int ayPoly[] = {0,100,100,60,60,100,100,  0,0};
		g.fillPolygon(translate(wordXOrigin,axPoly),translate(wordYOrigin,ayPoly),axPoly.length);
		g.setColor(Color.white);
		g.fillRect(20+wordXOrigin,20+wordYOrigin,20,20);

		g.setColor(Color.black);
		int pxPoly[] = {80, 80,100,100,140,140, 80};
		int pyPoly[] = { 0,100,100, 60, 60,  0,  0};
		g.fillPolygon(translate(wordXOrigin,pxPoly),translate(wordYOrigin,pyPoly),pxPoly.length);
		g.setColor(Color.white);
		g.fillRect(100+wordXOrigin,20+wordYOrigin,20,20);

		g.setColor(Color.black);
		int cxPoly[] = {160,160,220,220,180,180,220,220,160};
		int cyPoly[] = {  0,100,100, 80, 80, 20, 20,  0,  0};
		g.fillPolygon(translate(wordXOrigin,cxPoly),translate(wordYOrigin,cyPoly),cxPoly.length);

		int sxPoly[] = {240,240,280,280,240,240,300,300,260,260,300,300,240};
		int syPoly[] = {  0, 60, 60, 80, 80,100,100, 40, 40, 20, 20, 0, 0};
		g.fillPolygon(translate(wordXOrigin,sxPoly),translate(wordYOrigin,syPoly),sxPoly.length);


        // DRAW PACMEN FLOWER
		//top, left, bottom ,right
		int spread = 65;
		int size = 100;
		int xOrigin = 375;
		int yOrigin = 100;
	   	g.fillArc(xOrigin,yOrigin,size,size, 135,270);
		g.fillArc(xOrigin-spread,yOrigin + spread,size,size, 225,270);
		g.fillArc(xOrigin,yOrigin + spread*2,size,size, 315,270);
		g.fillArc(xOrigin+spread,yOrigin + spread,size,size, 45,270);


    }
    public static void drawSphere(int sXOrigin,int sYOrigin,int sSize) {

      }
	public static int[] translate(int factor, int[]target){
		int[] returnArray = new int[target.length];

		int tempValue;

		for(int i= 0; i<target.length; i++){
			tempValue = target[i] + factor;
			returnArray[i]=tempValue;
		}
		return returnArray;
	}
}

// there is a reason I like Objective-C more, one of them is I am allowed to stuff with a view heichary that I'm used to, even HTML has a DOM, get with it java