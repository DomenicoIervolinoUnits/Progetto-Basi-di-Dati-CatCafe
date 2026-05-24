CREATE VIEW vistaGatti AS
  SELECT nome, razza, informazioni
  FROM gatto
  WHERE presenzaInSala = TRUE
--
--
CREATE VIEW vistaAdozioni AS
  SELECT IDPratica, gatto, cliente
  FROM adozione
  WHERE statoPratica = "Conclusa"
--
--
DELIMITER //
CREATE PROCEDURE storicoVisite(IN p_microchip BIGINT(15))
	BEGIN
		SELECT IDVisita, gatto, note, data, TipoVisita
		FROM visita
		WHERE gatto = p_microchip;
	END //
DELIMITER ;
CALL storicoVisite(100000000000001);
--
--
DELIMITER //
CREATE TRIGGER catAgeCheck
	BEFORE INSERT ON gatto
	FOR EACH ROW
	BEGIN
		IF NEW.presenzaInSala = TRUE THEN
			IF NEW.DataDiNascita > NOW() - INTERVAL 1 YEAR THEN
				SIGNAL sqlstate '45001' SET message_text = "Il gatto non può essere presente in sala a questa età.";
			END IF;
		END IF;
	END //
DELIMITER ;
--
--
DELIMITER //
CREATE TRIGGER catAdoptAgeCheck
	BEFORE INSERT ON gatto
	FOR EACH ROW
	BEGIN
		IF NEW.StatoAdottabilità = TRUE THEN
			IF NEW.DataDiNascita > CURDATE() - INTERVAL 30 DAY THEN
				SIGNAL sqlstate '45001' SET message_text = "Il gatto non può ancora ricevere richieste di adozione.";
			END IF;
		END IF;
	END //
DELIMITER ;
--
--
DELIMITER //
CREATE TRIGGER adoptionCheck
	BEFORE INSERT ON adozione
	FOR EACH ROW
	BEGIN
		IF NEW.responsabile NOT IN (SELECT CodiceFiscale FROM dipendente WHERE ruolo = "manager") THEN
			SIGNAL sqlstate '45001' SET message_text = "Solo un manager può gestire le adozioni.";
		END IF;
	END //
DELIMITER ;
--
--
DELIMITER //
CREATE TRIGGER dateConsinstency
	BEFORE INSERT ON gatto
	FOR EACH ROW
	BEGIN
		IF NEW.FineAccoglienza IS NOT NULL THEN
			IF NEW.InizioAccoglienza > NEW.FineAccoglienza THEN
				SIGNAL sqlstate '45001' SET message_text = "Inconsistenza con le date";
			END IF;
		END IF;
	END //
DELIMITER ;
--
--
DELIMITER //
CREATE TRIGGER adoptabilityCheck
	BEFORE INSERT ON adozione
	FOR EACH ROW
	BEGIN
		IF EXISTS(SELECT 1
				FROM gatto
				WHERE StatoAdottabilità = FALSE
				AND microchip = NEW.gatto
		) THEN
			SIGNAL sqlstate '45001' SET message_text = "Il gatto non è disponibile per l'adozione.";
		END IF;
	END //
DELIMITER ;
--
--
DELIMITER //
CREATE TRIGGER tableConsinstency
	BEFORE INSERT ON prenotazione
	FOR EACH ROW
	BEGIN
		IF NEW.Persone > (SELECT capacità
				FROM tavolo
				WHERE numeroTavolo = NEW.tavolo
		) THEN
			SIGNAL sqlstate '45001' SET message_text = "Troppe persone per quel tavolo";
		END IF;
	END //
DELIMITER ;
