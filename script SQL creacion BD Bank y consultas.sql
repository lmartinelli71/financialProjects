#Se crea la base de datos DJII con sus correspondientes tablas y relaciones
CREATE SCHEMA DJII;
USE DJII;

CREATE TABLE COUNTRY (
  ID_COUNTRY INT PRIMARY KEY,
  COUNTRY VARCHAR(50)
);

CREATE TABLE STATE (
  ID_STATE INT PRIMARY KEY,
  STATE VARCHAR(50),
  ID_COUNTRY INT,
  FOREIGN KEY (ID_COUNTRY) REFERENCES COUNTRY(ID_COUNTRY)
);

CREATE TABLE CITY (
  ID_CITY INT PRIMARY KEY,
  CITY VARCHAR(50),
  ID_STATE INT,
  FOREIGN KEY (ID_STATE) REFERENCES STATE(ID_STATE)
);

CREATE TABLE SECTOR (
  ID_SECTOR INT PRIMARY KEY,
  SECTOR VARCHAR(50)
);

CREATE TABLE COMPANY (
  ID_COMPANY CHAR(8) NOT NULL PRIMARY KEY,
  NAME_COMPANY VARCHAR(50),
  ID_CITY INT,
  ID_SECTOR INT,
  YEAR_FUNDATION INT,
  FOREIGN KEY (ID_CITY) REFERENCES CITY(ID_CITY),
  FOREIGN KEY (ID_SECTOR) REFERENCES SECTOR(ID_SECTOR)
);

CREATE TABLE OPERATION (
  ID_TRX INT PRIMARY KEY,
  ID_COMPANY CHAR(8),
  DATE_TRX DATE,
  OPEN_PRICE DECIMAL(10,2),
  HIGH_PRICE DECIMAL(10,2),
  LOW_PRICE DECIMAL(10,2),
  CLOSE_PRICE DECIMAL(10,2),
  ADJ_CLOSE_PRICE DECIMAL(10,2),
  VOLUME INT,
  FOREIGN KEY (ID_COMPANY) REFERENCES COMPANY(ID_COMPANY)
);


#Se insertan los datos del archivo EMPRESAS en las tablas COUNTRY, STATE, CITY, SECTOR y COMPANY
INSERT INTO COUNTRY (ID_COUNTRY, COUNTRY) VALUES (1, 'US');

INSERT INTO STATE (ID_STATE, STATE, ID_COUNTRY)
VALUES (1, 'Arkansas', 1), (2, 'California', 1),  (3, 'Delaware', 1),
  (4, 'Georgia', 1),  (5, 'Illinois', 1),  (6, 'Indiana', 1),
  (7, 'Michigan', 1),  (8, 'Minessota', 1),  (9, 'New Jersey', 1),
  (10, 'New Mexico', 1),  (11, 'New York', 1),  (12, 'Ohio', 1),
  (13, 'Oregon', 1),  (14, 'Texas', 1),  (15, 'Washington', 1);
  
  INSERT INTO CITY (ID_CITY, CITY, ID_STATE)
VALUES (1, 'Albuquerque', 10),   (2, 'Atlanta', 4),  (3, 'Buffalo', 11),  (4, 'Cincinnati', 12),  (5, 'Deerfield', 5),
  (6, 'Delaware', 3),  (7, 'Endicott', 11),  (8, 'Eugene', 13),  (9, 'Fresno', 2),  (10, 'Irving', 14),
  (11, 'Los Altos', 2),  (12, 'Los Angeles', 2),  (13, 'Marietta', 4),  (14, 'Midland', 7),  (15, 'Minnetonka', 8),
  (16, 'New Brunswick', 9),  (17, 'New York', 11),  (18, 'Rogers', 1),  (19, 'Saint Paul', 8),  (20, 'San Bernardino', 2),
  (21, 'San Francisco', 2),  (22, 'San Jose', 2),  (23, 'San Ramon', 2),  (24, 'Santa Clara', 2),  (25, 'Seattle', 15),
  (26, 'Thousand Oaks', 2),  (27, 'Two Harbors', 8),  (28, 'Wabash', 6);
  
  INSERT INTO SECTOR (ID_SECTOR, SECTOR) 
  VALUES (1, 'Alimentos'),(2, 'Bebidas'),(3, 'Construccion'),(4, 'Consumo masivo'),
(5, 'Farmaceutica'),(6, 'Financiero'),(7, 'Indumentaria'),(8, 'Industria aérea'),
(9, 'Medios de comunicacion'),(10, 'Petroleo'),(11, 'Quimica'),(12, 'Retail'),
(13, 'Seguros'),(14, 'Servicios'),(15, 'Tecnología'),(16, 'Telecomunicaciones');


