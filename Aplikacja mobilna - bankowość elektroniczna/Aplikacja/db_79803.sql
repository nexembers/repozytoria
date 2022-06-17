-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 193.70.94.34:3306
-- Czas generowania: 31 Sty 2022, 16:53
-- Wersja serwera: 10.5.12-MariaDB-0+deb11u1
-- Wersja PHP: 7.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `db_79803`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `dzieci`
--

CREATE TABLE `dzieci` (
  `dbid` int(11) NOT NULL,
  `data` datetime NOT NULL DEFAULT current_timestamp(),
  `uzytkownicy_rodzic_id` int(11) NOT NULL,
  `uzytkownicy_dziecko_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `dzieci`
--

INSERT INTO `dzieci` (`dbid`, `data`, `uzytkownicy_rodzic_id`, `uzytkownicy_dziecko_id`) VALUES
(1, '2022-01-21 23:05:47', 2, 23),
(2, '2022-01-21 23:31:13', 2, 24),
(3, '2022-01-21 23:35:23', 2, 25),
(4, '2022-01-22 00:00:07', 26, 27),
(5, '2022-01-24 12:36:21', 2, 28),
(6, '2022-01-27 23:22:16', 29, 30),
(7, '2022-01-27 23:25:09', 29, 31),
(8, '2022-01-31 13:34:00', 33, 34);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kontakty`
--

CREATE TABLE `kontakty` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(64) COLLATE utf32_polish_ci NOT NULL,
  `uzytkownicy_rachunki_odbiorca` varchar(8) COLLATE utf32_polish_ci NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `kontakty`
--

INSERT INTO `kontakty` (`id`, `nazwa`, `uzytkownicy_rachunki_odbiorca`, `uzytkownicy_id`) VALUES
(5, 'Tadeusz Rydzyk', '27158849', 2),
(6, 'Ojciec', '52912709', 28),
(7, 'Dziecko 2', '47228653', 29),
(8, 'Dziecko 1', '68104328', 33);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przelewy_przychodzace`
--

CREATE TABLE `przelewy_przychodzace` (
  `id` int(11) NOT NULL,
  `rachunek_nadawcy` varchar(8) COLLATE utf32_polish_ci NOT NULL,
  `dane_nadawcy` varchar(128) COLLATE utf32_polish_ci NOT NULL,
  `kwota` decimal(9,2) NOT NULL,
  `tytul` varchar(128) COLLATE utf32_polish_ci DEFAULT NULL,
  `data` date NOT NULL DEFAULT current_timestamp(),
  `uzytkownicy_rachunki_id` int(11) NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `przelewy_przychodzace`
--

INSERT INTO `przelewy_przychodzace` (`id`, `rachunek_nadawcy`, `dane_nadawcy`, `kwota`, `tytul`, `data`, `uzytkownicy_rachunki_id`, `uzytkownicy_id`) VALUES
(1, '52912709', 'Jakub Skawinski', '100.00', 'adresowany na cicha zwrot kaucji', '2022-01-22', 10, 25),
(2, '52912709', 'Jakub Skawinski', '125.00', 'Zwracam Ci hajs 125pln', '2022-01-22', 10, 25),
(3, '52912709', 'Tadeusz Rydzyk', '50.00', 'testowy przlew', '2022-01-24', 14, 28),
(4, '27158849', 'Ojciec', '50.00', 'przelew zwrotny', '2022-01-27', 3, 2),
(6, '27158849', 'Ojciec', '83.28', 'testowy przelew jakis tam', '2022-01-27', 3, 2),
(7, '52912709', 'Tadeusz Rydzyk', '250.00', 'kieszonkowe dzienne w wysokosci 250zl i to podziel sie z siostra', '2022-01-27', 14, 28),
(8, '25675815', 'Dziecko 2', '150.00', 'testowy przelew dla dziecka 2', '2022-01-27', 20, 31),
(9, '25675815', 'Dziecko 2', '47.58', 'testtest2', '2022-01-27', 20, 31),
(10, '69934095', 'Dziecko 1', '25.00', 'kieszonkowe', '2022-01-31', 24, 34),
(11, '69934095', 'Do: Dziecko 1', '5.00', 'fsdfsdffsd', '2022-01-31', 24, 34),
(12, '68104328', 'Od: Krystian Janas', '20.00', 'przelew zwrotny', '2022-01-31', 23, 33);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `przelewy_wychodzace`
--

CREATE TABLE `przelewy_wychodzace` (
  `id` int(11) NOT NULL,
  `rachunek_odbiorcy` varchar(8) COLLATE utf32_polish_ci NOT NULL,
  `dane_adresata` varchar(128) COLLATE utf32_polish_ci NOT NULL,
  `kwota` decimal(9,2) NOT NULL,
  `tytul` varchar(128) COLLATE utf32_polish_ci DEFAULT NULL,
  `data` date NOT NULL DEFAULT current_timestamp(),
  `uzytkownicy_rachunki_id` int(11) NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `przelewy_wychodzace`
--

INSERT INTO `przelewy_wychodzace` (`id`, `rachunek_odbiorcy`, `dane_adresata`, `kwota`, `tytul`, `data`, `uzytkownicy_rachunki_id`, `uzytkownicy_id`) VALUES
(4, '84751014', 'Jakub Skawinski', '100.00', 'adresowany na cicha zwrot kaucji', '2022-01-22', 10, 2),
(5, '84751014', 'Jakub Skawinski', '125.00', 'Zwracam Ci hajs 125pln', '2022-01-22', 10, 2),
(6, '27158849', 'Tadeusz Rydzyk', '50.00', 'testowy przlew', '2022-01-24', 14, 2),
(7, '52912709', 'Ojciec', '50.00', 'przelew zwrotny', '2022-01-24', 3, 28),
(8, '52912709', 'Ojciec', '83.28', 'testowy przelew jakis tam', '2022-01-27', 3, 28),
(9, '27158849', 'Tadeusz Rydzyk', '250.00', 'kieszonkowe dzienne w wysokosci 250zl i to podziel sie z siostra', '2022-01-27', 14, 2),
(10, '47228653', 'Dziecko 2', '150.00', 'testowy przelew dla dziecka 2', '2022-01-27', 20, 29),
(11, '47228653', 'Dziecko 2', '47.58', 'testtest2', '2022-01-27', 20, 29),
(12, '68104328', 'Dziecko 1', '25.00', 'kieszonkowe', '2022-01-31', 24, 33),
(13, '68104328', 'Do: Dziecko 1', '5.00', 'fsdfsdffsd', '2022-01-31', 24, 33),
(14, '69934095', 'Od: Krystian Janas', '20.00', 'przelew zwrotny', '2022-01-31', 23, 34);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `rachunki`
--

CREATE TABLE `rachunki` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(128) COLLATE utf32_polish_ci NOT NULL,
  `waluty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `rachunki`
--

INSERT INTO `rachunki` (`id`, `nazwa`, `waluty_id`) VALUES
(1, 'Rachunek główny', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `role`
--

CREATE TABLE `role` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(32) COLLATE utf32_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `role`
--

INSERT INTO `role` (`id`, `nazwa`) VALUES
(1, 'Dziecko'),
(2, 'Rodzic');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy`
--

CREATE TABLE `uzytkownicy` (
  `dbid` int(11) NOT NULL,
  `identyfikator` varchar(11) COLLATE utf32_polish_ci NOT NULL COMMENT 'pesel',
  `data` timestamp NOT NULL DEFAULT current_timestamp(),
  `haslo` varchar(128) COLLATE utf32_polish_ci NOT NULL,
  `imie` varchar(32) COLLATE utf32_polish_ci DEFAULT NULL,
  `nazwisko` varchar(32) COLLATE utf32_polish_ci DEFAULT NULL,
  `adres` varchar(128) COLLATE utf32_polish_ci DEFAULT NULL,
  `telefon` varchar(12) COLLATE utf32_polish_ci DEFAULT NULL,
  `email` varchar(64) COLLATE utf32_polish_ci DEFAULT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `uzytkownicy`
--

INSERT INTO `uzytkownicy` (`dbid`, `identyfikator`, `data`, `haslo`, `imie`, `nazwisko`, `adres`, `telefon`, `email`, `role_id`) VALUES
(2, '1234', '2022-01-20 20:34:53', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', 'Krystian', 'Janas', 'Adres zamieszkania', '602422853', 'kontakt@krystianjanas.pl', 2),
(5, '12345', '2022-01-21 14:26:48', '12345', NULL, NULL, NULL, NULL, NULL, 2),
(6, '532525', '2022-01-21 14:26:52', '23525', NULL, NULL, NULL, NULL, NULL, 2),
(7, '4141', '2022-01-21 14:27:47', '31233', NULL, NULL, NULL, NULL, NULL, 2),
(8, '41414', '2022-01-21 14:28:08', '123456', NULL, NULL, NULL, NULL, NULL, 2),
(9, '414141', '2022-01-21 14:28:33', '444888', NULL, NULL, NULL, NULL, NULL, 2),
(10, '52352', '2022-01-21 14:33:50', '52542542', NULL, NULL, NULL, NULL, NULL, 2),
(11, '25425', '2022-01-21 14:34:55', '5425425', NULL, NULL, NULL, NULL, NULL, 2),
(12, '525245', '2022-01-21 14:35:28', '54252524', NULL, NULL, NULL, NULL, NULL, 2),
(13, '142412', '2022-01-21 14:36:52', '134312', NULL, NULL, NULL, NULL, NULL, 2),
(14, '425452', '2022-01-21 14:37:10', '2442', NULL, NULL, NULL, NULL, NULL, 2),
(15, '52525', '2022-01-21 14:41:12', '52525454', NULL, NULL, NULL, NULL, NULL, 2),
(16, '123456', '2022-01-21 14:55:44', '12345', NULL, NULL, NULL, NULL, NULL, 2),
(17, '532523', '2022-01-21 14:57:16', '11', NULL, NULL, NULL, NULL, NULL, 2),
(18, '111222', '2022-01-21 16:05:57', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 2),
(19, '1112222', '2022-01-21 16:07:24', '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4', NULL, NULL, NULL, NULL, NULL, 2),
(20, '1234888', '2022-01-21 16:53:54', '94edf28c6d6da38fd35d7ad53e485307f89fbeaf120485c8d17a43f323deee71', NULL, NULL, NULL, NULL, NULL, 2),
(21, '00251704332', '2022-01-21 22:03:11', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 1),
(22, '00251704333', '2022-01-21 22:04:42', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 1),
(23, '00251704334', '2022-01-21 22:05:47', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 1),
(24, '00251704338', '2022-01-21 22:31:13', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 1),
(25, '00251704339', '2022-01-21 22:35:23', 'e0f02bb13c5c4a3c07cd168028193e27a40f7c95dbc64ba4d56d0945ea51422d', NULL, NULL, NULL, NULL, NULL, 1),
(26, '00251704330', '2022-01-21 22:58:35', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Adam', 'janas', 'Adres cicha', NULL, NULL, 2),
(27, '00251704345', '2022-01-21 23:00:06', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', NULL, NULL, NULL, NULL, NULL, 1),
(28, '00251760600', '2022-01-24 11:36:21', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Tadek', 'Rydzyk', 'Adres zamieszkania', NULL, NULL, 1),
(29, '70122106450', '2022-01-27 22:06:34', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', 'Artur', 'Rydzyk', 'Adres Cicha 4', NULL, NULL, 2),
(30, '70122106451', '2022-01-27 22:22:16', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', NULL, NULL, NULL, NULL, NULL, 1),
(31, '70122106452', '2022-01-27 22:25:09', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', 'Imię', 'Nazwisko', 'Adres zamieszkania', NULL, NULL, 1),
(32, '70122106459', '2022-01-27 22:46:54', '35ad3e2325742d7ee465f53c3ab88b5b1f023f75cfe7a287edf84354a9d79bd4', 'Adam', 'Wkladam', 'Uciekam i Spadam', NULL, NULL, 2),
(33, '54021525142', '2022-01-31 12:31:12', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', 'Krystian', 'Janas', 'Cicha akademik', NULL, NULL, 2),
(34, '54021525144', '2022-01-31 12:34:00', '6b7b1c0ec61d54ccca4fb603aab068fa90894ace9390eac24fac1d07264dc39e', 'Tadeusz', 'Rydzyk', 'testete', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy_rachunki`
--

CREATE TABLE `uzytkownicy_rachunki` (
  `id` int(11) NOT NULL,
  `nr_rachunku` varchar(8) COLLATE utf32_polish_ci NOT NULL,
  `data` datetime NOT NULL DEFAULT current_timestamp() COMMENT 'założenie rachunku',
  `saldo` decimal(9,2) NOT NULL DEFAULT 0.00,
  `uzytkownicy_id` int(11) NOT NULL,
  `rachunki_id` int(11) NOT NULL DEFAULT 1,
  `limit_przelewu` int(11) NOT NULL DEFAULT 500
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `uzytkownicy_rachunki`
--

INSERT INTO `uzytkownicy_rachunki` (`id`, `nr_rachunku`, `data`, `saldo`, `uzytkownicy_id`, `rachunki_id`, `limit_przelewu`) VALUES
(3, '52912709', '2022-01-21 16:22:48', '2108.28', 2, 1, 500),
(5, '52912703', '2022-01-21 16:22:48', '0.00', 11, 1, 500),
(6, '16177059', '2022-01-21 17:06:18', '0.00', 18, 1, 500),
(9, '20724623', '2022-01-21 23:31:13', '0.00', 24, 1, 500),
(10, '84751014', '2022-01-21 23:35:23', '770.00', 25, 1, 500),
(11, '64655252', '2022-01-21 23:58:46', '1000.00', 26, 1, 850),
(12, '60926850', '2022-01-22 00:00:07', '0.00', 27, 1, 500),
(14, '27158849', '2022-01-24 12:36:21', '317.72', 28, 1, 150),
(17, '25675815', '2022-01-27 23:10:47', '802.42', 29, 1, 1580),
(19, '27004334', '2022-01-27 23:22:16', '0.00', 30, 1, 500),
(20, '47228653', '2022-01-27 23:25:09', '197.58', 31, 1, 500),
(22, '72121377', '2022-01-27 23:47:06', '1000.00', 32, 1, 500),
(23, '69934095', '2022-01-31 13:31:43', '990.00', 33, 1, 100),
(24, '68104328', '2022-01-31 13:34:00', '10.00', 34, 1, 20);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `uzytkownicy_srodki`
--

CREATE TABLE `uzytkownicy_srodki` (
  `dbid` int(11) NOT NULL,
  `data` datetime NOT NULL,
  `uzytkownicy_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `uzytkownicy_srodki`
--

INSERT INTO `uzytkownicy_srodki` (`dbid`, `data`, `uzytkownicy_id`) VALUES
(1, '2022-01-20 00:00:00', 2),
(2, '2022-01-21 00:00:00', 2),
(3, '2022-01-21 00:00:00', 26),
(4, '2022-01-22 00:00:00', 2),
(5, '2022-01-24 00:00:00', 2),
(6, '2022-01-27 00:00:00', 29),
(7, '2022-01-27 00:00:00', 32),
(8, '2022-01-31 00:00:00', 33);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `waluty`
--

CREATE TABLE `waluty` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(32) COLLATE utf32_polish_ci NOT NULL,
  `skrot` varchar(8) COLLATE utf32_polish_ci NOT NULL,
  `symbol` char(4) COLLATE utf32_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_polish_ci;

--
-- Zrzut danych tabeli `waluty`
--

INSERT INTO `waluty` (`id`, `nazwa`, `skrot`, `symbol`) VALUES
(1, 'Polski Złoty', 'PLN', 'zł');

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `dzieci`
--
ALTER TABLE `dzieci`
  ADD PRIMARY KEY (`dbid`),
  ADD KEY `uzytkownicy_dziecko_id` (`uzytkownicy_dziecko_id`),
  ADD KEY `uzytkownicy_rodzic_id` (`uzytkownicy_rodzic_id`);

--
-- Indeksy dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uzytkownicy_rachunki_odbiorca` (`uzytkownicy_rachunki_odbiorca`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`) USING BTREE;

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
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`),
  ADD KEY `uzytkownicy_rachunki_id` (`uzytkownicy_rachunki_id`),
  ADD KEY `rachunek_odbiorcy` (`rachunek_odbiorcy`);

--
-- Indeksy dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `waluty_id` (`waluty_id`);

--
-- Indeksy dla tabeli `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  ADD PRIMARY KEY (`dbid`),
  ADD KEY `role_id` (`role_id`) USING BTREE;

--
-- Indeksy dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nr_rachunku` (`nr_rachunku`) USING BTREE,
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`) USING BTREE,
  ADD KEY `rachunki_id` (`rachunki_id`) USING BTREE;

--
-- Indeksy dla tabeli `uzytkownicy_srodki`
--
ALTER TABLE `uzytkownicy_srodki`
  ADD PRIMARY KEY (`dbid`),
  ADD KEY `uzytkownicy_id` (`uzytkownicy_id`);

--
-- Indeksy dla tabeli `waluty`
--
ALTER TABLE `waluty`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `dzieci`
--
ALTER TABLE `dzieci`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `przelewy_przychodzace`
--
ALTER TABLE `przelewy_przychodzace`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `przelewy_wychodzace`
--
ALTER TABLE `przelewy_wychodzace`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `role`
--
ALTER TABLE `role`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT dla tabeli `uzytkownicy_srodki`
--
ALTER TABLE `uzytkownicy_srodki`
  MODIFY `dbid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `waluty`
--
ALTER TABLE `waluty`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `dzieci`
--
ALTER TABLE `dzieci`
  ADD CONSTRAINT `dzieci_ibfk_1` FOREIGN KEY (`uzytkownicy_rodzic_id`) REFERENCES `uzytkownicy` (`dbid`),
  ADD CONSTRAINT `dzieci_ibfk_2` FOREIGN KEY (`uzytkownicy_dziecko_id`) REFERENCES `uzytkownicy` (`dbid`);

--
-- Ograniczenia dla tabeli `kontakty`
--
ALTER TABLE `kontakty`
  ADD CONSTRAINT `kontakty_ibfk_1` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`dbid`),
  ADD CONSTRAINT `kontakty_ibfk_2` FOREIGN KEY (`uzytkownicy_rachunki_odbiorca`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`);

--
-- Ograniczenia dla tabeli `przelewy_przychodzace`
--
ALTER TABLE `przelewy_przychodzace`
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_1` FOREIGN KEY (`rachunek_nadawcy`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`),
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_2` FOREIGN KEY (`uzytkownicy_rachunki_id`) REFERENCES `uzytkownicy_rachunki` (`id`),
  ADD CONSTRAINT `przelewy_przychodzace_ibfk_3` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`dbid`);

--
-- Ograniczenia dla tabeli `przelewy_wychodzace`
--
ALTER TABLE `przelewy_wychodzace`
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_1` FOREIGN KEY (`rachunek_odbiorcy`) REFERENCES `uzytkownicy_rachunki` (`nr_rachunku`),
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_2` FOREIGN KEY (`uzytkownicy_rachunki_id`) REFERENCES `uzytkownicy_rachunki` (`id`),
  ADD CONSTRAINT `przelewy_wychodzace_ibfk_3` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`dbid`);

--
-- Ograniczenia dla tabeli `rachunki`
--
ALTER TABLE `rachunki`
  ADD CONSTRAINT `rachunki_ibfk_1` FOREIGN KEY (`waluty_id`) REFERENCES `waluty` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy`
--
ALTER TABLE `uzytkownicy`
  ADD CONSTRAINT `uzytkownicy_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);

--
-- Ograniczenia dla tabeli `uzytkownicy_rachunki`
--
ALTER TABLE `uzytkownicy_rachunki`
  ADD CONSTRAINT `uzytkownicy_rachunki_ibfk_2` FOREIGN KEY (`rachunki_id`) REFERENCES `rachunki` (`id`),
  ADD CONSTRAINT `uzytkownicy_rachunki_ibfk_3` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`dbid`);

--
-- Ograniczenia dla tabeli `uzytkownicy_srodki`
--
ALTER TABLE `uzytkownicy_srodki`
  ADD CONSTRAINT `uzytkownicy_srodki_ibfk_1` FOREIGN KEY (`uzytkownicy_id`) REFERENCES `uzytkownicy` (`dbid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
