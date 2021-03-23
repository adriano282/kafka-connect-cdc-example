
-- ===================
-- Inserting rows into teste table
-- before insertion
-- ==================
use kafkaconnect;
select * from teste;
GO


-- ===================
-- Do the insertions
-- ================== 
insert into teste (numero, numerogrande, dinheiro, decimo, numeral, data1, data2, data3, data4)
values (1, 2, 3, 4, 5, GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), GETUTCDATE())
GO

insert into teste (numero, numerogrande, dinheiro, decimo, numeral, data1, data2, data3, data4)
values (2, 1, 2, 3, 4, GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), GETUTCDATE())
GO

insert into teste (numero, numerogrande, dinheiro, decimo, numeral, data1, data2, data3, data4)
values (3, 1, 2, 3, 4, GETUTCDATE(), GETUTCDATE(), GETUTCDATE(), GETUTCDATE())
GO



-- ===================
-- After insertion
-- ================== 
select * from teste
GO







