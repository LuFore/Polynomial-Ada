with polynomials;
with ada.text_io;
use ada.text_io;

procedure test is 

	type flt is new float;

	package poly is new polynomials(flt);
	use poly;

	procedure test_report(name:in string; pass:boolean)is
	begin
		if pass = true then	
			put_line(name&" test passed");
		else
			put_line(name&" test failed");
		end if;
	end test_report;
	
	function pow(me:polynomial;power:positive) return polynomial is
	begin
		if power = 1 then 
			return me;
		else
			return pow(me*me,power-1);
		end if;
	end pow; 

	p : polynomial := invert((1.0,1.0));
	long_p : polynomial := invert((3.0,0.0,2.0,0.0));
	x : polynomial := invert((2.0,0.0));
begin
	test_report("times two" ,2.0*p = p + p);
	--put_line(image(2.0*p));

	test_report("Divide", p/2.0  = 0.5 * p);
--	put_line(image(p*p));
	
	test_report("Polynomial division",(pow(p,2)/p) = p);

	test_report("Polynomial division2",long_p/x = invert((1.5,0.0,1.0)));
	put_line("Test image: "&image(long_p/x));
end test;
