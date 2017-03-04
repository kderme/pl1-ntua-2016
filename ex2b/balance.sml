val empty = ([],[])

fun prnt (lst:int list)=
let val _ = print("[")
fun pr [] = print("]")
|   pr [aa] = print((Int.toString aa)^"]")
|   pr (aa::aas) = let val _ = print((Int.toString aa)^",")
in pr aas end
in pr lst
end

(*	IntInf to Dec string	*)
fun str_IntInf n = IntInf.fmt StringCvt.DEC (n:IntInf.int)

fun prnt_large (lst:IntInf.int list)=
let
(*let val _ = print("[")*)
fun pr [] = ()  (*print("]")*)
|   pr [aa] = print((str_IntInf aa))  (*^"]")*)
|   pr (aa::aas) = let val _ = print((str_IntInf aa)^"+")
in pr aas end
in pr lst
end

fun addlist (lst:IntInf.int list) = foldl (fn (aa,x)=>aa+x) (0:IntInf.int) lst
fun pow3 (n:int) = IntInf.pow(Int.toLarge 3,n-1)

fun validate(N:int,W:IntInf.int,(left,right))=
let
val left1 = map pow3 left
val right1 = map pow3 right
val sum_left = addlist left1
val sum_right = addlist right1
(********  DEBUGGING  ***************)
(*
val _ = print ((str_IntInf W)^"+")
val _ = prnt_large left1
val _ = print("=")
val _ = prnt_large right1
val _ = print("\n")
*)
(********  DEBUGGING  ***************)
(*  val _ = print(Int.toString (Int.fromLarge sum_left))
//val _ = print(Int.toString (Int.fromLarge sum_right)) *)
in
	sum_left+W=sum_right
end

fun balance2 (N:int, W:IntInf.int, num:int, pow:IntInf.int,(left:int list,right:int list))=
let
val next_pow = 3*pow
val md = W mod next_pow
in
if W = 0 then (left,right) else
if W < pow then empty else 
if num>N then empty else
if md = 0*pow then balance2(N,W,num+1,next_pow,(left,right)) else
if md = 1*pow then balance2(N,W-pow, num+1,next_pow, (left,num::right)) else
if md = 2*pow then balance2(N,W+pow, num+1,next_pow, (num::left,right)) else
	empty	
end

fun print_output (ret:(int list*int list))=
let
	val _ = prnt (#1 ret)
	val _ = print(" ")
	val _ = prnt (#2 ret)
	val _ = print("\n")
in () end

fun balance (N:int) (W:IntInf.int)=
let val (reva,revb) = balance2(N,W,1,1:IntInf.int,empty)
in 
	(List.rev reva, List.rev revb)
end

fun main () =
let 
	val argv = (CommandLine.arguments())
	val N = valOf(Int.fromString (hd argv))
	val W = (*Int.toLarge (valOf( *) valOf(IntInf.fromString (hd (tl argv)))
	val ret = balance N W
in
	if validate(N,W,ret) then print_output ret else print_output empty
end

(**)  val _ = main() (* *) 	(*uncommend for mlton*)

