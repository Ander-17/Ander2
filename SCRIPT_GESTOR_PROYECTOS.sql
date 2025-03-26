CREATE DATABASE GESTOR_PROYECTOS_INFORMATICOS;
USE GESTOR_PROYECTOS_INFORMATICOS;

/* CREACIÓN DE TABLAS */

CREATE TABLE FASE (
    ID_FASE INT PRIMARY KEY,
    NUM_SECUENCIA INT NOT NULL,
    NOMBRE VARCHAR(45) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL,
    ESTADO ENUM('En curso', 'Finalizada') NOT NULL
);

CREATE TABLE RECURSOS (
    CODIGO INT PRIMARY KEY,
    NOMBRE VARCHAR(45) NOT NULL,
    DESCRIPCION VARCHAR(255),
    TIPO ENUM('Hardware', 'Software') NOT NULL
);

CREATE TABLE INFORMATICOS (
    ID_INFORMATICOS INT PRIMARY KEY,
    NOMBRE VARCHAR(45) NOT NULL,
    ROL ENUM('Analista', 'Programador') NOT NULL
);

CREATE TABLE LENGUAJE_PROGRAMACION (
    ID_LENGUAJE INT PRIMARY KEY,
    NOMBRE VARCHAR(45) NOT NULL
);

CREATE TABLE PRODUCTOS (
    PROD_CODIGO INT PRIMARY KEY,
    NOMBRE VARCHAR(45) NOT NULL,
    DESCRIPCION VARCHAR(255),
    ESTADO ENUM('En curso', 'Finalizada') NOT NULL,
    VERSION VARCHAR(20),
    TIPO ENUM('Software', 'Informe', 'Prototipo') NOT NULL,
    TIPO_SOFTWARE VARCHAR(50),
    UBICACION VARCHAR(45),
    RESPONSABLE_INFOR_ID INT NOT NULL,
    FOREIGN KEY (RESPONSABLE_INFOR_ID) REFERENCES INFORMATICOS(ID_INFORMATICOS)
);

CREATE TABLE DOCENTES (
    DOCENTES_CODIGO INT PRIMARY KEY,
    DOCUMENTO VARCHAR(20) NOT NULL UNIQUE,
    NOMBRE VARCHAR(100) NOT NULL,
    DIRECCION VARCHAR(200),
    TITULO VARCHAR(100),
    ANIOS_EXP INT NOT NULL
);

CREATE TABLE PROYECTO (
    PROY_CODIGO INT PRIMARY KEY,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL,
    ALIADO VARCHAR(100) NOT NULL,
    DESCRIPCION VARCHAR(255),
    NOMBRE VARCHAR(45) NOT NULL,
    HORAS_ESTIMADAS INT NOT NULL,
    PRESUPUESTO DECIMAL(12,2) NOT NULL,
    DOCENTE_CODIGO INT NOT NULL,
    FOREIGN KEY (DOCENTE_CODIGO) REFERENCES DOCENTES(DOCENTES_CODIGO)
);

CREATE TABLE GASTOS (
    GASTOS_CODIGO INT PRIMARY KEY,
    DESCRIPCION VARCHAR(255) NOT NULL,
    FECHA DATE NOT NULL,
    IMPORTE DECIMAL(10,2) NOT NULL,
    TIPO VARCHAR(60) NOT NULL,
    DOCENTES_CODIGO INT NOT NULL,
    PROY_CODIGO INT NOT NULL,
    FOREIGN KEY (DOCENTES_CODIGO) REFERENCES DOCENTES(DOCENTES_CODIGO),
    FOREIGN KEY (PROY_CODIGO) REFERENCES PROYECTO(PROY_CODIGO)
);

/* TABLAS DE RELACIÓN */

CREATE TABLE DOMINA (
    INFORMATICOS_ID INT NOT NULL,
    LENGUAJE_ID INT NOT NULL,
    PRIMARY KEY (INFORMATICOS_ID, LENGUAJE_ID),
    FOREIGN KEY (INFORMATICOS_ID) REFERENCES INFORMATICOS(ID_INFORMATICOS),
    FOREIGN KEY (LENGUAJE_ID) REFERENCES LENGUAJE_PROGRAMACION(ID_LENGUAJE)
);

