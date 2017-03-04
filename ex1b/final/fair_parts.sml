fun parse file =
let 
	val input = TextIO.openIn file
	val M = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	
	val N = Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
	val _ = TextIO.inputLine input
	fun read_arr 0 =[]
	|   read_arr n =
	(Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input))::(read_arr (n-1))
	in (M,N,read_arr M) end

fun fits(arr,limit:IntInf.int,M,N) = 
let	val initial = (rev arr,Int.toLarge 0,[],false,M,N-1)
	(*val _ = print ((Int.toString limit)^"->")*)
	(*(arr,sum,acumulator,takeAll,index,o_index)*)
	fun rec_fits ([],_,acc,_,_,_)=(true,acc)
	|   rec_fits (a::arr,sum,acc,takeAll,m,n)=
	if (Int.toLarge a)>limit then (false,[])
	else if m=n orelse takeAll then 
		rec_fits(arr,sum, (a,true)::acc,true,m-1,n-1)
	else if sum+(Int.toLarge a)>limit then 
		if n=0 then (false,[]) else
		rec_fits(arr,Int.toLarge a,(a,true)::acc,false,m-1,n-1)
	else	rec_fits(arr,sum+(Int.toLarge a),(a,false)::acc,false,m-1,n)
in
	rec_fits initial
end

fun mean (x:IntInf.int,y:IntInf.int) = #1 (IntInf.divMod(x+y,2))

fun output_form obst =
let	fun mapfun (x,bl)=" "^(Int.toString x)^(if bl then " |" else "")
	val hed = Int.toString (#1 (hd obst))^(if #2 (hd obst) then " |" else "")
	val strlist = hed::(map mapfun (tl obst))
in String.concat strlist end

fun binary (M,N,arr)=
let 	val arr_big = map Int.toLarge arr
	val sum = foldl (fn(a,sm)=>a+sm) (Int.toLarge 0) arr_big
	fun recursive_binary (x:IntInf.int,y:IntInf.int)=
	let	val mn = mean (x,y)
		val (fitted,obst)=fits(arr,mn,M,N)
	in if fitted then
		if mn=x then 
	(*	let val _ = print ("("^(Int.toString (Int.fromLarge mn))^") ")
	in*)	 output_form obst
	(*	 end	*)
		else recursive_binary(x,mn)
	   else if y>mn then recursive_binary(mn+1,y)
		else output_form []
	end
in recursive_binary(Int.toLarge 1, sum) end

fun fair_parts file= 
let
	val (M,N,arr) = parse file
in binary(M,N,arr) end

fun main ()=
let
	val argv= (CommandLine.arguments())
	val file = hd argv
	val str = (fair_parts file)^"\n"
in 
	print str
end


(* *)  val _ = main ()  (* *)  (*uncommend for mlton*)
