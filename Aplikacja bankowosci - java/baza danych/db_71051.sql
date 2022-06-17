-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 54.38.131.251:3306
-- Czas generowania: 03 Cze 2021, 22:23
-- Wersja serwera: 10.3.27-MariaDB-0+deb10u1
-- Wersja PHP: 7.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `db_71051`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `dropContact` (IN `contact_id` INT, IN `user_id` INT)  BEGIN
    SET @t1 = CONCAT('DELETE FROM kontakty WHERE id=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING contact_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Usunięcie kontaktu',CONCAT('Usunięto kontakt id ', contact_id, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `dropDeposit` (IN `deposit_id` INT, IN `deposit_balance` INT, IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy_rachunki SET uzytkownicy_rachunki.saldo=uzytkownicy_rachunki.saldo+ ? WHERE uzytkownicy_rachunki.uzytkownicy_id=? AND uzytkownicy_rachunki.rachunki_id=1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING deposit_balance,user_id;
    DEALLOCATE PREPARE stmt;
    
    SET @t2 = CONCAT('DELETE FROM uzytkownicy_lokaty WHERE id=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t2;
    EXECUTE stmt USING deposit_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zlikwidowano lokatę - przed czasem zakończenia',CONCAT('Zlikwidowano lokatę id  ', deposit_id, ', zwrócono kwotę ',deposit_balance,'PLN na rachunek główny.'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getBillByBillNumber` (IN `bill_number` VARCHAR(16))  BEGIN
	SET @t1 = CONCAT('SELECT id,nr_rachunku,saldo,uzytkownicy_id,rachunki_id FROM uzytkownicy_rachunki WHERE nr_rachunku=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING bill_number;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getBills` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT rachunki.id,rachunki.nazwa,uzytkownicy_rachunki.nr_rachunku,uzytkownicy_rachunki.data_zalozenia,uzytkownicy_rachunki.saldo,waluty.nazwa_skrot,uzytkownicy_rachunki.id FROM rachunki JOIN uzytkownicy_rachunki ON rachunki.id=uzytkownicy_rachunki.rachunki_id JOIN waluty ON rachunki.waluty_id=waluty.id WHERE uzytkownicy_rachunki.uzytkownicy_id=? AND uzytkownicy_rachunki.data_likwidacji IS NULL GROUP BY uzytkownicy_rachunki.id');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getContactByID` (IN `bill_contact` VARCHAR(16), IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT id FROM kontakty WHERE uzytkownicy_rachunki_odbiorca=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING bill_contact,user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getContacts` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT id,nazwa,uzytkownicy_rachunki_odbiorca FROM kontakty WHERE uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getDeposits` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT lokaty.nazwa,lokaty.oprocentowanie,uzytkownicy_lokaty.saldo,uzytkownicy_lokaty.data_otwarcia,uzytkownicy_lokaty.data_zakonczenia,waluty.nazwa_skrot,uzytkownicy_lokaty.id,lokaty.czas_trwania FROM lokaty JOIN uzytkownicy_lokaty ON lokaty.id=uzytkownicy_lokaty.lokaty_id JOIN waluty ON lokaty.waluty_id=waluty.id WHERE uzytkownicy_lokaty.uzytkownicy_id=? AND uzytkownicy_lokaty.zakonczono=0 GROUP BY uzytkownicy_lokaty.id');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getExchangeRates` ()  BEGIN
	SELECT waluty.nazwa,waluty.nazwa_skrot,waluty.symbol,waluty_kursy.kurs_kupna,waluty_kursy.kurs_sprzedazy FROM waluty JOIN waluty_kursy ON waluty.id=waluty_kursy.waluty_id;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getHelp` (IN `id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT sprawa.id,sprawa.temat,sprawa.data_otwarcia,sprawa.data_zakonczenia,COUNT(sprawa_wiadomosci.sprawa_id)
FROM sprawa
JOIN sprawa_wiadomosci ON sprawa.id=sprawa_wiadomosci.sprawa_id
WHERE sprawa.uzytkownicy_id=? GROUP BY sprawa.id');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getHelp_Employee` ()  BEGIN
	SET @t1 = CONCAT('SELECT sprawa.id,sprawa.temat,sprawa.data_otwarcia,sprawa.data_zakonczenia,COUNT(sprawa_wiadomosci.sprawa_id OR 0) FROM sprawa JOIN sprawa_wiadomosci ON sprawa.id=sprawa_wiadomosci.sprawa_id WHERE sprawa.data_zakonczenia IS NULL GROUP BY sprawa.id');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getInfoAboutDeposits` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT uzytkownicy_rachunki.saldo,lokaty.id,lokaty.nazwa,lokaty.oprocentowanie,lokaty.czas_trwania,lokaty.limit_kwoty FROM uzytkownicy_rachunki JOIN lokaty WHERE uzytkownicy_rachunki.uzytkownicy_id=? AND uzytkownicy_rachunki.rachunki_id=1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getMainBill` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT nr_rachunku FROM uzytkownicy_rachunki WHERE uzytkownicy_id=? AND rachunki_id=1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getMessageHelp` (IN `id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT sprawa_wiadomosci.id,sprawa_wiadomosci.data,sprawa_wiadomosci.wiadomosc,uzytkownicy.imie,uzytkownicy.nazwisko,uzytkownicy.identyfikator,sprawa.data_zakonczenia FROM sprawa_wiadomosci JOIN uzytkownicy ON sprawa_wiadomosci.uzytkownicy_id=uzytkownicy.id JOIN sprawa ON sprawa.id=sprawa_wiadomosci.sprawa_id WHERE sprawa_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getOnlyDeposits` ()  BEGIN
	SET @t1 = CONCAT('SELECT id,nazwa,oprocentowanie,czas_trwania,limit_kwoty,aktywna FROM lokaty WHERE aktywna=1');

    
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getPaysIn` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT * FROm przelewy_przychodzace WHERE uzytkownicy_id=?');

    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getPaysOut` (IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT * FROm przelewy_wychodzace WHERE uzytkownicy_id=?');

    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getPersonalData` (IN `id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT ulica,nr_domu,kod_pocztowy,miejscowosc,email,nr_telefonu FROM uzytkownicy WHERE identyfikator=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getTypeBills` ()  BEGIN
	SET @t1 = CONCAT('SELECT * FROM rachunki');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getUserByIdentyfikator` (IN `identyfikator` VARCHAR(12))  BEGIN
	SET @t1 = CONCAT('SELECT * FROM uzytkownicy WHERE identyfikator=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING identyfikator;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getUserByPesel` (IN `pesel` VARCHAR(12))  BEGIN
	SET @t1 = CONCAT('SELECT * FROM uzytkownicy WHERE pesel=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING pesel;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `getUser_Registration` (IN `pesel` VARCHAR(12))  BEGIN
	SET @t1 = CONCAT('SELECT id FROM uzytkownicy WHERE pesel=? LIMIT 1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING pesel;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertActivity` (IN `title` VARCHAR(128), IN `description` VARCHAR(1024), IN `user_id` INT)  BEGIN
	SET @t1 = "INSERT INTO uzytkownicy_aktywnosci VALUES(DEFAULT,?,?,NOW(),?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING title,description,user_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertDeposit` (IN `deposit_id` INT, IN `deposit_balance` INT, IN `deposit_time` INT, IN `user_id` INT)  BEGIN
    
	SET @t1 = "INSERT INTO uzytkownicy_lokaty VALUES(DEFAULT,?,NOW(),ADDDATE(NOW(),INTERVAL ? DAY),?,?,DEFAULT)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING deposit_balance,deposit_time,user_id,deposit_id;
    DEALLOCATE PREPARE stmt;
    
    SET @t2 = "UPDATE uzytkownicy_rachunki SET saldo=saldo- ? WHERE uzytkownicy_id=? AND rachunki_id=1";
    
    PREPARE stmt FROM @t2;
    EXECUTE stmt USING deposit_balance,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Utworzono nową lokatę',CONCAT('Utworzono nową lokatę na kwotę ', deposit_balance, ' PLN, na okres ',deposit_time,' dni'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertInTransfer` (IN `bill_sender` VARCHAR(16), IN `amount` FLOAT, IN `description` VARCHAR(128), IN `sender_user_id` INT, IN `receiver_bill_number` VARCHAR(16))  BEGIN
	SELECT id,saldo,uzytkownicy_id INTO @id_rachunku,@saldo_rachunku,@uzytkownicy_id FROM uzytkownicy_rachunki WHERE nr_rachunku=receiver_bill_number;
    
    SELECT imie,nazwisko INTO @user_imie,@user_nazwisko FROM uzytkownicy WHERE id=sender_user_id;
    

	SET @ins = "INSERT INTO przelewy_przychodzace VALUES(DEFAULT,?,?,?,?,?,NOW(),?,?)";

    PREPARE stmt FROM @ins;
    EXECUTE stmt USING bill_sender,CONCAT(@user_imie,' ',@user_nazwisko),amount,description, @saldo_rachunku+amount,@id_rachunku,@uzytkownicy_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Otrzymano przelew przychodzący',CONCAT('Otrzymano przelew od rachunku id ', bill_sender, ' na kwotę ',amount,' PLN.'),@uzytkownicy_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertNewAccount` (IN `identyfikator` VARCHAR(11), IN `pass` VARCHAR(64), IN `pesel` VARCHAR(11), IN `imie` VARCHAR(32), IN `nazwisko` VARCHAR(32), IN `rola` INT, IN `ulica` VARCHAR(32), IN `nr_domu` VARCHAR(8), IN `kod_pocztowy` VARCHAR(6), IN `miejscowosc` VARCHAR(32), IN `email` VARCHAR(64))  BEGIN
	SET @t1 = "INSERT INTO uzytkownicy VALUES(DEFAULT,?,?,?,?,?,?,?,?,?,?,DEFAULT,?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING identyfikator,pass,pesel,imie,nazwisko,rola,ulica,nr_domu,kod_pocztowy,miejscowosc,email;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertNewBill` (IN `user_id` INT, IN `employee_id` INT, IN `type_bill` INT, IN `bill_number` VARCHAR(16))  BEGIN
	SET @t1 = "INSERT INTO uzytkownicy_rachunki VALUES(DEFAULT,?,DEFAULT,NOW(),NULL,?,?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING bill_number,user_id,type_bill;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Stworzenie nowego rachunku bankowego',CONCAT('Utworzono nowy rachunek bankowy o id ',type_bill, ', numer rachunku: ',bill_number),employee_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertNewContact` (IN `bill_number` VARCHAR(16), IN `contact_desc` VARCHAR(64), IN `user_id` INT)  BEGIN
	SET @t1 = "INSERT INTO kontakty VALUES(DEFAULT,?,?,?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING contact_desc,bill_number,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Dodanie nowego kontaktu',CONCAT('Dodano nowy kontakt o numerze rachunku ', bill_number, ', opis kontaktu: ',contact_desc),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertNewDeposit` (IN `deposit_name` VARCHAR(128), IN `deposit_procent` FLOAT, IN `deposit_time` INT, IN `deposit_limit` INT, IN `user_id` INT)  BEGIN
	SET @t1 = "INSERT INTO lokaty VALUES(DEFAULT,?,?,?,?,1,1)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING deposit_name,deposit_procent,deposit_time, deposit_limit;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Dodanie nowej lokaty',CONCAT('Utworzono nową lokatę o nazwie ', deposit_name, ', oprocentowanie: ',deposit_procent),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertNewMessageToQuestion` (IN `message_question` VARCHAR(1024), IN `question_id` INT, IN `user_id` INT)  BEGIN
	SET @t1 = "INSERT INTO sprawa_wiadomosci VALUES(DEFAULT,?,NOW(),?,?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING message_question,question_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Dodano odpowiedź do pytania',CONCAT('Odpowiedź do pytania id ', question_id, ' !'),user_id);
    
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertOutTransfer` (IN `bill_receiver` VARCHAR(16), IN `data_receiver` VARCHAR(64), IN `amount` FLOAT, IN `description` VARCHAR(128), IN `balance_user_after` FLOAT, IN `user_bill_id` INT, IN `user_id` INT)  BEGIN
	SET @t1 = "INSERT INTO przelewy_wychodzace VALUES(DEFAULT,?,?,?,?,?,NOW(),?,?)";

    PREPARE stmt FROM @t1;
    EXECUTE stmt USING bill_receiver,data_receiver,amount,description,balance_user_after,user_bill_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Wykonano przelew wychodzący',CONCAT('Przelew zlecony na numer konta ', bill_receiver, ' na kwotę ',amount,' z rachunku id ',user_bill_id),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `insertQuestion` (IN `user_id` INT, IN `temat` VARCHAR(64), IN `wiadomosc` VARCHAR(1024))  BEGIN
	DECLARE id_sprawy INT;
	SET @t0 = "INSERT INTO sprawa VALUES(DEFAULT, ?, NOW(), NULL, ?)";

    PREPARE stmt0 FROM @t0;
    EXECUTE stmt0 USING temat, user_id;
    DEALLOCATE PREPARE stmt0;
    
    SELECT MAX(id) INTO id_sprawy FROM sprawa;
    
    SET @t1 = "INSERT INTO sprawa_wiadomosci VALUES(DEFAULT, ?, NOW(), ?, ?)";
    
    PREPARE stmt1 FROM @t1;
    EXECUTE stmt1 USING wiadomosc, id_sprawy, user_id;
    DEALLOCATE PREPARE stmt1;
    
    CALL insertActivity('Dodano nowe pytanie',CONCAT('Dodano pytanie o temacie', temat, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `logIn` (IN `login` VARCHAR(32), IN `haslo` VARCHAR(64), IN `rola_id` INT)  BEGIN
	SET @t1 = CONCAT('SELECT * FROM uzytkownicy WHERE identyfikator=? AND haslo=? AND role_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING login,haslo,rola_id;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateContactName` (IN `contact_id` INT, IN `contact_desc` VARCHAR(64), IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE kontakty SET nazwa=? WHERE id=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING contact_desc,contact_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Aktualizacja danych kontaktu',CONCAT('Zaktualizowano dane kontaktu o id ', contact_id, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateDepositEndTime` (IN `deposit_id` INT, IN `add_balance` DOUBLE, IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy_rachunki SET saldo=saldo + ? WHERE rachunki_id=1 AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING add_balance,user_id;
    DEALLOCATE PREPARE stmt;
    
    SET @t2 = CONCAT('UPDATE uzytkownicy_lokaty SET zakonczono=1 WHERE id=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t2;
    EXECUTE stmt USING deposit_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zakończenie lokaty - wypłata odsetek',CONCAT('Zakończono lokatę id ', deposit_id, ', uzyskano przychod w wysokosci ',add_balance, 'PLN'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateDepositsUser_Transfer` (IN `user_id` INT, IN `account_number` VARCHAR(16), IN `amount` FLOAT, IN `sender_account_number` VARCHAR(16))  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy_rachunki SET saldo=saldo-? WHERE uzytkownicy_id=? AND nr_rachunku=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING amount,user_id,sender_account_number;
    DEALLOCATE PREPARE stmt;
    
    SET @t2 = CONCAT('UPDATE uzytkownicy_rachunki SET saldo=saldo+? WHERE nr_rachunku=?');
    
    PREPARE stmt FROM @t2;
    EXECUTE stmt USING amount,account_number;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zaktualizowano saldo konta - przelew',CONCAT('Zaktualizowano saldo konta rachunku nr ', sender_account_number, ', zmniejszono o kwotę ', amount, 'PLN'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateDeposit_unActive` (IN `deposit_id` INT, IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE lokaty SET aktywna=0 WHERE id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING deposit_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Dezaktywacja lokaty',CONCAT('Zdezaktywowano lokatę id ',deposit_id, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateExchange` (IN `name` VARCHAR(128), IN `symbol` VARCHAR(16), IN `user_id` INT, IN `kurs_kupna` FLOAT, IN `kurs_sprzedazy` FLOAT)  BEGIN
	SELECT id INTO @id_waluty FROM waluty WHERE nazwa=name AND symbol=symbol;
    
    SET @t1 = CONCAT('UPDATE waluty_kursy SET kurs_kupna=?,kurs_sprzedazy=? WHERE waluty_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING kurs_kupna,kurs_sprzedazy,@id_waluty;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zedytowano cenę walut',CONCAT('Wprowadzono edycję cen kupna i sprzedaży waluty id ', @id_waluty, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updatelockAccountByEmployee` (IN `user_id` INT, IN `employee_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy SET role_id=3 WHERE id=? LIMIT 1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zablokowanie konta',CONCAT('Zablokowano konto o id ',user_id, ' !'),employee_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateLockBill` (IN `bill_id` INT, IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy_rachunki SET data_likwidacji=NOW() WHERE id=? AND uzytkownicy_id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING bill_id,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Likwidacja rachunku',CONCAT('Zlikwidowano rachunek o id ', bill_id, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updateLockQuestion` (IN `question_id` INT, IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE sprawa SET data_zakonczenia=NOW() WHERE id=?');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING question_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Zamknięcie pytania',CONCAT('Zamknięto pytanie o id ', question_id, ' !'),user_id);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` PROCEDURE `updatePersonalData` (IN `ulica` VARCHAR(32), IN `nr_domu` VARCHAR(8), IN `kod_pocztowy` VARCHAR(6), IN `miejscowosc` VARCHAR(32), IN `email` VARCHAR(64), IN `nr_telefonu` INT(9), IN `user_id` INT)  BEGIN
	SET @t1 = CONCAT('UPDATE uzytkownicy SET ulica=?,nr_domu=?,kod_pocztowy=?,miejscowosc=?,email=?,nr_telefonu=?  WHERE id=? LIMIT 1');
    
    PREPARE stmt FROM @t1;
    EXECUTE stmt USING ulica,nr_domu,kod_pocztowy,miejscowosc,email,nr_telefonu,user_id;
    DEALLOCATE PREPARE stmt;
    
    CALL insertActivity('Edycja danych personalnych','Zaktualizowano dane personalne.',user_id);
END$$

--
-- Funkcje
--
CREATE DEFINER=`db_71051`@`49.12.68.90` FUNCTION `getMainInfo` (`user_id` INT) RETURNS VARCHAR(128) CHARSET utf8mb4 BEGIN
	SELECT COUNT(id) INTO @ilosc_rachunkow FROM uzytkownicy_rachunki WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_lokat FROM uzytkownicy_lokaty WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_spraw FROM sprawa WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_aktywnosci FROM uzytkownicy_aktywnosci WHERE uzytkownicy_id=user_id;
    
    RETURN JSON_ARRAY(@ilosc_rachunkow,@ilosc_lokat,@ilosc_spraw,@ilosc_aktywnosci);
END$$

CREATE DEFINER=`db_71051`@`49.12.68.90` FUNCTION `getMainInfo_Employee` (`user_id` INT) RETURNS VARCHAR(128) CHARSET utf8mb4 BEGIN
	SELECT COUNT(id) INTO @ilosc_rachunkow FROM uzytkownicy_rachunki WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_lokat FROM uzytkownicy_lokaty WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_spraw FROM sprawa WHERE uzytkownicy_id=user_id;
    
    SELECT COUNT(id) INTO @ilosc_aktywnosci FROM uzytkownicy_aktywnosci WHERE uzytkownicy_id=user_id;
    
    SELECT imie,nazwisko,pesel,nr_telefonu,email,role_id INTO @imie,@nazwisko,@pesel,@tel,@email,@role_id FROM uzytkownicy WHERE id=user_id;
    
    RETURN JSON_ARRAY(@ilosc_rachunkow,@ilosc_lokat,@ilosc_spraw,@ilosc_aktywnosci, @imie,@nazwisko,@pesel,@tel,@email,@role_id);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kontakty`
--

CREATE TABLE `kontakty` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `uzytkownicy_rachunki_odbiorca` varchar(16) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `kontakty`
--

INSERT INTO `kontakty` (`id`, `nazwa`, `uzytkownicy_rachunki_odbiorca`, `uzytkownicy_id`) VALUES
(1, 'Mój dodatkowy rachunek bankowy', '1636889611467839', 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `lokaty`
--

CREATE TABLE `lokaty` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `oprocentowanie` float NOT NULL,
  `czas_trwania` int(11) NOT NULL COMMENT 'dni',
  `limit_kwoty` int(11) NOT NULL,
  `waluty_id` int(11) NOT NULL,
  `aktywna` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1-tak ; 0-nie'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `lokaty`
--

INSERT INTO `lokaty` (`id`, `nazwa`, `oprocentowanie`, `czas_trwania`, `limit_kwoty`, `waluty_id`, `aktywna`) VALUES
(1, 'Lokata dla początkujących', 1.55, 90, 30000, 1, 1),
(2, 'Lokata dla gości', 2.15, 30, 10000, 1, 1),
(3, 'Lokata długoterminowa', 1.25, 365, 75000, 1, 1),
(4, 'Lokata na przyszłość', 0.65, 720, 100000, 1, 1),
(5, 'Lokata standardowa', 0.01, 30, 1000000, 1, 1),
(6, 'Lokata dla nowicjuszy', 1.25, 60, 5000, 1, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przelewy_przychodzace`
--

CREATE TABLE `przelewy_przychodzace` (
  `id` int(11) NOT NULL,
  `rachunek_nadawcy` varchar(16) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `dane_nadawcy` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `kwota` float NOT NULL,
  `tytul` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `saldo_po_operacji` float NOT NULL,
  `data` datetime NOT NULL,
  `uzytkownicy_rachunki_id` int(11) NOT NULL COMMENT 'id_rachunku osoby otrzymującej przelew',
  `uzytkownicy_id` int(11) NOT NULL COMMENT '	id osoby otrzymującej przelew'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `przelewy_przychodzace`
--

INSERT INTO `przelewy_przychodzace` (`id`, `rachunek_nadawcy`, `dane_nadawcy`, `kwota`, `tytul`, `saldo_po_operacji`, `data`, `uzytkownicy_rachunki_id`, `uzytkownicy_id`) VALUES
(1, '8900440318406316', 'Janusz Omen', 15485, 'Przelew pomiędzy rachunkami własnymi', 30970, '2021-06-04 00:13:06', 2, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przelewy_wychodzace`
--

CREATE TABLE `przelewy_wychodzace` (
  `id` int(11) NOT NULL,
  `rachunek_odbiorcy` varchar(16) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `dane_adresata` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `kwota` float NOT NULL,
  `tytul` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `saldo_po_operacji` float NOT NULL,
  `data` datetime NOT NULL,
  `uzytkownicy_rachunki_id` int(11) NOT NULL COMMENT 'id_rachunku osoby zlecającej przelew',
  `uzytkownicy_id` int(11) NOT NULL COMMENT 'id osoby zlecającej przelew'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `przelewy_wychodzace`
--

INSERT INTO `przelewy_wychodzace` (`id`, `rachunek_odbiorcy`, `dane_adresata`, `kwota`, `tytul`, `saldo_po_operacji`, `data`, `uzytkownicy_rachunki_id`, `uzytkownicy_id`) VALUES
(1, '1636889611467839', 'Mój dodatkowy rachunek bankowy', 15485, 'Przelew pomiędzy rachunkami własnymi', 54515.5, '2021-06-04 00:13:06', 1, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rachunki`
--

CREATE TABLE `rachunki` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(128) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `waluty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `rachunki`
--

INSERT INTO `rachunki` (`id`, `nazwa`, `waluty_id`) VALUES
(1, 'Główny rachunek', 1),
(2, 'Dodatkowy rachunek', 1),
(3, 'Rachunek oszczędnościowy', 1),
(4, 'Rachunek na przyszłość', 1),
(5, 'Rachunek rodzinny', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `role`
--

INSERT INTO `role` (`id`, `nazwa`) VALUES
(1, 'klient'),
(2, 'pracownik'),
(3, 'zablokowany');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sprawa`
--

CREATE TABLE `sprawa` (
  `id` int(11) NOT NULL,
  `temat` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `data_otwarcia` datetime NOT NULL,
  `data_zakonczenia` datetime DEFAULT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `sprawa`
--

INSERT INTO `sprawa` (`id`, `temat`, `data_otwarcia`, `data_zakonczenia`, `uzytkownicy_id`) VALUES
(1, 'Posiadam problem z utworzeniem lokaty!', '2021-06-04 00:12:29', NULL, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sprawa_wiadomosci`
--

CREATE TABLE `sprawa_wiadomosci` (
  `id` int(11) NOT NULL,
  `wiadomosc` varchar(1024) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `data` datetime NOT NULL,
  `sprawa_id` int(11) NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `sprawa_wiadomosci`
--

INSERT INTO `sprawa_wiadomosci` (`id`, `wiadomosc`, `data`, `sprawa_id`, `uzytkownicy_id`) VALUES
(1, 'Witam, mam pewien problem.\nGdy próbuję wybrać lokatę do założenia, wyskakuje mi błąd - nie masz wystarczającej ilości środków na swoim koncie, aby przelać pieniądze na lokatę.\nW jaki sposób przelać pieniądze z dodatkowego rachunku na rachunek główny?', '2021-06-04 00:12:29', 1, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy`
--

CREATE TABLE `uzytkownicy` (
  `id` int(11) NOT NULL,
  `identyfikator` varchar(11) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `haslo` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `pesel` varchar(11) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `imie` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `nazwisko` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `role_id` int(11) NOT NULL DEFAULT 1,
  `ulica` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `nr_domu` varchar(8) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `kod_pocztowy` varchar(6) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `miejscowosc` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `nr_telefonu` int(9) DEFAULT NULL,
  `email` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `uzytkownicy`
--

INSERT INTO `uzytkownicy` (`id`, `identyfikator`, `haslo`, `pesel`, `imie`, `nazwisko`, `role_id`, `ulica`, `nr_domu`, `kod_pocztowy`, `miejscowosc`, `nr_telefonu`, `email`) VALUES
(1, '665570852', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', '00251704331', 'Janas', 'Krystian', 2, 'Krośnieńska', '27A/10', '38-400', 'Krosno', 123456789, 'kontakt@krystianjanas.pl'),
(2, '840358410', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', '99482451119', 'Janusz', 'Omen', 1, 'Chlebiańska', '289', '38-460', 'Jedlicze', 987654321, 'postofficenex@gmail.com');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy_aktywnosci`
--

CREATE TABLE `uzytkownicy_aktywnosci` (
  `id` int(11) NOT NULL,
  `tytul` varchar(64) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `opis` varchar(256) CHARACTER SET utf8 COLLATE utf8_polish_ci DEFAULT NULL,
  `data` datetime NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `uzytkownicy_aktywnosci`
--

INSERT INTO `uzytkownicy_aktywnosci` (`id`, `tytul`, `opis`, `data`, `uzytkownicy_id`) VALUES
(1, 'Stworzenie nowego rachunku bankowego', 'Utworzono nowy rachunek bankowy o id 1, numer rachunku: 8900440318406316', '2021-06-04 00:09:34', 1),
(2, 'Stworzenie nowego rachunku bankowego', 'Utworzono nowy rachunek bankowy o id 2, numer rachunku: 1636889611467839', '2021-06-04 00:09:38', 1),
(3, 'Dodanie nowego kontaktu', 'Dodano nowy kontakt o numerze rachunku 1636889611467839, opis kontaktu: Mój dodatkowy rachunek bankowy', '2021-06-04 00:10:43', 2),
(4, 'Utworzono nową lokatę', 'Utworzono nową lokatę na kwotę 10000 PLN, na okres 30 dni', '2021-06-04 00:10:56', 2),
(5, 'Utworzono nową lokatę', 'Utworzono nową lokatę na kwotę 5000 PLN, na okres 60 dni', '2021-06-04 00:11:03', 2),
(6, 'Dodano nowe pytanie', 'Dodano pytanie o temaciePosiadam problem z utworzeniem lokaty! !', '2021-06-04 00:12:29', 2),
(7, 'Zaktualizowano saldo konta - przelew', 'Zaktualizowano saldo konta rachunku nr 8900440318406316, zmniejszono o kwotę 15485PLN', '2021-06-04 00:13:06', 2),
(8, 'Wykonano przelew wychodzący', 'Przelew zlecony na numer konta 1636889611467839 na kwotę 15485 z rachunku id 1', '2021-06-04 00:13:06', 2),
(9, 'Otrzymano przelew przychodzący', 'Otrzymano przelew od rachunku id 8900440318406316 na kwotę 15485 PLN.', '2021-06-04 00:13:06', 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy_lokaty`
--

CREATE TABLE `uzytkownicy_lokaty` (
  `id` int(11) NOT NULL,
  `saldo` decimal(9,2) NOT NULL,
  `data_otwarcia` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `data_zakonczenia` datetime DEFAULT NULL,
  `uzytkownicy_id` int(11) NOT NULL,
  `lokaty_id` int(11) NOT NULL,
  `zakonczono` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `uzytkownicy_lokaty`
--

INSERT INTO `uzytkownicy_lokaty` (`id`, `saldo`, `data_otwarcia`, `data_zakonczenia`, `uzytkownicy_id`, `lokaty_id`, `zakonczono`) VALUES
(1, '10000.00', '2021-06-03 22:10:56', '2021-07-04 00:10:56', 2, 2, 0),
(2, '5000.00', '2021-06-03 22:11:27', '2021-06-04 04:00:00', 2, 6, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy_rachunki`
--

CREATE TABLE `uzytkownicy_rachunki` (
  `id` int(11) NOT NULL,
  `nr_rachunku` varchar(16) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `saldo` decimal(9,2) NOT NULL DEFAULT 0.00,
  `data_zalozenia` datetime NOT NULL,
  `data_likwidacji` datetime DEFAULT NULL,
  `uzytkownicy_id` int(11) NOT NULL,
  `rachunki_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `uzytkownicy_rachunki`
--

INSERT INTO `uzytkownicy_rachunki` (`id`, `nr_rachunku`, `saldo`, `data_zalozenia`, `data_likwidacji`, `uzytkownicy_id`, `rachunki_id`) VALUES
(1, '8900440318406316', '54515.55', '2021-06-04 00:09:34', NULL, 2, 1),
(2, '1636889611467839', '15485.00', '2021-06-04 00:09:38', NULL, 2, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `waluty`
--

CREATE TABLE `waluty` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(32) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `nazwa_skrot` varchar(8) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL,
  `symbol` char(4) CHARACTER SET utf8 COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `waluty`
--

INSERT INTO `waluty` (`id`, `nazwa`, `nazwa_skrot`, `symbol`) VALUES
(1, 'Polski złoty', 'PLN', 'zł'),
(2, 'Dolar amerykański', 'USD', '$'),
(3, 'Euro', 'EUR', 'E'),
(4, 'Forint', 'HUF', 'F');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `waluty_kursy`
--

CREATE TABLE `waluty_kursy` (
  `id` int(11) NOT NULL,
  `kurs_kupna` float NOT NULL,
  `kurs_sprzedazy` float NOT NULL,
  `data` date NOT NULL,
  `waluty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `waluty_kursy`
--

INSERT INTO `waluty_kursy` (`id`, `kurs_kupna`, `kurs_sprzedazy`, `data`, `waluty_id`) VALUES
(1, 1, 1, '2021-05-21', 1),
(2, 3.69, 3.79, '2021-05-21', 2),
(3, 4.5, 4.61, '2021-05-21', 3),
(4, 0.013, 0.015, '2021-05-21', 4);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownicy_rachunki_odbiorca` (`uzytkownicy_rachunki_odbiorca`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `lokaty`
--
ALTER TABLE `lokaty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `waluty_id` (`waluty_id`),
  ADD KEY `nazwa` (`nazwa`);

--
-- Indeksy dla tabeli `przelewy_przychodzace`
--
ALTER TABLE `przelewy_przychodzace`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`),
  ADD KEY `uzytkownicy_rachunki_id` (`uzytkownicy_rachunki_id`),
  ADD KEY `rachunek_nadawcy` (`rachunek_nadawcy`);

--
-- Indeksy dla tabeli `przelewy_wychodzace`
--
ALTER TABLE `przelewy_wychodzace`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rachunek_odbiorcy` (`rachunek_odbiorcy`),
  ADD KEY `uzytkownicy_rachunki_id` (`uzytkownicy_rachunki_id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  ADD PRIMARY KEY (`id`),
  ADD KEY `waluty_id` (`waluty_id`);

--
-- Indeksy dla tabeli `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_nazwa_unique` (`nazwa`) USING BTREE;

--
-- Indeksy dla tabeli `sprawa`
--
ALTER TABLE `sprawa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `sprawa_wiadomosci`
--
ALTER TABLE `sprawa_wiadomosci`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sprawa_id` (`sprawa_id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uzytkownicy_pesel_unique` (`pesel`),
  ADD UNIQUE KEY `identyfikator` (`identyfikator`),
  ADD KEY `role_id` (`role_id`);

--
-- Indeksy dla tabeli `uzytkownicy_aktywnosci`
--
ALTER TABLE `uzytkownicy_aktywnosci`
  ADD PRIMARY KEY (`id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `uzytkownicy_lokaty`
--
ALTER TABLE `uzytkownicy_lokaty`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lokaty_id` (`lokaty_id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uzytkownicy_rachunki_nr_rachunku_unique` (`nr_rachunku`),
  ADD KEY `rachunki_id` (`rachunki_id`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `waluty`
--
ALTER TABLE `waluty`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `waluty_nazwa_unique` (`nazwa`),
  ADD UNIQUE KEY `waluty_nazwa_skrot_unique` (`nazwa_skrot`),
  ADD UNIQUE KEY `waluty_symbol_unique` (`symbol`);

--
-- Indeksy dla tabeli `waluty_kursy`
--
ALTER TABLE `waluty_kursy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `waluty_id` (`waluty_id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `lokaty`
--
ALTER TABLE `lokaty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `przelewy_przychodzace`
--
ALTER TABLE `przelewy_przychodzace`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `przelewy_wychodzace`
--
ALTER TABLE `przelewy_wychodzace`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT dla tabeli `sprawa`
--
ALTER TABLE `sprawa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `sprawa_wiadomosci`
--
ALTER TABLE `sprawa_wiadomosci`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy_aktywnosci`
--
ALTER TABLE `uzytkownicy_aktywnosci`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy_lokaty`
--
ALTER TABLE `uzytkownicy_lokaty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `waluty`
--
ALTER TABLE `waluty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `waluty_kursy`
--
ALTER TABLE `waluty_kursy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  ADD CONSTRAINT `kontakty_ibfk_1` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`),
  ADD CONSTRAINT `kontakty_ibfk_2` FOREIGN KEY (`uzytkownicy_rachunki_odbiorca`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`);

--
-- Ograniczenia dla tabeli `lokaty`
--
ALTER TABLE `lokaty`
  ADD CONSTRAINT `lokaty_ibfk_1` FOREIGN KEY (`waluty_id`) REFERENCES `waluty` (`id`);

--
-- Ograniczenia dla tabeli `przelewy_przychodzace`
--
ALTER TABLE `przelewy_przychodzace`
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_1` FOREIGN KEY (`uzytkownicy_rachunki_id`) REFERENCES `uzytkownicy_rachunki` (`id`),
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_2` FOREIGN KEY (`rachunek_nadawcy`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`),
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_3` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `przelewy_wychodzace`
--
ALTER TABLE `przelewy_wychodzace`
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_1` FOREIGN KEY (`rachunek_odbiorcy`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`),
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_2` FOREIGN KEY (`uzytkownicy_rachunki_id`) REFERENCES `uzytkownicy_rachunki` (`id`),
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_3` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  ADD CONSTRAINT `rachunki_ibfk_1` FOREIGN KEY (`waluty_id`) REFERENCES `waluty` (`id`);

--
-- Ograniczenia dla tabeli `sprawa`
--
ALTER TABLE `sprawa`
  ADD CONSTRAINT `sprawa_ibfk_1` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `sprawa_wiadomosci`
--
ALTER TABLE `sprawa_wiadomosci`
  ADD CONSTRAINT `sprawa_wiadomosci_ibfk_1` FOREIGN KEY (`sprawa_id`) REFERENCES `sprawa` (`id`),
  ADD CONSTRAINT `sprawa_wiadomosci_ibfk_2` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  ADD CONSTRAINT `uzytkownicy_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy_aktywnosci`
--
ALTER TABLE `uzytkownicy_aktywnosci`
  ADD CONSTRAINT `uzytkownicy_aktywnosci_ibfk_1` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy_lokaty`
--
ALTER TABLE `uzytkownicy_lokaty`
  ADD CONSTRAINT `uzytkownicy_lokaty_ibfk_1` FOREIGN KEY (`lokaty_id`) REFERENCES `lokaty` (`id`),
  ADD CONSTRAINT `uzytkownicy_lokaty_ibfk_2` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  ADD CONSTRAINT `uzytkownicy_rachunki_ibfk_1` FOREIGN KEY (`rachunki_id`) REFERENCES `rachunki` (`id`),
  ADD CONSTRAINT `uzytkownicy_rachunki_ibfk_2` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`id`);

--
-- Ograniczenia dla tabeli `waluty_kursy`
--
ALTER TABLE `waluty_kursy`
  ADD CONSTRAINT `waluty_kursy_ibfk_1` FOREIGN KEY (`waluty_id`) REFERENCES `waluty` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
