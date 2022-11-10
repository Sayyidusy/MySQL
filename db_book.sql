-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2021 at 11:39 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_book`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `Discount10` ()  BEGIN
	DECLARE finished INT DEFAULT 0;
	DECLARE bookName VARCHAR(255) DEFAULT ""; 
	DECLARE oldPrice INT DEFAULT 0; 
	DECLARE newPrice INT DEFAULT 0; 
	
	-- Declare CURSOR
	DECLARE curPrice
		CURSOR FOR
			SELECT b.book_name , b.book_price ,b.book_price * 0.9
			FROM bookinfo.book_mast b;
		
	-- declare HANDLER
	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finished =1;
	
	-- Open Cursor
	OPEN curPrice;

	-- fetch cursor
	getPrice: LOOP
		FETCH curPrice INTO bookName, oldPrice, newPrice;
		-- SELECT bookName, oldPrice, newPrice;
		INSERT INTO bookinfo.new_book VALUES (bookName, oldPrice, newPrice);
		IF finished =1 THEN
			LEAVE getPrice;
		END IF;
	END LOOP getPrice;
		
	-- close Cursor
	CLOSE curPrice;
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `MostExpensive` ()  BEGIN
	SELECT b.book_name, b.book_price, c.cate_descrip 
	FROM book_mast b , category c 
	WHERE b.cate_id = c.cate_id 
	ORDER BY book_price DESC 
	LIMIT 0,3;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `BookTypeByPages` (`pages` INT) RETURNS VARCHAR(255) CHARSET utf8 BEGIN
	DECLARE booktype VARCHAR(255);
	SET booktype = "";

	IF (pages < 200) THEN
		SET booktype = "TIPIS";
	ELSEIF (pages < 400) THEN
		SET booktype = "NORMAL";
	ELSE
		SET booktype = "TEBAL";
	END IF;

	RETURN(booktype);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `author`
--

CREATE TABLE `author` (
  `aut_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `aut_name` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `country` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `home_city` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `author`
--

INSERT INTO `author` (`aut_id`, `aut_name`, `country`, `home_city`) VALUES
('AUT001', 'William Norton', 'UK', 'Cambridge'),
('AUT002', 'William Maugham', 'Canada', 'Toronto'),
('AUT003', 'William Anthony', 'UK', 'Leeds'),
('AUT004', 'S.B.Swaminathan', 'India', 'Bangalore'),
('AUT005', 'Thomas Morgan', 'Germany', 'Arnsberg'),
('AUT006', 'Thomas Merton', 'USA', 'New York'),
('AUT007', 'Piers Gibson', 'UK', 'London'),
('AUT008', 'Nikolai Dewey', 'USA', 'Atlanta'),
('AUT009', 'Marquis de Ellis', 'Brazil', 'Rio De Janerio'),
('AUT010', 'Joseph Milton', 'USA', 'Houston'),
('AUT011', 'John Betjeman Hunter', 'Australia', 'Sydney'),
('AUT012', 'Evan Hayek', 'Canada', 'Vancouver'),
('AUT013', 'E. Howard', 'Australia', 'Adelaide'),
('AUT014', 'C. J. Wilde', 'UK', 'London'),
('AUT015', 'Butler Andre', 'USA', 'Florida');

-- --------------------------------------------------------

--
-- Table structure for table `book_mast`
--

CREATE TABLE `book_mast` (
  `book_id` varchar(15) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `book_name` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `isbn_no` varchar(15) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `cate_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `aut_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `pub_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `dt_of_pub` date NOT NULL,
  `pub_lang` varchar(15) COLLATE latin1_general_ci DEFAULT NULL,
  `no_page` decimal(5,0) NOT NULL DEFAULT 0,
  `book_price` decimal(8,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `book_mast`
--

INSERT INTO `book_mast` (`book_id`, `book_name`, `isbn_no`, `cate_id`, `aut_id`, `pub_id`, `dt_of_pub`, `pub_lang`, `no_page`, `book_price`) VALUES
('BK001', 'Introduction to Electrodynamics', '0000979001', 'CA001', 'AUT001', 'P003', '2001-05-08', 'English', '201', '85.00'),
('BK002', 'Understanding of Steel Construction', '0000979002', 'CA002', 'AUT002', 'P001', '2003-07-15', 'English', '300', '105.50'),
('BK003', 'Guide to Networking', '0000979003', 'CA003', 'AUT003', 'P002', '2002-09-10', 'Hindi', '510', '200.00'),
('BK004', 'Transfer  of Heat and Mass', '0000979004', 'CA002', 'AUT004', 'P004', '2004-02-16', 'English', '600', '250.00'),
('BK005', 'Conceptual Physics', '0000979005', 'CA001', 'AUT005', 'P006', '2003-07-16', NULL, '345', '145.00'),
('BK006', 'Fundamentals of Heat', '0000979006', 'CA001', 'AUT006', 'P005', '2003-08-10', 'German', '247', '112.00'),
('BK007', 'Advanced 3d Graphics', '0000979007', 'CA003', 'AUT007', 'P002', '2004-02-16', 'Hindi', '165', '56.00'),
('BK008', 'Human Anatomy', '0000979008', 'CA005', 'AUT008', 'P006', '2001-05-17', 'German', '88', '50.50'),
('BK009', 'Mental Health Nursing', '0000979009', 'CA005', 'AUT009', 'P007', '2004-02-10', 'English', '350', '145.00'),
('BK010', 'Fundamentals of Thermodynamics', '0000979010', 'CA002', 'AUT010', 'P007', '2002-10-14', 'English', '400', '225.00'),
('BK011', 'The Experimental Analysis of Cat', '0000979011', 'CA004', 'AUT011', 'P005', '2007-06-09', 'French', '225', '95.00'),
('BK012', 'The Nature  of World', '0000979012', 'CA004', 'AUT005', 'P008', '2005-12-20', 'English', '350', '88.00'),
('BK013', 'Environment a Sustainable Future', '0000979013', 'CA004', 'AUT012', 'P001', '2003-10-27', 'German', '165', '100.00'),
('BK014', 'Concepts in Health', '0000979014', 'CA005', 'AUT013', 'P004', '2001-08-25', NULL, '320', '180.00'),
('BK015', 'Anatomy & Physiology', '0000979015', 'CA005', 'AUT014', 'P008', '2000-10-10', 'Hindi', '225', '135.00'),
('BK016', 'Networks and Telecommunications', '00009790_16', 'CA003', 'AUT015', 'P003', '2002-01-01', 'French', '95', '45.00');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `cate_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `cate_descrip` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`cate_id`, `cate_descrip`) VALUES
('CA001', 'Science'),
('CA002', 'Technology'),
('CA003', 'Computers'),
('CA004', 'Nature'),
('CA005', 'Medical');

