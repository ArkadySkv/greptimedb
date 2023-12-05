-- Test casting from decimal to other types
-- Port from https://github.com/duckdb/duckdb/blob/main/test/sql/types/decimal/cast_from_decimal.test
-- and https://github.com/duckdb/duckdb/blob/main/test/sql/types/decimal/cast_to_decimal.test

-- tinyint
SELECT 127::DECIMAL(3,0)::TINYINT, -127::DECIMAL(3,0)::TINYINT, -7::DECIMAL(9,1)::TINYINT, 27::DECIMAL(18,1)::TINYINT, 33::DECIMAL(38,1)::TINYINT;

SELECT 128::DECIMAL(3,0)::TINYINT;

SELECT -128::DECIMAL(9,0)::TINYINT;

SELECT 128::DECIMAL(18,0)::TINYINT;

SELECT 14751947891758972421513::DECIMAL(38,0)::TINYINT;

-- smallint

SELECT 127::DECIMAL(3,0)::SMALLINT, -32767::DECIMAL(5,0)::SMALLINT, -7::DECIMAL(9,1)::SMALLINT, 27::DECIMAL(18,1)::SMALLINT, 33::DECIMAL(38,1)::SMALLINT;

SELECT -32768::DECIMAL(9,0)::SMALLINT;

SELECT 32768::DECIMAL(18,0)::SMALLINT;

SELECT 14751947891758972421513::DECIMAL(38,0)::SMALLINT;

-- integer

SELECT 127::DECIMAL(3,0)::INTEGER, -2147483647::DECIMAL(10,0)::INTEGER, -7::DECIMAL(9,1)::INTEGER, 27::DECIMAL(18,1)::INTEGER, 33::DECIMAL(38,1)::INTEGER;

SELECT 2147483648::DECIMAL(18,0)::INTEGER;

SELECT 14751947891758972421513::DECIMAL(38,0)::INTEGER;

-- bigint

SELECT 127::DECIMAL(3,0)::BIGINT, -9223372036854775807::DECIMAL(19,0)::BIGINT, -7::DECIMAL(9,1)::BIGINT, 27::DECIMAL(18,1)::BIGINT, 33::DECIMAL(38,1)::BIGINT;

SELECT 14751947891758972421513::DECIMAL(38,0)::BIGINT;

-- float

SELECT 127::DECIMAL(3,0)::FLOAT, -17014118346046923173168730371588410572::DECIMAL(38,0)::FLOAT, -7::DECIMAL(9,1)::FLOAT, 27::DECIMAL(18,1)::FLOAT, 33::DECIMAL(38,1)::FLOAT;

-- double

SELECT 127::DECIMAL(3,0)::DOUBLE, -17014118346046923173168730371588410572::DECIMAL(38,0)::DOUBLE, -7::DECIMAL(9,1)::DOUBLE, 27::DECIMAL(18,1)::DOUBLE, 33::DECIMAL(38,1)::DOUBLE;


-- Test casting from other types to decimal

-- tinyint

SELECT 100::TINYINT::DECIMAL(18,3), 200::TINYINT::DECIMAL(3,0), (-300)::TINYINT::DECIMAL(3,0), 0::TINYINT::DECIMAL(3,3);

SELECT 100::TINYINT::DECIMAL(38,35), 200::TINYINT::DECIMAL(9,6);

-- overflow

SELECT 100::TINYINT::DECIMAL(3,1);

SELECT 1::TINYINT::DECIMAL(3,3);

SELECT 100::TINYINT::DECIMAL(18,17);

SELECT 100::TINYINT::DECIMAL(9,7);

SELECT 100::TINYINT::DECIMAL(38,37);

-- smallint

SELECT 100::SMALLINT::DECIMAL(18,3), 200::SMALLINT::DECIMAL(3,0), (-300)::SMALLINT::DECIMAL(3,0), 0::SMALLINT::DECIMAL(3,3);

SELECT 100::SMALLINT::DECIMAL(38,35), 200::SMALLINT::DECIMAL(9,6);

-- overflow

SELECT 100::SMALLINT::DECIMAL(3,1);

SELECT 1::SMALLINT::DECIMAL(3,3);

SELECT 100::SMALLINT::DECIMAL(18,17);

SELECT 100::SMALLINT::DECIMAL(9,7);

SELECT 100::SMALLINT::DECIMAL(38,37);

-- integer

SELECT 100::INTEGER::DECIMAL(18,3), 200::INTEGER::DECIMAL(3,0), (-300)::INTEGER::DECIMAL(3,0), 0::INTEGER::DECIMAL(3,3);

SELECT 100::INTEGER::DECIMAL(38,35), 200::INTEGER::DECIMAL(9,6), 2147483647::INTEGER::DECIMAL(10,0), (-2147483647)::INTEGER::DECIMAL(10,0);

