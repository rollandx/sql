/*
	A script to roughly estimate a maximum table size given number of rows, column sizes etc.
	Can be used to very roughly estimate how much space will your table(s) take up on disk.
	All units are in bytes except the result.
*/

declare @Num_Rows int, @Num_Cols int, @Fixed_Data_Size int, @Num_Variable_Cols int, @Max_Var_Size int, @Null_Bitmap int, @Variable_Data_Size int, @Rows_Per_Page int,
		@Fill_Factor int, @Free_Rows_Per_Page int, @Num_Pages int, @Table_Size bigint, @Row_Size bigint

-- estimated number of rows
set @num_rows = 1000
-- total number of columns in the table
set @num_cols = 5
-- number of variable-length columns (varchar, varbinary, etc.)
set @num_variable_cols = 1
-- maximum size of all variable length columns combined
set @max_var_size = 10
-- total size (sum) of all fixed length columns 
set @fixed_data_size = 8
-- the table clustered index fill factor (how much of the page is initially filled) - leave it at 100 if not sure
set @fill_factor = 100

if (@num_variable_cols = 0)
begin
	set @null_bitmap = 0
	set @variable_data_size = 0
end
else
begin
	set @null_bitmap = 2 + ((@num_cols + 7) / 8 )
	set @variable_data_size = 2 + (@num_variable_cols * 2) + @max_var_size
end

set @row_size = @fixed_data_size + @variable_data_size + @null_bitmap + 4
set @rows_per_page = (8096) / (@row_size + 2)
set @free_rows_per_page = 8096 * ((100 - @fill_factor) / 100) / (@row_size + 2)
set @num_pages = @num_rows / (@rows_per_page - @free_rows_per_page)
set @table_size = 8192 * @num_pages

print 'Your table would be approx. ' + cast(@table_size / 1024 as varchar(10)) + 'MB in size'
