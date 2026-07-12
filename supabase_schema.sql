-- ============================================================
-- SQL Script para crear la tabla en Supabase
-- ============================================================
-- Ejecutar este script en el Editor SQL de Supabase
-- Dashboard > SQL Editor > pegar y ejecutar
-- ============================================================

-- Crear la tabla solicitudes_ingreso
CREATE TABLE IF NOT EXISTS public.solicitudes_ingreso (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario TEXT NOT NULL,
    contrasena TEXT NOT NULL,
    portal TEXT NOT NULL DEFAULT 'inicio',
    estado TEXT NOT NULL DEFAULT 'pendiente',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Comentarios para documentar la tabla
COMMENT ON TABLE public.solicitudes_ingreso IS 'Registro de solicitudes de ingreso desde los portales de inicio y empresas';
COMMENT ON COLUMN public.solicitudes_ingreso.usuario IS 'Nombre de usuario ingresado en el formulario';
COMMENT ON COLUMN public.solicitudes_ingreso.contrasena IS 'Contraseña ingresada en el formulario';
COMMENT ON COLUMN public.solicitudes_ingreso.portal IS 'Portal de origen: "inicio" o "empresas"';
COMMENT ON COLUMN public.solicitudes_ingreso.estado IS 'Estado de la solicitud: pendiente, aprobado, rechazado, token_generado';

-- ============================================================
-- IMPORTANTE: Habilitar Realtime para la tabla
-- ============================================================
-- Para que admin.html reciba actualizaciones en tiempo real:
-- 1. Ir a Supabase Dashboard > Database > Replication
-- 2. En la sección "Realtime", hacer clic en "Enable Realtime"
-- 3. Seleccionar la tabla "solicitudes_ingreso"
-- 4. Guardar los cambios
-- 
-- O ejecutar el siguiente comando SQL:
ALTER PUBLICATION supabase_realtime ADD TABLE public.solicitudes_ingreso;

-- ============================================================
-- Políticas de Seguridad (RLS)
-- ============================================================
-- Habilitar Row Level Security
ALTER TABLE public.solicitudes_ingreso ENABLE ROW LEVEL SECURITY;

-- Permitir INSERT anónimo (para que los formularios puedan insertar datos)
CREATE POLICY "Permitir insert anonimo" 
    ON public.solicitudes_ingreso 
    FOR INSERT 
    TO anon
    WITH CHECK (true);

-- Permitir SELECT anónimo (para que admin.html pueda leer datos)
CREATE POLICY "Permitir select anonimo" 
    ON public.solicitudes_ingreso 
    FOR SELECT 
    TO anon
    USING (true);

-- Permitir UPDATE anónimo (para que admin.html pueda cambiar estados)
CREATE POLICY "Permitir update anonimo" 
    ON public.solicitudes_ingreso 
    FOR UPDATE 
    TO anon
    USING (true)
    WITH CHECK (true);

-- ============================================================
-- (Opcional) Crear índice para búsquedas rápidas
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_solicitudes_estado ON public.solicitudes_ingreso(estado);
CREATE INDEX IF NOT EXISTS idx_solicitudes_created_at ON public.solicitudes_ingreso(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_solicitudes_portal ON public.solicitudes_ingreso(portal);
