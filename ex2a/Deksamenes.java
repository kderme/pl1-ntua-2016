import java.util.*;
import java.io.*;
import java.lang.*;
import java.math.*;
import java.text.DecimalFormat;

class Ydragwgeio
   {
   private int N;
   public Vector<Point> points; 
   public long Vmax;
   public double Hwater;
   public long Vwater;

   Ydragwgeio(int n){
     N = n;
     points = new Vector<Point>(2*N);
     Hwater = 0.0;
   }

   public void solve () throws Overflow
   {
//     find_Vmax();
    Collections.sort(points);
//    System.exit(0);
    int i;
    for(i=0; i<2*N; i++){
//	System.out.println(points.get(i).Height);
//	System.out.println(points.get(i).dVol);
    }
   long Vin = 0;
   long dv = 0;
   double same_dv_length;
   double h = 0.0;
   Point p;
   for(i=0;i<2*N;i++){
     if(dv==0)
	h = (double)points.get(i).Height;
     while(i<=2*N-1 && (h==points.get(i).Height)){
	dv +=points.get(i).dVol;
	i++;
     }
     i--;
          
//   System.out.println(h+" "+dv+" "+Vin+" "+Vwater);
     if(i>=2*N-1 && Vin>Vwater){
	throw new Overflow();
     }

//     if(i==2*N-2)
//	throw new Overflow();
     
     same_dv_length = (double)points.get(i+1).Height-h;
     if(same_dv_length*dv+Vin <= Vwater){
	Vin += same_dv_length*dv;
	h = points.get(i+1).Height;
     }
     else{
	h = 1.0*h + (Vwater - Vin)/(1.0*dv);
	Vin = Vwater;
     }
     if(Vin==Vwater){
	Hwater = h;
	break;
     }
     
   }
   }
}

class Point implements Comparable<Point>
{
   public int Height;
   public int dVol;

   Point(int h,int dv)
   {
     Height = h;
     dVol = dv;
   }

   public int compareTo(Point two){
     return Height-two.Height;
   }
}

class Overflow extends Exception
{
   public Overflow()
   {
     super("Overflow");
   }
}

public class Deksamenes{

   public static void main(String[] args)
   {
     if(args.length!=1){
	System.out.println("Usage: Java Deksamenes input.txt");
	System.exit(1);
     }
     Scanner sc = null;
     try { sc = new Scanner(new File(args[0]));}
     catch(FileNotFoundException e) {
	System.out.println("File Not Found");
	System.exit(1);
     }
     int N = sc.nextInt();
     Point p;
     int s,f,x,y,i;
     double max=0.0;
     Ydragwgeio udragwgeio = new Ydragwgeio(N);
     for(i=0; i<N; i++){
	s = sc.nextInt();
	f = sc.nextInt();
	x = sc.nextInt();
	y = sc.nextInt();
	p = new Point(s, x*y);
	udragwgeio.points.addElement(p);
	p = new Point(s+f, -x*y);
	udragwgeio.points.addElement(p);
     }
     udragwgeio.Vwater = sc.nextLong();
     try {udragwgeio.solve();}
     catch (Overflow e){
	System.out.println(e.getMessage());
	System.exit(0);
     }
     catch (Throwable e){
	System.out.println("Overflow");
	System.exit(0);
     }
     DecimalFormat df = new DecimalFormat("#.00");
     df.setRoundingMode(RoundingMode.HALF_UP);
     System.out.println(df.format(udragwgeio.Hwater));
//      System.out.println(udragwgeio.Hwater);

   }
}

