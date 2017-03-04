(*    REVSUM sml implementation   
 *    NTUA Programming Languages 1  2016
 *    written by Dermentzis Konstantinos
 *)

type rec_struct = int list*int list*int*int
(*list, rev_list, size, mode, *)
type ret_struct = int list*int list*bool
datatype mode = DEFAULT|CARRY_ACE
fun valof DEFAULT="0"|valof CARRY_ACE="1"

fun parse file=
let 	
	val stream = TextIO.openIn file
in
	TextIO.inputLine stream
end
	

fun char_to_digit x = ord x - ord #"0"
fun digit_to_char x = Char.chr (ord #"0"+ x)

fun int_to_intlist number=
map char_to_digit (String.explode (Int.toString number))

fun diglist_to_string diglist =
String.implode (map digit_to_char diglist)

fun transform inp_opt = 
let
	val char_lst = explode(Option.valOf inp_opt)
	val lsta = List.last char_lst
	(*cut last char: Should be newline *)
	val lngth = List.length char_lst - 1
	val lst = List.take(char_lst, lngth) 
in
	if not (List.all Char.isDigit lst)
	then let
		(* error input:nodigit in first chars.*)
		(* Let`s filter out the nondigits*)
		val filtered_list = List.filter Char.isDigit lst
	in
		List.map char_to_digit filtered_list
	end
	else let
		val int_list = List.map char_to_digit lst  	
	in
		if ord lsta = ord #"\n" (*orelse ord lst #"/0n"*)
		then
			int_list	
		else 
		(* unexpected input:no new line or eof at the end.*)
		(* Let`s add last char if it`s a digit*)
		if Char.isDigit lsta
		then 
			int_list @ [char_to_digit lsta]
		else 	
			int_list
	end
end 

fun ffunct ((x, y), (bs, kratoumeno)) = 
let
	val res = x+y+kratoumeno
	val (dgt, domino) = if res>= 10 then (res-10, 1) else (res, 0)
in
	(dgt::bs,domino)	
end
		
fun mtch [] [] = []
|   mtch (x::xs) (y::ys) = (x,y)::(mtch xs ys)
|   mtch _ _ = [(0,0)]

fun add_rev lst =
let
	val rv  = List.rev lst
	val together = mtch lst rv
	val (add,last_curry) = foldl ffunct ([],0) together
	val ret = if last_curry = 0 then add else 1::add
in
	ret
end

fun dec_value int_list = foldl (fn(a,b)=>10*b+a) 0 int_list
fun mx_pow number acc= if (number div acc)<10 then acc else mx_pow number (10*acc )

fun find_rev dec_number = 
let 
	fun find_rev_1 (0,m) = m
	|   find_rev_1 (n,m) = find_rev_1 (n div 10, 10*m+n mod 10)
in
	find_rev_1 (dec_number,0)
end

fun revsum_brute_force (ls,rls,size,md)=
let
	val int_list = ls@(rev rls)
	val dec_number = dec_value int_list
(*	val _ = print ("("^Int.toString dec_number^")")  *)
	fun rev_sum_loop (target,try,start) =
		if try<start then if target=0 then (0,true) else (0,false) else
		let
			val revs = find_rev try
		in if revs+try=target then (try,true)
	   	   else rev_sum_loop(target,try-1,start)
	end
	val max_pow = mx_pow dec_number 1
	val (start,finish) =  if md=DEFAULT then (max_pow,dec_number) else (1,max_pow-1)
	val (ret_num,found) = rev_sum_loop(dec_number,finish,start)
	val ret_num_list =int_to_intlist ret_num 
in
	if found then (ret_num_list,[],true)
	else ([],[],false)
end

fun create const 0  accu = accu
|   create const size accu = create const (size-1) (const::accu)

fun next 9 = 0
|   next dgt = dgt+1

fun sub_one []=([],false)
|   sub_one [0]=([9],true)
|   sub_one (0::ls) = 
	let val (a,fault)=sub_one ls in
	(9::a,fault) end
|   sub_one (a::ss)=((a-1)::ss,false)

fun renew_lists (ls,rls,size)=
let 
(*	val rls1=tl List.take(rls,size)*)
	val (newrls,fault)= sub_one (tl rls)
	in if fault then let 
		val (newls,fault2)=sub_one(rev (tl (tl ls)))
		in ((hd ls)::(hd(tl ls))::newls,(hd rls)::newrls,fault2) end
	   else (ls, (hd rls)::newrls, fault)
end

fun revsum_2 (ls,rls,size,md)=
if size=0 then ([],[],true)
else if size=1 orelse ls=[] then revsum_brute_force(ls,rls,size,md)
else if hd ls=0 then 
	if hd rls = 0 then let
		val (a,b,found)=revsum_2 (tl ls, tl rls,size-2, DEFAULT)
	in (0::a, 0::b, found) end
     	else ([],[],false)
else if size<8 then let 
	val (a,b,found)=revsum_brute_force (ls, rls,size, md)
	in 
	if found then (a,b,true)
	else if hd ls = 1 andalso hd rls = 0 then 
		let val (a,b,found)=revsum_2 (ls, tl rls,size-1, CARRY_ACE)
		in (0::a,0::b,found) end
	else ([],[],false) 
	end
else let
(*
val _ = print("{")
val _ = print((diglist_to_string (List.take (ls,3)))^"..."^(diglist_to_string (rev (List.take (rls,2))))^","^(Int.toString size)^","^(valof md)^"}->")
*)

in
	if hd ls <> 1 orelse md = DEFAULT then 
	if hd ls = hd rls then let
		val (a,b,found)=revsum_2 (tl ls, tl rls,size-2, DEFAULT)
		in ((hd ls)::a, 0::b, found) end
	else if hd ls = next (hd rls) then let
		val (a,b,found)=revsum_2 (1::(tl ls), tl rls,size-1, CARRY_ACE)
		in ((hd ls -1)::a, 0::b, found) end
	else ([],[],false)
else if hd (tl ls) = hd rls then 
	if hd (tl ls) = 9 then ([],[],false)
	else let
(*		val _ = print(if size>11 then "" else (diglist_to_string ls)^(diglist_to_string(rev rls))) *)
		val (newls,newrls,fault)=renew_lists(ls,rls,size)
(*		val _ = print(if size>11 then "" else "a") *)
(*		val _ = print((diglist_to_string newls)^(diglist_to_string newrls)) *)
	      in if fault then ([],[],false)  else let
(*	val _ = print(if size>11 then "" else (diglist_to_string newls)^(diglist_to_string(rev newrls))) *)
(*	val _ = print(if size>11 then "" else "b") *)
	val (a,b,found)=revsum_2 (tl (tl newls), tl newrls,size-3, DEFAULT)
(*	val _ = print(if size>11 then "" else "c") *)
	in (9::a, ((hd (tl ls))+1)::b, found) end
		end
else if hd (tl ls) = next (hd rls) then
	if hd (tl ls)<>0 andalso hd rls<>9 then let
		val (newls,newrls,fault)=renew_lists(ls,rls,size)
	in if fault then if size mod 2 =0 then ([],[],fault)
	   		 else let 
		val first = create 9 (size div 2) []
		val second = create 0 (size-2-(size div 2)) []
	(* 	val _ = print (diglist_to_string (first@second@[(next (hd rls))])) *)
	   in (first@second@[(next (hd rls))],[],true) end
	   else let
		val (a,b,found)=revsum_2 (1::(tl (tl newls)), tl newrls,size-2, CARRY_ACE)
	        in (9::a, (hd (tl ls))::b,found) end
	end
	else let
		val (a,b,found)=revsum_2 (1::(tl(tl ls)), tl rls,size-2, CARRY_ACE)
	in (9::a, (hd (tl ls))::b,found) end
else ([],[],false)

end

fun revsum_1 int_list =
let 
	val size = length int_list
	val lst = List.take(int_list, size div 2 )
	val rv = List.take(rev int_list, (size div 2)+(size mod 2))
	val initial= (lst,rv,size, DEFAULT)
	val initial2= (lst,rv,size, CARRY_ACE)
	val fs = hd int_list
	val scd = if size>1 then hd (tl int_list) else 0
	val lst = List.last int_list
in
	if size=1 then let
		val (a,b,found) = revsum_brute_force initial 
		in a@(rev b) end 
	else if fs <> 1 
	orelse fs=1 andalso lst=1 andalso  scd <>1 andalso scd<>2 then let
		val (a,b,found) = revsum_2 initial in
		if found then a@(rev b) else [0] end
	else if fs =1 andalso lst<>1 then let 
		val (a,b,found) = revsum_2 initial2 in
		if found then a@(rev b) else [0] end
	else let
		val (a,b,found) = revsum_2 initial in
		if found then a@(rev b) else let
		val (a2,b2,found2) = revsum_2 initial2 in
		if found2 then a2@(rev b2) else [0] end end
end

fun d_s digit = Char.toCString (Char.chr (ord #"0"+digit) )
fun prnt2 (a,b)= print ("("^(d_s a)^","^(d_s b)^"),")

fun char_to_digit x = ord x - ord #"0"
fun revsum file = 
let 
(*	val file_str = String.toString file*)
	val inp_opt = parse file
	val int_list = transform inp_opt
	val ret_list = revsum_1 int_list
	val rev_sum = add_rev ret_list
	val ret_string1 = diglist_to_string ret_list
	val ret_string =  if rev_sum = int_list then ret_string1 else "0"
(*	val _ =print ("result found:"^(diglist_to_string rev_sum)^"\n")*)
(*	val _ =print "{"
	val _ =app prnt2 mth
	val _ =print "}"*)
in
	ret_string
end	

fun main ()=
let
	val argv= (CommandLine.arguments())
	val a = hd argv 
	val ret = revsum a
in

(*	print("\nresult found:"); *)
	print(ret^"\n")
(*	print ok *)

end
(* *)  val _ = main () (* *)  (*uncommend for mlton*)



