# SQL String & Date Functions

String and date utility functions for querying, formatting, and manipulating data.

---

## String Functions

### CONCAT / CONCAT_WS

```sql
SELECT CONCAT('Hello', ' ', 'World!');              -- Hello World!
SELECT CONCAT_WS(',', 'Apple', 'Banana', 'Cherry'); -- Apple,Banana,Cherry
```

`CONCAT_WS` — first arg is the separator, rest are values.

---

### LENGTH vs CHAR_LENGTH

```sql
SELECT LENGTH('Hello');       -- 5 (bytes)
SELECT CHAR_LENGTH('Hello');  -- 5 (characters)
```

Difference matters for multibyte encodings (UTF-8, Hindi, emoji). For plain ASCII they return the same value.

---

### SUBSTRING / LEFT / RIGHT

```sql
SELECT SUBSTRING('Hello World', 1, 7);  -- Hello W
SELECT SUBSTRING('Hello World', 4, 7);  -- lo World

SELECT LEFT('Example', 5);   -- Examp
SELECT RIGHT('Example', 3);  -- ple
```

`SUBSTRING(str, pos, len)` — pos is 1-indexed, not 0.

---

### INSTR / LOCATE / POSITION

All three find where a substring starts. Returns position (1-indexed), **0 if not found**.

```sql
SELECT INSTR('Hello World', 'World');        -- 7
SELECT LOCATE('World', 'Hello World');       -- 7
SELECT POSITION('World' IN 'Hello World');   -- 7
```

**Key difference — LOCATE supports a start position:**
```sql
SELECT LOCATE('a', 'VEDANG', 3);        -- 5  (search from pos 3)
SELECT LOCATE('a', 'VEDANG', 5);        -- 5
SELECT LOCATE('a', 'VEDANG SHARMA', 5); -- 10 (finds next 'a' after pos 5)
```

`INSTR(str, substr)` — simple, no start position  
`LOCATE(substr, str, start)` — flexible, supports offset  
`POSITION(substr IN str)` — standard SQL syntax, no offset support

> Note: `INSTR` argument order is `(string, substring)` — opposite of `LOCATE`.

---

### UPPER / LOWER

```sql
SELECT UPPER('hello');  -- HELLO
SELECT LOWER('HELLO');  -- hello
```

---

### TRIM / LTRIM / RTRIM

```sql
SELECT TRIM('   Text    ');   -- Text
SELECT LTRIM('    left');     -- left
SELECT RTRIM('right    ');    -- right
```

`TRIM` removes both sides. Use `LTRIM`/`RTRIM` if you only want one side.

---

### LPAD / RPAD

```sql
SELECT LPAD('HI', 5, '*');  -- ***HI
SELECT RPAD('HI', 5, '*');  -- HI***
```

`LPAD(str, total_length, pad_char)` — pads on left until string reaches total_length.

---

## Date Functions

### Get Current Date/Time

```sql
SELECT NOW();            -- 2024-03-10 14:32:00  (date + time)
SELECT CURDATE();        -- 2024-03-10            (date only)
SELECT CURTIME();        -- 14:32:00              (time only)
```

---

### EXTRACT / DATE_PART

```sql
SELECT EXTRACT(YEAR FROM '2024-03-10');   -- 2024
SELECT EXTRACT(MONTH FROM '2024-03-10');  -- 3
SELECT EXTRACT(DAY FROM '2024-03-10');    -- 10
```

Alternative shorthand:
```sql
SELECT YEAR('2024-03-10');   -- 2024
SELECT MONTH('2024-03-10');  -- 3
SELECT DAY('2024-03-10');    -- 10
```

---

### DATE_ADD / DATE_SUB

```sql
SELECT DATE_ADD('2024-03-10', INTERVAL 7 DAY);   -- 2024-03-17
SELECT DATE_SUB('2024-03-10', INTERVAL 1 MONTH); -- 2024-02-10
```

Intervals: `DAY`, `MONTH`, `YEAR`, `HOUR`, `MINUTE`, `SECOND`

---

### DATEDIFF / TIMESTAMPDIFF

```sql
SELECT DATEDIFF('2024-03-17', '2024-03-10');  -- 7 (days between)

SELECT TIMESTAMPDIFF(MONTH, '2024-01-01', '2024-03-10');  -- 2
SELECT TIMESTAMPDIFF(YEAR, '2000-05-15', '2024-03-10');   -- 23
```

`DATEDIFF` → always returns days  
`TIMESTAMPDIFF(unit, start, end)` → returns difference in any unit

---

### DATE_FORMAT

```sql
SELECT DATE_FORMAT('2024-03-10', '%d-%m-%Y');   -- 10-03-2024
SELECT DATE_FORMAT('2024-03-10', '%M %d, %Y');  -- March 10, 2024
SELECT DATE_FORMAT(NOW(), '%H:%i:%s');           -- 14:32:00
```

Common format specifiers:

| Specifier | Meaning |
|-----------|---------|
| `%Y` | 4-digit year |
| `%m` | Month (01-12) |
| `%M` | Month name |
| `%d` | Day (01-31) |
| `%H` | Hour (24h) |
| `%i` | Minutes |
| `%s` | Seconds |

---

### STR_TO_DATE

Reverse of `DATE_FORMAT` — parse a string into a date.

```sql
SELECT STR_TO_DATE('10-03-2024', '%d-%m-%Y');  -- 2024-03-10
```

Useful when dates come in as strings from user input or imports.

---

## Quick Reference

| Function | Purpose |
|----------|---------|
| `CONCAT(a, b)` | Join strings |
| `CONCAT_WS(sep, ...)` | Join with separator |
| `LENGTH(str)` | Byte length |
| `CHAR_LENGTH(str)` | Character count |
| `SUBSTRING(str, pos, len)` | Extract part of string |
| `LEFT(str, n)` / `RIGHT(str, n)` | First/last n chars |
| `INSTR(str, sub)` | Position of substring (no offset) |
| `LOCATE(sub, str, start)` | Position with optional offset |
| `UPPER(str)` / `LOWER(str)` | Case conversion |
| `TRIM(str)` | Remove whitespace both sides |
| `LPAD(str, len, pad)` / `RPAD` | Pad to length |
| `NOW()` | Current datetime |
| `CURDATE()` / `CURTIME()` | Current date / time |
| `EXTRACT(unit FROM date)` | Pull year/month/day etc. |
| `DATE_ADD(date, INTERVAL n unit)` | Add to date |
| `DATEDIFF(d1, d2)` | Days between two dates |
| `TIMESTAMPDIFF(unit, d1, d2)` | Difference in any unit |
| `DATE_FORMAT(date, fmt)` | Format date as string |
| `STR_TO_DATE(str, fmt)` | Parse string to date |

---

## Common Mistakes

**INSTR vs LOCATE argument order**
```sql
INSTR('Hello World', 'World')    -- (string, substring)
LOCATE('World', 'Hello World')   -- (substring, string) ← reversed
```

**SUBSTRING is 1-indexed**
```sql
SELECT SUBSTRING('Hello', 1, 3);  -- Hel  (not 'ell')
```

**DATEDIFF order matters — can return negative**
```sql
SELECT DATEDIFF('2024-03-01', '2024-03-10');  -- -9
```