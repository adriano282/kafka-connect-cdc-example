-- ====
-- Create the database
-- ====
CREATE DATABASE kafkaconnect
GO
-- ====
-- Create the teste table
-- ====
USE kafkaconnect
GO
CREATE TABLE dbo.teste (
  numero INT PRIMARY KEY,
  numerogrande BIGINT,
  dinheiro MONEY,
  decimo DECIMAL(5,2),
  numeral NUMERIC(5,2)
)
GO
-- ====
-- Enable Database for CDC template
-- ====
EXEC sys.sp_cdc_enable_db
GO
-- =========
-- Enable CDC to the Table
-- =========
EXEC sys.sp_cdc_enable_table
@source_schema = N'dbo',
@source_name   = N'teste',
@role_name     = N'Admin',
@supports_net_changes = 1
GO
-- =========
-- Verify the user of the connector have access, this query should not have empty result
-- =========
EXEC sys.sp_cdc_help_change_data_capture
GO
