select count(*) from iislogs

alter table iislogs add constraint CK_log primary key (LogFileName, LogRow)