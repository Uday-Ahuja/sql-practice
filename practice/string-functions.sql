/* SQL String Functions */
select concat ('Hello',' ','World!');
select concat_ws (',','Apple','Banana','Orange','Cherry');
select length('Hello') as byte_length;
select length(101) as byte_length;
select char_length('Hello') as char_count;
select substring('Hello World',1,7) as part;
select substring('Hello World',4,7) as part;
select left('Example',5) as left_part;
select right('Example',3) as right_part;
select instr('Hello World', 'World') as position;
select locate('World','Hello World') as pos;
select upper('hello') as upper_text;
select lower('HELLO') as lower_text;
select trim('	Text	') as trimmed;
select ltrim('    left') as ltrimmed;
select rtrim('right    ') as rtrimmed;
select lpad('HI',5,'*') as left_padded;
select rpad('HI',5,'*') as right_padded;
-- INSTR(String, Substring) : Returns position starting from 1 of first occurence, returns 0 if substring is not found
select instr('Aman','a');
-- LOCATE(String, Substring): More Flexible but Supports Starting position parameter 
select locate ('a','VEDANG',3); 
select locate('a','VEDANG',5);
select locate ('a','VEDANG SHARMA',5);
-- POSITION (substring IN string): more portable because it follows sql syntax, returns start position of substring if found
select position('SHARMA' IN 'VEDANG SHARMA');