CREATE TABLE UTILIZA (
    RECURSO_CODIGO INT NOT NULL,
    FASE_ID INT NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL,
    PERIODO_USO VARCHAR(50) GENERATED ALWAYS AS (CONCAT(FECHA_INICIO, ' a ', FECHA_FIN)) VIRTUAL,
    PRIMARY KEY (RECURSO_CODIGO, FASE_ID),
    FOREIGN KEY (RECURSO_CODIGO) REFERENCES RECURSOS(CODIGO),
    FOREIGN KEY (FASE_ID) REFERENCES FASE(ID_FASE)
);

CREATE TABLE GENERA (
    FASE_ID INT NOT NULL,
    PROD_CODIGO INT NOT NULL,
    HORAS_DEDICADAS INT NOT NULL,
    PRIMARY KEY (FASE_ID, PROD_CODIGO),
    FOREIGN KEY (FASE_ID) REFERENCES FASE(ID_FASE),
    FOREIGN KEY (PROD_CODIGO) REFERENCES PRODUCTOS(PROD_CODIGO)
);

CREATE TABLE PARTICIPA (
    PROY_CODIGO INT NOT NULL,
    INFORMATICO_ID INT NOT NULL,
    TARIFA_HORA DECIMAL(10,2) NOT NULL,
    HORAS_DEDICADAS INT NOT NULL,
    COSTE_TOTAL DECIMAL(10,2) GENERATED ALWAYS AS (TARIFA_HORA * HORAS_DEDICADAS) VIRTUAL,
    PRIMARY KEY (PROY_CODIGO, INFORMATICO_ID),
    FOREIGN KEY (PROY_CODIGO) REFERENCES PROYECTO(PROY_CODIGO),
    FOREIGN KEY (INFORMATICO_ID) REFERENCES INFORMATICOS(ID_INFORMATICOS)
);

/* Insertar 10 registros por cada tabla */

INSERT INTO DOCENTES (DOCENTES_CODIGO, DOCUMENTO, NOMBRE, DIRECCION, TITULO, ANIOS_EXP) VALUES
(1, '1001', 'Ana López', 'Calle 1 #123', 'Ingeniera de Sistemas', 5),
(2, '1002', 'Carlos Ruiz', 'Calle 2 #456', 'MSc. en TI', 8),
(3, '1003', 'Marta Gómez', 'Calle 3 #789', 'PhD. en Computación', 10),
(4, '1004', 'Luis Torres', 'Calle 4 #012', 'Ingeniero de Software', 3),
(5, '1005', 'Sofía Ramírez', 'Calle 5 #345', 'Especialista en BD', 6),
(6, '1006', 'Jorge Herrera', 'Calle 6 #678', 'Analista Funcional', 4),
(7, '1007', 'Elena Castro', 'Calle 7 #901', 'Arquitecta de Software', 7),
(8, '1008', 'Pedro Rojas', 'Calle 8 #234', 'Desarrollador Full-Stack', 2),
(9, '1009', 'Laura Díaz', 'Calle 9 #567', 'Consultora TI', 9),
(10, '1010', 'Andrés Méndez', 'Calle 10 #890', 'Experto en Seguridad', 12);

INSERT INTO INFORMATICOS (ID_INFORMATICOS, NOMBRE, ROL) VALUES
(1, 'Luisa García', 'Analista'),
(2, 'Pedro Martínez', 'Programador'),
(3, 'María Fernández', 'Analista'),
(4, 'Juan Pérez', 'Programador'),
(5, 'Carmen Soto', 'Analista'),
(6, 'Diego Ríos', 'Programador'),
(7, 'Valeria Mora', 'Analista'),
(8, 'Ricardo Vargas', 'Programador'),
(9, 'Paula Castro', 'Analista'),
(10, 'Fernando Gutiérrez', 'Programador');

INSERT INTO LENGUAJE_PROGRAMACION (ID_LENGUAJE, NOMBRE) VALUES
(1, 'Python'),
(2, 'Java'),
(3, 'JavaScript'),
(4, 'C#'),
(5, 'PHP'),
(6, 'Ruby'),
(7, 'Swift'),
(8, 'Kotlin'),
(9, 'Go'),
(10, 'Rust');