INSERT INTO COMPANY (ID_COMPANY, NAME_COMPANY, ID_CITY, ID_SECTOR, YEAR_FUNDATION)
VALUES ('MCD','McDonalds Corp.',20,1,1955), ('KO','Coca-Cola Co.',2,2,1892),('CAT','Caterpillar Inc.',10,3,1925),('PG','Procter & Gamble Co.',4,4,1837),
('JNJ','Johnson & Johnson',16,5,1886),('MRK','Merck & Co. Inc.',17,5,1891),('AXP','American Express Co.',3,6,1850),('VISA.VI','Visa Inc.',9,6,1958),
('GS','Goldman Sachs Group Inc.',17,6,1869),('JPM','JPMorgan Chase & Co.',17,6,2000),('NKE.VI','Nike Inc.',8,7,1964),
('BA','Boeing Co.',25,8,1916),('DIS','Walt Disney Co.',12,9,1923),('CVX','Chevron Corp.',23,10,1879),('DOW','Dow Inc.',14,11,2018),
('WBA','Walgreens Boots Alliance Inc.',5,12,2014),('HD','Home Depot Inc.',13,12,1978),('WMT','Walmart Inc.',18,12,1962),
('PA9.F','Travelers Cos. Inc.',19,13,1853),('UNH','UnitedHealth Group Inc.',15,14,1977),('MSFT','Microsoft Corp.',1,15,1975),
('IBM','International Business Machines Corp.',7,15,1911),('AAPL','Apple Inc.',11,15,1976),('CRM','Salesforce Inc.',21,15,1999),
('INTC','Intel Corp.',24,15,1968),('AMGN','Amgen Inc.',26,15,1980),('MMM','3M Co.',27,15,1902),('HON','Honeywell International Inc.',28,15,1906),
('VZ','Verizon Communications Inc.',6,16,1983),('CSCO','Cisco Systems Inc.',22,16,1984);


## 1 Consulta donde se obtienen todas las empresas  
SELECT NAME_COMPANY FROM COMPANY; 


## 2 La consulta devuelve una tabla con los sectores
SELECT SECTOR FROM SECTOR; 

## 3 Consulta devuelve el estado con mayor cantidad de companias
SELECT STATE, COUNT(*) AS CANTIDAD_EMPRESAS  
FROM COMPANY
JOIN CITY ON COMPANY.ID_CITY = CITY.ID_CITY
JOIN STATE ON CITY.ID_STATE = STATE.ID_STATE
GROUP BY STATE
ORDER BY CANTIDAD_EMPRESAS DESC
LIMIT 1;


# 4 Estado con maxima cantidad de ciudades
SELECT STATE, COUNT(DISTINCT CITY) AS CANTIDAD_CIUDADES  
FROM COMPANY
JOIN CITY ON COMPANY.ID_CITY = CITY.ID_CITY
JOIN STATE ON CITY.ID_STATE = STATE.ID_STATE
GROUP BY STATE
ORDER BY COUNT(*) DESC
LIMIT 1;


## 5 La consulta devuelve una tabla con el nombre de la compania, el dia de la semana de maxima cotizacion de cierre y el valor de la cotizacion
SELECT COMPANY.NAME_COMPANY,      
       DATE_FORMAT(OPERATION.DATE_TRX, '%W') AS DAY_OF_WEEK,
       MAX(OPERATION.CLOSE_PRICE) AS MAX_CLOSE_PRICE
FROM COMPANY
JOIN OPERATION ON COMPANY.ID_COMPANY = OPERATION.ID_COMPANY
GROUP BY COMPANY.ID_COMPANY, DAY_OF_WEEK
HAVING MAX(OPERATION.CLOSE_PRICE) = (
    SELECT MAX(CLOSE_PRICE) 
    FROM OPERATION 
    WHERE ID_COMPANY = COMPANY.ID_COMPANY
    GROUP BY DAY_OF_WEEK
)
ORDER BY COMPANY.NAME_COMPANY;


## 6 Sector con mayor volumen operado y monto total de ese volumen
SELECT SECTOR.SECTOR, SUM(OPERATION.VOLUME) AS VOLUMEN_TOTAL_OPERADO   
FROM SECTOR
JOIN COMPANY ON SECTOR.ID_SECTOR = COMPANY.ID_SECTOR
JOIN OPERATION ON COMPANY.ID_COMPANY = OPERATION.ID_COMPANY
GROUP BY SECTOR.SECTOR
ORDER BY VOLUMEN_TOTAL_OPERADO DESC
LIMIT 1;


