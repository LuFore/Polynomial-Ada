package body polynomials is

function "+"(left,right:polynomial) return polynomial is
	function do_loop(big,little:polynomial)return polynomial is
		r : polynomial := big;
	begin
		for i in little'range loop
			r(i) := r(i) + little(i);
		end loop;
		return r;
	end do_loop;
begin
	if left'last < right'last then
		return do_loop(right,left );
	else
		return do_loop(left ,right);
	end if;
end "+";

function "-"(left,right:polynomial) return polynomial is
	mk_minus : polynomial(right'range);
begin
	for i in right'range loop
		mk_minus(i) := -right(i);
	end loop;
	
	return left + mk_minus; 
end "-";

function "*"(left,right:polynomial) return polynomial is
	r : polynomial (0..leading_i(left)+leading_i(right)) := (others => 0.0);
 begin
	for il in 0..leading_i(left) loop
		for ir in 0..leading_i(right) loop
			r(il+ir) := r(il+ir) + left(il) * right(ir);
		end loop;
	end loop;
	return compact(r);
end "*";



function "+"(left:real;right:polynomial) return polynomial is
	r : polynomial:=right;
begin
	r(0) := r(0) + left;
	return r;
end "+";

function "-"(left:polynomial;right:real) return polynomial is
	r : polynomial := left;
begin
	r(0) := r(0) - right;
	return r;
end "-";

function "*"(left:real;right:polynomial) return polynomial is 
	r : polynomial(right'range);
begin
	for i in r'range loop
		r(i) := right(i) * left;
	end loop;
	return r;
end "*";

function "/"(left:polynomial;right:real) return polynomial is
	r : polynomial(left'range);
begin
	for i in r'range loop
		r(i) := left(i) / right;
	end loop;
	return r;
end "/";



function f(me:polynomial; x:real) return real is
	r : real := 0.0;
begin
	for i in me'range loop
		r := r + me(i)**i;
	end loop;
	return r;
end f;



function derivative(me:polynomial) return polynomial is
	r : polynomial(me'first-1..0);
begin
	for i in r'range loop 
		r(i) := me(i+1)*real(i+1);
	end loop;
	return r;
end derivative;



function "/"(left,right:polynomial) return polynomial is
--return quotient
begin	
	return compact(meta_div(left,right).q);
end "/";



function "rem"(left,right:polynomial) return polynomial is
--untested function
begin
	return compact(meta_div(left,right).r);
end "rem";



function meta_div(left,right:polynomial) return division_return is 
	--Long division algorithm used
	T  : polynomial(left'range) := (others=>0.0);
	--temporary for calculations
	Ret: division_return(left'last,left'last);
begin
	Ret.R := left;
	Ret.Q := (others => 0.0);
	for i in reverse right'last..left'last loop
		T(i+1-right'last) := 0.0; --reset from last value
		T(i-right'last):= ret.R(i)/right(right'last);
		--Calculate qoutent
		ret.Q := ret.Q + T;
		--calculate remainder
		ret.R := ret.R - ret.Q * Right;
	end loop;
	return ret;
end meta_div;



function compact(me:polynomial) return polynomial is
begin
	for i in reverse me'range loop
		if me(i) /= 0.0 then
			return me(0..i);
		end if;
	end loop;
	return me(0..0);
end compact;



function leading_i(me:polynomial)return natural is
begin
	for i in reverse me'range loop
		if me(i) = 1.0 then
			return i;
		end if;
	end loop;
	return 0;--technically an error 
end leading_i;



function compacted(me:polynomial)return boolean is
begin
	if leading_i(me) = me'last then
		return true;
	else
		return false;
	end if;
end compacted;



function biggest(p1,p2:polynomial)return natural is
begin
	if p1'last > p2'last then
		return p1'last;
	else
		return p2'last;
	end if;
end biggest;


function image(me:polynomial) return string is
	function si(arg:real) return string is
		--return a short string image
	begin
		if arg < 0.0 then
			return "-"&real'image(arg)(2..real'image(arg)'last) ;
		else
			return "+"&real'image(arg)(2..real'image(arg)'last) ;
		end if;
	end si;
	function recurser(me:polynomial;index:natural) return string is

		function mk_bit(me:polynomial;index:natural) return string is
		begin
			return "("&si(me(index))& ")x^" 
			& index'image(2..(natural'image(index)'last));	
		end mk_bit;

	begin
		if index = 0 then
			return si(me(0));
		else
			return mk_bit(me,index)&" + "&recurser(me,index-1);
		end if;
	end recurser;

begin
	return recurser(me,me'last); 
end image;

function invert(me:polynomial) return polynomial is
	r : polynomial(me'range);
begin	
	for i in me'range loop
		r(i) := me(me'last-i);
	end loop;
	return r; 
end invert;


end polynomials;