INSERT INTO FASE (ID_FASE, NUM_SECUENCIA, NOMBRE, FECHA_INICIO, FECHA_FIN, ESTADO) VALUES
(1, 1, 'Planificación', '2023-01-01', '2023-01-15', 'Finalizada'),
(2, 2, 'Diseño', '2023-01-16', '2023-02-01', 'Finalizada'),
(3, 3, 'Desarrollo', '2023-02-02', '2023-04-30', 'En curso'),
(4, 4, 'Pruebas', '2023-05-01', '2023-05-15', 'En curso'),
(5, 5, 'Implementación', '2023-05-16', '2023-06-01', 'En curso'),
(6, 1, 'Análisis', '2023-02-01', '2023-02-15', 'Finalizada'),
(7, 2, 'Prototipado', '2023-02-16', '2023-03-15', 'Finalizada'),
(8, 3, 'Optimización', '2023-03-16', '2023-04-30', 'En curso'),
(9, 4, 'Documentación', '2023-05-01', '2023-05-10', 'En curso'),
(10, 5, 'Mantenimiento', '2023-05-11', '2023-06-01', 'En curso');

INSERT INTO RECURSOS (CODIGO, NOMBRE, DESCRIPCION, TIPO) VALUES
(1, 'Servidor HP', 'Servidor para despliegue', 'Hardware'),
(2, 'Licencia Windows', 'Licencia SO Windows', 'Software'),
(3, 'Router Cisco', 'Equipo de red', 'Hardware'),
(4, 'Visual Studio', 'IDE desarrollo', 'Software'),
(5, 'Impresora 3D', 'Prototipado rápido', 'Hardware'),
(6, 'MySQL Workbench', 'Gestor de BD', 'Software'),
(7, 'Disco Duro 1TB', 'Almacenamiento', 'Hardware'),
(8, 'Docker', 'Plataforma contenedores', 'Software'),
(9, 'Tarjeta Gráfica', 'Renderizado', 'Hardware'),
(10, 'GitHub', 'Control de versiones', 'Software');

INSERT INTO PROYECTO (PROY_CODIGO, FECHA_INICIO, FECHA_FIN, ALIADO, DESCRIPCION, NOMBRE, HORAS_ESTIMADAS, PRESUPUESTO, DOCENTE_CODIGO) VALUES
(1, '2023-01-01', '2023-06-30', 'Empresa A', 'Desarrollo ERP', 'ERP System', 500, 20000.00, 1),
(2, '2023-02-01', '2023-07-31', 'Empresa B', 'App Móvil', 'Mobile App', 300, 15000.00, 2),
(3, '2023-03-01', '2023-08-31', 'Empresa C', 'Sistema de Pagos', 'Payment Gateway', 400, 18000.00, 3),
(4, '2023-04-01', '2023-09-30', 'Empresa D', 'Plataforma E-learning', 'EduTech', 600, 25000.00, 4),
(5, '2023-05-01', '2023-10-31', 'Empresa E', 'Herramienta BI', 'Analytics Pro', 350, 17000.00, 5),
(6, '2023-06-01', '2023-11-30', 'Empresa F', 'Red Social', 'Social Connect', 450, 22000.00, 6),
(7, '2023-07-01', '2023-12-31', 'Empresa G', 'Juego Educativo', 'EduGame', 550, 21000.00, 7),
(8, '2023-08-01', '2024-01-31', 'Empresa H', 'CRM', 'Client Manager', 480, 23000.00, 8),
(9, '2023-09-01', '2024-02-28', 'Empresa I', 'IoT Platform', 'Smart Home', 520, 24000.00, 9),
(10, '2023-10-01', '2024-03-31', 'Empresa J', 'Blockchain', 'Secure Chain', 600, 26000.00, 10);