# 7 Cotizacion de cierre minima y maxima por sector
SELECT SECTOR.SECTOR,                   
       MIN(OPERATION.CLOSE_PRICE) AS MIN_CLOSE_PRICE, 
       MAX(OPERATION.CLOSE_PRICE) AS MAX_CLOSE_PRICE
FROM SECTOR
JOIN COMPANY ON SECTOR.ID_SECTOR = COMPANY.ID_SECTOR
JOIN OPERATION ON COMPANY.ID_COMPANY = OPERATION.ID_COMPANY
GROUP BY SECTOR.SECTOR
ORDER BY SECTOR.SECTOR;


## 8 Diferencia entre el precio de cotizacion maximo y minimo diario por compania (ordenado en forma descendente por id_company y diferencia)
SELECT DATE_TRX, ID_COMPANY, (HIGH_PRICE - LOW_PRICE) AS DIFFERENCIA
FROM OPERATION
ORDER BY ID_COMPANY,DIFFERENCIA DESC;


## 9 Promedio, varianza y desvio del precio de cierre en el periodo por compania
SELECT    
    OPERATION.ID_COMPANY, 
    AVG(OPERATION.CLOSE_PRICE) AS MEDIA,
    VARIANCE(OPERATION.CLOSE_PRICE) AS VARIANZA,
    STDDEV(OPERATION.CLOSE_PRICE) AS DESVIACION_ESTANDAR
FROM 
    OPERATION
GROUP BY 
    OPERATION.ID_COMPANY;


## 10 Mediana de precio de cierre en el periodo por compania 
SELECT  
    ID_COMPANY,
    AVG(median) AS Mediana_Precio_Cierre_Compania
FROM 
    (
        SELECT 
            ID_COMPANY,
            SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(CLOSE_PRICE ORDER BY CLOSE_PRICE), ',', FLOOR((1 + COUNT(*)) / 2)), ',', -1) AS median
        FROM 
            OPERATION
        GROUP BY 
            ID_COMPANY
    ) AS subquery
GROUP BY 
    ID_COMPANY;


## 11 Compania con maxima diferencia entre el precio maximo y el minimo diario 
SELECT ID_COMPANY, MAX(HIGH_PRICE - LOW_PRICE) AS MAX_DIFFERENCE
FROM OPERATION
GROUP BY ID_COMPANY
ORDER BY MAX_DIFFERENCE DESC
LIMIT 1;


## 12 Compania con maxima media de precio de cierre en el periodo
SELECT                   
    ID_COMPANY,
    AVG(CLOSE_PRICE) AS MAX_PRECIO_MEDIO_CIERRE
FROM 
    OPERATION
GROUP BY 
    ID_COMPANY
ORDER BY 
    MAX_PRECIO_MEDIO_CIERRE DESC
LIMIT 1;


## 13 Compania con maximo valor de mediana de precio de cierre en el periodo
SELECT    
    ID_COMPANY,
    AVG(median) AS MAX_PRECIO_MEDIANO_CIERRE
FROM 
    (
        SELECT 
            ID_COMPANY,
            SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(CLOSE_PRICE ORDER BY CLOSE_PRICE), ',', FLOOR((1 + COUNT(*)) / 2)), ',', -1) AS median
        FROM 
            OPERATION
        GROUP BY 
            ID_COMPANY
    ) AS subquery
GROUP BY 
    ID_COMPANY
ORDER BY 
    MAX_PRECIO_MEDIANO_CIERRE DESC
LIMIT 1;

## 14 Compania con maximo valor de la varianza de precio de cierre en el periodo
SELECT  
    ID_COMPANY, 
    VARIANCE(CLOSE_PRICE) AS MAX_VARIANZA
FROM 
    OPERATION
GROUP BY 
    ID_COMPANY
ORDER BY 
    MAX_VARIANZA DESC
LIMIT 1;


## 15 Compania con maximo valor del desvio de precio de cierre en el periodo 
SELECT     
    OPERATION.ID_COMPANY,
    STDDEV(OPERATION.CLOSE_PRICE) AS MAX_DESVIO_ESTANDAR
FROM 
    OPERATION
GROUP BY 
    OPERATION.ID_COMPANY
ORDER BY 
    MAX_DESVIO_ESTANDAR DESC
LIMIT 1;

