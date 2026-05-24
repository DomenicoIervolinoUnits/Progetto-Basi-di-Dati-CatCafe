CREATE TABLE `Adozione` (
  `IDPratica` int NOT NULL,
  `Gatto` bigint DEFAULT NULL,
  `Cliente` int DEFAULT NULL,
  `Responsabile` char(16) DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `StatoPratica` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`IDPratica`),
  KEY `Gatto` (`Gatto`),
  KEY `Cliente` (`Cliente`),
  KEY `Responsabile` (`Responsabile`),
  CONSTRAINT `adozione_ibfk_1` FOREIGN KEY (`Gatto`) REFERENCES `Gatto` (`Microchip`),
  CONSTRAINT `adozione_ibfk_2` FOREIGN KEY (`Cliente`) REFERENCES `Cliente` (`IDCliente`),
  CONSTRAINT `adozione_ibfk_3` FOREIGN KEY (`Responsabile`) REFERENCES `Dipendente` (`CodiceFiscale`)
)

CREATE TABLE `Cliente` (
  `IDCliente` int NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Cognome` varchar(100) DEFAULT NULL,
  `Contatto` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`IDCliente`)
)

CREATE TABLE `DettaglioScontrino` (
  `Scontrino` int NOT NULL,
  `Prodotto` int NOT NULL,
  `Quantità` int DEFAULT NULL,
  `PrezzoUnitario` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`Scontrino`,`Prodotto`),
  KEY `Prodotto` (`Prodotto`),
  CONSTRAINT `dettaglioscontrino_ibfk_1` FOREIGN KEY (`Scontrino`) REFERENCES `Scontrino` (`IDScontrino`),
  CONSTRAINT `dettaglioscontrino_ibfk_2` FOREIGN KEY (`Prodotto`) REFERENCES `Prodotto` (`IDProdotto`)
)

CREATE TABLE `Dipendente` (
  `CodiceFiscale` char(16) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Cognome` varchar(100) DEFAULT NULL,
  `Ruolo` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`CodiceFiscale`)
)

CREATE TABLE `Gatto` (
  `Microchip` bigint NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Razza` varchar(100) DEFAULT NULL,
  `Informazioni` varchar(255) DEFAULT NULL,
  `DataDiNascita` date DEFAULT NULL,
  `Foto` blob,
  `InizioAccoglienza` date DEFAULT NULL,
  `FineAccoglienza` date DEFAULT NULL,
  `PresenzaInSala` tinyint(1) DEFAULT NULL,
  `StatoAdottabilità` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Microchip`)
)

CREATE TABLE `Prenotazione` (
  `IDPrenotazione` int NOT NULL,
  `Tavolo` int DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `Ora` time DEFAULT NULL,
  `Nominativo` varchar(255) DEFAULT NULL,
  `Persone` int DEFAULT NULL,
  PRIMARY KEY (`IDPrenotazione`),
  KEY `Tavolo` (`Tavolo`),
  CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`Tavolo`) REFERENCES `Tavolo` (`NumeroTavolo`)
)

CREATE TABLE `Prodotto` (
  `IDProdotto` int NOT NULL,
  `Nome` varchar(255) DEFAULT NULL,
  `Prezzo` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`IDProdotto`)
)

CREATE TABLE `Scontrino` (
  `IDScontrino` int NOT NULL,
  `Operatore` char(16) DEFAULT NULL,
  `Tavolo` int DEFAULT NULL,
  `Timestamp` timestamp NULL DEFAULT NULL,
  `Totale` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`IDScontrino`),
  KEY `Operatore` (`Operatore`),
  KEY `Tavolo` (`Tavolo`),
  CONSTRAINT `scontrino_ibfk_1` FOREIGN KEY (`Operatore`) REFERENCES `Dipendente` (`CodiceFiscale`),
  CONSTRAINT `scontrino_ibfk_2` FOREIGN KEY (`Tavolo`) REFERENCES `Tavolo` (`NumeroTavolo`)
)

CREATE TABLE `Tavolo` (
  `NumeroTavolo` int NOT NULL,
  `Capacità` int DEFAULT NULL,
  `Stato` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`NumeroTavolo`)
)

CREATE TABLE `Visita` (
  `IDVisita` int NOT NULL,
  `Gatto` bigint DEFAULT NULL,
  `Data` date DEFAULT NULL,
  `TipoVisita` varchar(100) DEFAULT NULL,
  `StudioVeterinario` varchar(255) DEFAULT NULL,
  `Note` text,
  PRIMARY KEY (`IDVisita`),
  KEY `Gatto` (`Gatto`),
  CONSTRAINT `visita_ibfk_1` FOREIGN KEY (`Gatto`) REFERENCES `Gatto` (`Microchip`)
)