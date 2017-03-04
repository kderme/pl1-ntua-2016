import java.util.Vector;


class State
{
  private int N;
  private long W;
  private long balance;
  private Vector<Integer> Left;
  private Vector<Integer> Right; 

  public State(int n, long w)
  {
    N = n;
    W = w;
    balance = W;
    Left = new Vector<Integer>(20);
    Right = new Vector<Integer>(20);
  }
  
  private void prnt(Vector<Integer> V)
  {
    int i;
    System.out.print("[");
    for(i=0; i<V.size()-1; i++){
	System.out.print(V.get(i));
	System.out.print(",");
    }
    for(i=V.size()-1;i>=0 && i<V.size();i++)
	System.out.print(V.get(i));
    System.out.print("]");
  }

  enum result{FOUND, NFOUND}

  private result recursive(long bl, int num, long pow)
  {
//    System.out.print("{"+num+","+pow+","+bl+"}");
//    print_Vectors();
    if(bl==0L) return result.FOUND;
    if(bl<pow) return result.NFOUND;
    if(num>N)  return result.NFOUND;

    long next_pow = 3*pow;
    long md = bl % next_pow;

    if(md == 0*pow)
	return recursive(bl,num+1,next_pow);
    else if(md == 1*pow){
	Right.add(num);
	return recursive(bl-pow,num+1,next_pow);
    }
    else if(md == 2*pow){
	Left.add(num);
	return recursive(bl+pow,num+1,next_pow);
    }
    System.out.print("Something went horribly wrong\n");
    System.exit(1);
    return result.NFOUND;
  }

  public void GoSolveYourself()
  {
    result ret = recursive(W,1,1);
    if (ret==result.NFOUND){
	Left.clear();
	Right.clear();
    }

  }

  public void print_Vectors()
  {
    prnt(Left);
    System.out.print(" ");
    prnt(Right);
    System.out.print("\n");
  }
}

public class Balance{
  public static void main(String[] args)
  {
    if(args.length!=2){
      System.out.println("Usage: java Balance N W");
      System.exit(1);
    }
    int n = Integer.parseInt(args[0]);
    long w = Long.parseLong(args[1]);
    State bal = new State(n,w);
    bal.GoSolveYourself();
    bal.print_Vectors();
  }
}