##FUNCIONES
## 16 Funcion que calcula diferencia
DELIMITER $$                                          
CREATE FUNCTION calcularDiferencia(high DECIMAL(10,2), low DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  DECLARE dif DECIMAL(10,2);
  SET dif = high - low;
  RETURN dif;
END $$
DELIMITER ;

#Se aplica la funcion calcularDiferencia para obtener la lista de companias segun su diferencia entre valor maximo y minimo de cotizacion diaria
#ordenado en forma descendente segun ID_COMPANY y diferencia
SELECT o.DATE_TRX,c.ID_COMPANY, calcularDiferencia(o.HIGH_PRICE, o.LOW_PRICE) AS DIFERENCIA
FROM COMPANY c
INNER JOIN OPERATION o ON c.ID_COMPANY = o.ID_COMPANY
ORDER BY 
ID_COMPANY,DIFERENCIA DESC;

## 17 Funcion que calcula antiguedad
DELIMITER $$                    
CREATE FUNCTION calcularAntiguedad(fundationYear INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE currentYear INT;
  DECLARE ant INT;
  SET currentYear = YEAR(CURRENT_DATE());
  SET ant = currentYear - fundationYear;
  RETURN ant;
END $$
DELIMITER ;

#Se ejecuta la funcion que calcula antiguedad para obtener la antiguedad de todas las companias
SELECT c.ID_COMPANY, c.NAME_COMPANY, calcularAntiguedad(c.YEAR_FUNDATION) AS ANTIGUEDAD
FROM COMPANY c;

##PROCEDIMIENTO
##Procedimiento que calcula por compania durante el periodo para la variable precio de cierre ordenado de mayor a menor : 1) Media
# 2) Mediana, 3) Varianza y 4) Desvio .El resultado es similar al 5e

DELIMITER $$
USE `djii`$$
CREATE PROCEDURE `estadisticos_close_price` ()

#subrutina que calcula por empresa la media en el precio de cierre durante el periodo

BEGIN
SELECT                   
    ID_COMPANY,
    AVG(CLOSE_PRICE) AS PRECIO_MEDIO_CIERRE
FROM 
    OPERATION
GROUP BY 
    ID_COMPANY
ORDER BY 
    PRECIO_MEDIO_CIERRE DESC;


#subrutina que calcula por empresa la mediana en el precio de cierre durante el periodo
SELECT    
    ID_COMPANY,
    AVG(median) AS PRECIO_MEDIANO_CIERRE
FROM 
    (
        SELECT 
            ID_COMPANY,
            SUBSTRING_INDEX(SUBSTRING_INDEX(GROUP_CONCAT(CLOSE_PRICE ORDER BY CLOSE_PRICE), ',', FLOOR((1 + COUNT(*)) / 2)), ',', -1) AS median
        FROM 
            OPERATION
        GROUP BY 
            ID_COMPANY
    ) AS subquery
GROUP BY 
    ID_COMPANY
ORDER BY 
    PRECIO_MEDIANO_CIERRE DESC;

# Subrutuna que calcula por empresa la varianza en el precio de cierre durante el periodo
SELECT    
    ID_COMPANY, 
    VARIANCE(CLOSE_PRICE) AS VARIANZA
FROM 
    OPERATION
GROUP BY 
    ID_COMPANY
ORDER BY 
    VARIANZA DESC;

# Subrutina que calcula por empresa los desvios en el precio de cierre durante el periodo
SELECT     
    OPERATION.ID_COMPANY,
    STDDEV(OPERATION.CLOSE_PRICE) AS DESVIO_ESTANDAR
FROM 
    OPERATION
GROUP BY 
    OPERATION.ID_COMPANY
ORDER BY 
    DESVIO_ESTANDAR DESC;
END$$
DELIMITER ;


#Llamada al procedimiento 
CALL estadisticos_close_price();


###TRIGGERS
#Se crea la tabla donde se almacenan los datos del trigger
CREATE TABLE Audit (ID_STATE INT PRIMARY KEY, ID_COUNTRY INT,CREATED_ON DATETIME (6));

#se crea el trigger
DELIMITER $$ 
CREATE TRIGGER state_insert_trigger
AFTER INSERT ON State
FOR EACH ROW
BEGIN
  INSERT INTO Audit(ID_STATE,ID_COUNTRY,CREATED_ON) 
  VALUES (NEW.ID_STATE,NEW.ID_COUNTRY,now());
END$$
DELIMITER ;

#Se prueba el trigger
INSERT INTO State (ID_STATE, STATE, ID_COUNTRY) VALUES (16, 'Florida', 1);
SELECT * FROM audit