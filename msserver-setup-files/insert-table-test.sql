
-- ===================
-- Inserting rows into teste table
-- before insertion
-- ==================
use kafkaconnect;
select * from teste;
GO


-- ===================
-- After insertion
-- ================== 
insert into teste (numero, numerogrande, dinheiro, decimo, numeral) 
values (100.000000, 100.000000, 100.000000, 100.000000, 100)
GO

insert into teste (numero, numerogrande, dinheiro, decimo, numeral) 
values (200.000000, 200.000000, 200.000000, 200.000000, 200.000000)
GO

insert into teste (numero, numerogrande, dinheiro, decimo, numeral) 
values (300.000000, 300.000000, 300.000000, 300.000000, 300.000000)
GO


select * from teste
GO