-- overflow

SELECT 100::INTEGER::DECIMAL(3,1);

SELECT 10000000::INTEGER::DECIMAL(3,1);

SELECT -10000000::INTEGER::DECIMAL(3,1);

SELECT 1::INTEGER::DECIMAL(3,3);

SELECT 100::INTEGER::DECIMAL(18,17);

SELECT 100::INTEGER::DECIMAL(9,7);

SELECT 100::INTEGER::DECIMAL(38,37);

-- bigint

SELECT 100::BIGINT::DECIMAL(18,3), 200::BIGINT::DECIMAL(3,0), (-100)::BIGINT::DECIMAL(3,0), 0::BIGINT::DECIMAL(3,3);

SELECT 100::BIGINT::DECIMAL(38,35), 200::BIGINT::DECIMAL(9,6), 9223372036854775807::BIGINT::DECIMAL(19,0), (-9223372036854775807)::BIGINT::DECIMAL(19,0);

SELECT 922337203685477580::BIGINT::DECIMAL(18,0), (-922337203685477580)::BIGINT::DECIMAL(18,0);

-- overflow

SELECT 100::BIGINT::DECIMAL(3,1);

SELECT 10000000::BIGINT::DECIMAL(3,1);

SELECT -10000000::BIGINT::DECIMAL(3,1);

SELECT 1::BIGINT::DECIMAL(3,3);

SELECT 100::BIGINT::DECIMAL(18,17);

SELECT 100::BIGINT::DECIMAL(9,7);

SELECT 100::BIGINT::DECIMAL(38,37);

-- float

SELECT 100::FLOAT::DECIMAL(18,3), 200::FLOAT::DECIMAL(3,0), (-300)::FLOAT::DECIMAL(3,0), 0::FLOAT::DECIMAL(3,3);

SELECT 100::FLOAT::DECIMAL(38,35)::FLOAT, 200::FLOAT::DECIMAL(9,6)::FLOAT, 17014118346046923173168730371588410572::FLOAT::DECIMAL(38,0)::FLOAT, (-17014118346046923173168730371588410572)::FLOAT::DECIMAL(38,0)::FLOAT;

SELECT 1.25::FLOAT::DECIMAL(3,2);

-- overflow

SELECT 100::FLOAT::DECIMAL(3,1);

SELECT 10000000::FLOAT::DECIMAL(3,1);

SELECT -10000000::FLOAT::DECIMAL(3,1);

SELECT 1::FLOAT::DECIMAL(3,3);

SELECT 100::FLOAT::DECIMAL(18,17);

SELECT 100::FLOAT::DECIMAL(9,7);

SELECT 100::FLOAT::DECIMAL(38,37);

-- Some controversial cases

SELECT 17014118346046923173168730371588410572::FLOAT::DECIMAL(38,1);

SELECT 17014118346046923173168730371588410572::FLOAT::DECIMAL(37,0);

SELECT 17014118346046923173168730371588410572::FLOAT::DECIMAL(18,0);

SELECT 17014118346046923173168730371588410572::FLOAT::DECIMAL(9,0);

SELECT 17014118346046923173168730371588410572::FLOAT::DECIMAL(4,0);

-- double

SELECT 100::DOUBLE::DECIMAL(18,3), 200::DOUBLE::DECIMAL(3,0), (-300)::DOUBLE::DECIMAL(3,0), 0::DOUBLE::DECIMAL(3,3);

SELECT 100::DOUBLE::DECIMAL(38,35)::DOUBLE, 200::DOUBLE::DECIMAL(9,6)::DOUBLE, 17014118346046923173168730371588410572::DOUBLE::DECIMAL(38,0)::DOUBLE, (-17014118346046923173168730371588410572)::DOUBLE::DECIMAL(38,0)::DOUBLE;

SELECT 1.25::DOUBLE::DECIMAL(3,2);

-- overflow

SELECT 100::DOUBLE::DECIMAL(3,1);

SELECT 10000000::DOUBLE::DECIMAL(3,1);

SELECT -10000000::DOUBLE::DECIMAL(3,1);

SELECT 1::DOUBLE::DECIMAL(3,3);

SELECT 100::DOUBLE::DECIMAL(18,17);

SELECT 100::DOUBLE::DECIMAL(9,7);

SELECT 100::DOUBLE::DECIMAL(38,37);

-- Some controversial cases

SELECT 17014118346046923173168730371588410572::DOUBLE::DECIMAL(38,1);

SELECT 17014118346046923173168730371588410572::DOUBLE::DECIMAL(37,0);

SELECT 17014118346046923173168730371588410572::DOUBLE::DECIMAL(18,0);

SELECT 17014118346046923173168730371588410572::DOUBLE::DECIMAL(9,0);

SELECT 17014118346046923173168730371588410572::DOUBLE::DECIMAL(4,0);