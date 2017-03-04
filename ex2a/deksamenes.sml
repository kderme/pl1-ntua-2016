fun readInt input = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

fun readIntInf input = Option.valOf (TextIO.scanStream (IntInf.scan StringCvt.DEC) input)

datatype mode = DEFAULT|FOUND|OVERFLOW
fun valof DEFAULT="0"|valof FOUND = "1"| valof OVERFLOW = "2"

fun parse file =
let
	val input = TextIO.openIn file
	val N = readInt input
	val _ = TextIO.inputLine input
	fun read_lines 0 acc = List.rev acc
	|   read_lines n acc = 
	let val (b,h,w,l) = (readInt input, readInt input, readInt input, readInt input)
	val _ = TextIO.inputLine input
(*	val _ = print (Int.toString b)	*)
	in (read_lines (n-1) ((b,w*l)::(b+h,~w*l)::acc)) end
	val lst = read_lines N []
	val vwater = readIntInf input
in (N,vwater,lst) end

(***************** MERGESORT *******************)
(* Purpose: deal the list into two piles *)
fun split l = 
    case l of 
        [] => ([] , [])
      | [ x ] => ([ x ] , [])
      | x :: y :: xs => let val (pile1 , pile2) = split xs
                        in (x :: pile1 , y :: pile2)
                        end

fun sort_fun ((x,_), (y,_)) = x<y
(* Purpose: merge two sorted lists into one *)
fun merge (l1, l2) = 
    case (l1 , l2) of
        ([] , l2) => l2
      | (l1 , []) => l1
      | (x :: xs , y :: ys) => 
            (case sort_fun(x,y) of
                 true => x :: (merge (xs , l2))
               | false => y :: (merge (l1 , ys)))

(* Purpose: sort the list in O(n log n) work *)
fun mergesort l = 
    case l of
        [] => []
      | [x] => [x]
      | _ => let val (pile1,pile2) = split l 
             in
                 merge (mergesort pile1, mergesort pile2)
             end

fun deksamenes file = 
let
	val (N,Vwater,Lst) = parse file
(*	val sorted = ListMergeSort.sort sort_fun Lst (isn`t included in mlton by default)	*)
	val sorted = mergesort Lst
fun fnn ((hnew:int,dVol:int),(Vin:IntInf.int, dV:IntInf.int,hold:real,md:mode))=
	if md=FOUND then (Vin,dV,hold,FOUND) else
	if md=OVERFLOW then (Vin,dV,hold,OVERFLOW) else (* never succeds*)
	if hnew=Real.floor hold then (Vin, dV+(Int.toLarge dVol),Real.fromInt hnew,DEFAULT) else
	let val interval = Int.toLarge(hnew - Real.floor(hold))
	    val dVnew = dV+(Int.toLarge dVol)
(***************	DEBUGGING	************************)  (*
	    val _ = print((Int.toString hnew)^", ")
	    val _ = print((Int.toString dVol)^", ")
	    val _ = print((Int.toString(Int.fromLarge Vin)^", "))	
	    val _ = print((Int.toString(Int.fromLarge dV)^", "))
	    val _ = print((Real.toString hold)^", ")
	    val _ = print((valof md)^"\n")			   *)
(***************	DEBUGGING	************************)

in
	if interval*dV+Vin < Vwater then (Vin+dV*interval, dVnew, Real.fromInt hnew,DEFAULT)
	else (Vin,dVnew,hold+(Real.fromInt(Int.fromLarge(Vwater-Vin))/(Real.fromLargeInt dV)),FOUND)
end
	val (Vin,dVw,h,md) = foldl fnn (0:IntInf.int, 0:IntInf.int, 0.0,DEFAULT) sorted
in 
	if md = DEFAULT then ~1.0 else h
end

fun module res = 
if Real.==(res,~1.0) then "Overflow\n" else
	let val N = Real.toLargeInt IEEEReal.TO_NEAREST (100.0*res)
	val (first,second) = IntInf.divMod(N,100)
	in 
		(IntInf.toString first)^"."^(if second>(9:IntInf.int) then "" else "0")^(IntInf.toString second)^"\n"
	end

fun main ()=
let
	val argv = (CommandLine.arguments())
	val file = hd argv
	val res = deksamenes file
	val res_rounded = module res
	val _ = print (res_rounded)
in ()
end

val _ = main