-- --------------------------------------------------------

--
-- Table structure for table `publisher`
--

CREATE TABLE `publisher` (
  `pub_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `pub_name` varchar(50) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `pub_city` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `country` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `country_office` varchar(25) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `no_of_branch` int(11) NOT NULL DEFAULT 0,
  `estd` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `publisher`
--

INSERT INTO `publisher` (`pub_id`, `pub_name`, `pub_city`, `country`, `country_office`, `no_of_branch`, `estd`) VALUES
('P001', 'Jex Max Publication', 'New York', 'USA', 'New York', 15, '1969-12-25'),
('P002', 'BPP Publication', 'Mumbai', 'India', 'New Delhi', 10, '1985-10-01'),
('P003', 'New Harrold Publication', 'Adelaide', 'Australia', 'Sydney', 6, '1975-09-05'),
('P004', 'Ultra Press Inc.', 'London', 'UK', 'London', 8, '1948-07-10'),
('P005', 'Mountain Publication', 'Houstan', 'USA', 'Sun Diego', 25, '1975-01-01'),
('P006', 'Summer Night Publication', 'New York', 'USA', 'Atlanta', 10, '1990-12-10'),
('P007', 'Pieterson Grp. of Publishers', 'Cambridge', 'UK', 'London', 6, '1950-07-15'),
('P008', 'Novel Publisher Ltd.', 'New Delhi', 'India', 'Bangalore', 10, '2000-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `purchase`
--

CREATE TABLE `purchase` (
  `invoice_no` varchar(12) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `invoice_dt` date NOT NULL,
  `ord_no` varchar(25) COLLATE latin1_general_ci NOT NULL,
  `ord_date` date NOT NULL,
  `receive_dt` date NOT NULL,
  `book_id` varchar(8) COLLATE latin1_general_ci NOT NULL DEFAULT '',
  `receive_qty` int(11) NOT NULL DEFAULT 0,
  `purch_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_cost` decimal(12,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `purchase`
--

INSERT INTO `purchase` (`invoice_no`, `invoice_dt`, `ord_no`, `ord_date`, `receive_dt`, `book_id`, `receive_qty`, `purch_price`, `total_cost`) VALUES
('INV0001', '2008-07-15', 'ORD/08-09/0001', '2008-07-06', '2008-07-19', 'BK001', 15, '75.00', '1125.00'),
('INV0002', '2008-08-25', 'ORD/08-09/0002', '2008-08-09', '2008-08-28', 'BK004', 8, '55.00', '440.00'),
('INV0003', '2008-09-20', 'ORD/08-09/0003', '2008-09-15', '2008-09-23', 'BK005', 20, '20.00', '400.00'),
('INV0004', '2007-08-30', 'ORD/07-08/0005', '2007-08-22', '2007-08-30', 'BK004', 15, '35.00', '525.00'),
('INV0005', '2007-07-28', 'ORD/07-08/0004', '2007-06-25', '2007-07-30', 'BK001', 8, '25.00', '200.00'),
('INV0006', '2007-09-24', 'ORD/07-08/0007', '2007-09-20', '2007-09-30', 'BK003', 20, '45.00', '900.00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `author`
--
ALTER TABLE `author`
  ADD PRIMARY KEY (`aut_id`);

--
-- Indexes for table `book_mast`
--
ALTER TABLE `book_mast`
  ADD PRIMARY KEY (`book_id`),
  ADD KEY `book_mast_FK` (`aut_id`),
  ADD KEY `book_mast_FK_2` (`cate_id`),
  ADD KEY `book_mast_FK_3` (`pub_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`cate_id`);

--
-- Indexes for table `publisher`
--
ALTER TABLE `publisher`
  ADD PRIMARY KEY (`pub_id`);

--
-- Indexes for table `purchase`
--
ALTER TABLE `purchase`
  ADD PRIMARY KEY (`invoice_no`),
  ADD KEY `purchase_FK` (`book_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `book_mast`
--
ALTER TABLE `book_mast`
  ADD CONSTRAINT `book_mast_FK` FOREIGN KEY (`aut_id`) REFERENCES `author` (`aut_id`),
  ADD CONSTRAINT `book_mast_FK_1` FOREIGN KEY (`cate_id`) REFERENCES `category` (`cate_id`),
  ADD CONSTRAINT `book_mast_FK_3` FOREIGN KEY (`pub_id`) REFERENCES `publisher` (`pub_id`);

--
-- Constraints for table `purchase`
--
ALTER TABLE `purchase`
  ADD CONSTRAINT `purchase_FK` FOREIGN KEY (`book_id`) REFERENCES `book_mast` (`book_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
