GRANT EXECUTE, SELECT ON PublicFacingData.* TO 'ProcedureRunner'@'localhost';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'ProcedureRunner'@'localhost';