INSERT INTO PRODUCTOS (PROD_CODIGO, NOMBRE, DESCRIPCION, ESTADO, TIPO, VERSION, TIPO_SOFTWARE, UBICACION, RESPONSABLE_INFOR_ID) VALUES
(1, 'ERP Module', 'Módulo de finanzas', 'Finalizada', 'Software', NULL, 'Backend', NULL, 1),
(2, 'App UI Design', 'Diseño de interfaz', 'En curso', 'Prototipo', 'v1.0', NULL, '/prototipos/app', 3),
(3, 'Payment API', 'API de pagos', 'En curso', 'Software', NULL, 'REST', NULL, 5),
(4, 'E-learning Content', 'Cursos online', 'Finalizada', 'Informe', NULL, NULL, NULL, 7),
(5, 'Analytics Dashboard', 'Panel de datos', 'En curso', 'Software', NULL, 'Frontend', NULL, 9),
(6, 'Social Feed', 'Muro de publicaciones', 'Finalizada', 'Prototipo', 'v2.1', NULL, '/prototipos/social', 2),
(7, 'EduGame Mechanics', 'Mecánicas de juego', 'En curso', 'Informe', NULL, NULL, NULL, 4),
(8, 'CRM Database', 'Base de datos de clientes', 'Finalizada', 'Software', NULL, 'SQL', NULL, 6),
(9, 'IoT Firmware', 'Firmware para dispositivos', 'En curso', 'Prototipo', 'v0.5', NULL, '/prototipos/iot', 8),
(10, 'Blockchain Protocol', 'Protocolo de consenso', 'Finalizada', 'Software', NULL, 'Smart Contracts', NULL, 10);

INSERT INTO GASTOS (GASTOS_CODIGO, DESCRIPCION, FECHA, IMPORTE, TIPO, DOCENTES_CODIGO, PROY_CODIGO) VALUES
(1, 'Viaje a cliente', '2023-01-10', 500.00, 'Viajes', 1, 1),
(2, 'Licencia software', '2023-02-15', 1200.00, 'Software', 2, 2),
(3, 'Alojamiento equipo', '2023-03-20', 300.00, 'Alojamiento', 3, 3),
(4, 'Compra hardware', '2023-04-05', 800.00, 'Hardware', 4, 4),
(5, 'Capacitación', '2023-05-12', 450.00, 'Dietas', 5, 5),
(6, 'Mantenimiento servidores', '2023-06-18', 700.00, 'Hardware', 6, 6),
(7, 'Publicidad', '2023-07-22', 950.00, 'Marketing', 7, 7),
(8, 'Consultoría externa', '2023-08-30', 600.00, 'Consultoría', 8, 8),
(9, 'Herramientas desarrollo', '2023-09-14', 350.00, 'Software', 9, 9),
(10, 'Seguros', '2023-10-25', 400.00, 'Seguros', 10, 10);

INSERT INTO DOMINA (INFORMATICOS_ID, LENGUAJE_ID) VALUES
(2, 1), (2, 2),
(4, 3), (4, 4), 
(6, 5), (6, 6), 
(8, 7), (8, 8),
(10, 9), (10, 10);

INSERT INTO UTILIZA (RECURSO_CODIGO, FASE_ID, FECHA_INICIO, FECHA_FIN) VALUES
(1, 1, '2023-01-01', '2023-01-15'),
(2, 2, '2023-01-16', '2023-02-01'),
(3, 3, '2023-02-02', '2023-04-30'),
(4, 4, '2023-05-01', '2023-05-15'),
(5, 5, '2023-05-16', '2023-06-01'),
(6, 6, '2023-02-01', '2023-02-15'),
(7, 7, '2023-02-16', '2023-03-15'),
(8, 8, '2023-03-16', '2023-04-30'),
(9, 9, '2023-05-01', '2023-05-10'),
(10, 10, '2023-05-11', '2023-06-01');

INSERT INTO GENERA (FASE_ID, PROD_CODIGO, HORAS_DEDICADAS) VALUES
(1, 1, 40),
(2, 2, 30),
(3, 3, 50),
(4, 4, 20),
(5, 5, 60),
(6, 6, 35),
(7, 7, 25),
(8, 8, 45),
(9, 9, 55),
(10, 10, 70);

INSERT INTO PARTICIPA (PROY_CODIGO, INFORMATICO_ID, TARIFA_HORA, HORAS_DEDICADAS) VALUES
(1, 1, 50.00, 100),
(2, 2, 60.00, 80),
(3, 3, 55.00, 120),
(4, 4, 70.00, 90),
(5, 5, 45.00, 150),
(6, 6, 65.00, 110),
(7, 7, 40.00, 130),
(8, 8, 75.00, 95),
(9, 9, 50.00, 140),
(10, 10, 80.00, 85);

