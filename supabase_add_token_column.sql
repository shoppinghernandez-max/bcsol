-- Agregar columnas para el sistema de token
ALTER TABLE solicitudes_ingreso ADD COLUMN IF NOT EXISTS token_acceso TEXT DEFAULT NULL;
ALTER TABLE solicitudes_ingreso ADD COLUMN IF NOT EXISTS token_ingresado TEXT DEFAULT NULL;