/* Consultas de acción */

UPDATE DOCENTES
SET ANIOS_EXP = ANIOS_EXP + 1
WHERE DOCENTES_CODIGO = 3;


UPDATE INFORMATICOS
SET ROL = 'Programador'
WHERE ID_INFORMATICOS = 1 AND ROL = 'Analista';


UPDATE LENGUAJE_PROGRAMACION
SET NOMBRE = 'Python 3'
WHERE ID_LENGUAJE = 1;


UPDATE FASE
SET ESTADO = 'Finalizada'
WHERE ID_FASE = 3;


UPDATE PRODUCTOS
SET DESCRIPCION = 'Módulo actualizado de gestión financiera'
WHERE PROD_CODIGO = 1;


UPDATE PROYECTO
SET HORAS_ESTIMADAS = HORAS_ESTIMADAS + 50
WHERE PROY_CODIGO = 2;


DELETE FROM GASTOS
WHERE TIPO = 'Seguros' AND GASTOS_CODIGO = 10;


UPDATE DOCENTES
SET TITULO = 'Licenciado en Informática'
WHERE DOCENTES_CODIGO = 2;


DELETE FROM DOMINA
WHERE INFORMATICOS_ID = 4 AND LENGUAJE_ID = 3;


DELETE FROM PARTICIPA
WHERE PROY_CODIGO = 5 AND INFORMATICO_ID = 5;


/* Consultas de selección */

SELECT DOCENTES_CODIGO, NOMBRE, ANIOS_EXP
FROM DOCENTES
WHERE ANIOS_EXP > 5;


SELECT ID_INFORMATICOS, NOMBRE, ROL
FROM INFORMATICOS
ORDER BY NOMBRE ASC;


SELECT ESTADO, COUNT(*) AS Cantidad_Fases
FROM FASE
GROUP BY ESTADO;


SELECT PROD_CODIGO, NOMBRE, ESTADO
FROM PRODUCTOS
WHERE ESTADO = 'En curso'
  AND NOMBRE LIKE '%API%';


SELECT PROY_CODIGO, NOMBRE, PRESUPUESTO, FECHA_INICIO
FROM PROYECTO
WHERE PRESUPUESTO > 20000
ORDER BY FECHA_INICIO;


SELECT TIPO, SUM(IMPORTE) AS Total_Gasto
FROM GASTOS
GROUP BY TIPO
HAVING SUM(IMPORTE) > 1000;


SELECT CODIGO, NOMBRE, DESCRIPCION
FROM RECURSOS
WHERE TIPO = 'Hardware';


SELECT D.INFORMATICOS_ID, I.NOMBRE AS Informatico, 
       D.LENGUAJE_ID, L.NOMBRE AS Lenguaje
FROM DOMINA D
JOIN INFORMATICOS I ON D.INFORMATICOS_ID = I.ID_INFORMATICOS
JOIN LENGUAJE_PROGRAMACION L ON D.LENGUAJE_ID = L.ID_LENGUAJE;


SELECT U.RECURSO_CODIGO, R.NOMBRE AS Recurso,
       U.FASE_ID, F.NOMBRE AS Fase,
       U.PERIODO_USO
FROM UTILIZA U
JOIN RECURSOS R ON U.RECURSO_CODIGO = R.CODIGO
JOIN FASE F ON U.FASE_ID = F.ID_FASE;


SELECT P.PROY_CODIGO, PR.NOMBRE AS Proyecto,
       P.INFORMATICO_ID, I.NOMBRE AS Informatico,
       P.TARIFA_HORA, P.HORAS_DEDICADAS,
       P.TARIFA_HORA * P.HORAS_DEDICADAS AS COSTE_TOTAL
FROM PARTICIPA P
JOIN PROYECTO PR ON P.PROY_CODIGO = PR.PROY_CODIGO
JOIN INFORMATICOS I ON P.INFORMATICO_ID = I.ID_INFORMATICOS;