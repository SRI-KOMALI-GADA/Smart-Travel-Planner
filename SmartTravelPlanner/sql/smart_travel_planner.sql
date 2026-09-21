CREATE DATABASE IF NOT EXISTS smart_travel_planner
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;
USE smart_travel_planner;

SET FOREIGN_KEY_CHECKS = 0;
DROP VIEW IF EXISTS vw_trip_budget_summary;
DROP VIEW IF EXISTS vw_monthly_expense_summary;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS checklist;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS destinations;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
	user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	full_name VARCHAR(120) NOT NULL,
	email VARCHAR(190) NOT NULL,
	password_hash VARCHAR(255) NOT NULL,
	role ENUM('traveler', 'admin') NOT NULL DEFAULT 'traveler',
	travel_preference VARCHAR(60) NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (user_id),
	UNIQUE KEY uq_users_email (email),
	KEY idx_users_role (role)
) ENGINE=InnoDB;

CREATE TABLE destinations (
	destination_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	city VARCHAR(100) NOT NULL,
	country VARCHAR(100) NOT NULL,
	country_code CHAR(2) NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (destination_id),
	UNIQUE KEY uq_destinations_city_country (city, country),
	KEY idx_destinations_country (country)
) ENGINE=InnoDB;

CREATE TABLE trips (
	trip_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id BIGINT UNSIGNED NOT NULL,
	destination_id BIGINT UNSIGNED NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	budget DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
	hotel_name VARCHAR(180) NULL,
	transportation VARCHAR(120) NULL,
	notes TEXT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (trip_id),
	CONSTRAINT fk_trips_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
	CONSTRAINT fk_trips_destination FOREIGN KEY (destination_id) REFERENCES destinations (destination_id),
	CONSTRAINT chk_trips_dates CHECK (end_date >= start_date),
	CONSTRAINT chk_trips_budget CHECK (budget >= 0),
	KEY idx_trips_user_dates (user_id, start_date, end_date),
	KEY idx_trips_destination (destination_id)
) ENGINE=InnoDB;

CREATE TABLE expenses (
	expense_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	trip_id BIGINT UNSIGNED NOT NULL,
	title VARCHAR(160) NOT NULL,
	amount DECIMAL(12, 2) NOT NULL,
	category ENUM('Accommodation', 'Transportation', 'Food', 'Activities', 'Other') NOT NULL DEFAULT 'Other',
	expense_date DATE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (expense_id),
	CONSTRAINT fk_expenses_trip FOREIGN KEY (trip_id) REFERENCES trips (trip_id) ON DELETE CASCADE,
	CONSTRAINT chk_expenses_amount CHECK (amount > 0),
	KEY idx_expenses_trip_date (trip_id, expense_date),
	KEY idx_expenses_category_date (category, expense_date)
) ENGINE=InnoDB;

CREATE TABLE checklist (
	checklist_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id BIGINT UNSIGNED NOT NULL,
	trip_id BIGINT UNSIGNED NULL,
	item_text VARCHAR(240) NOT NULL,
	is_completed BOOLEAN NOT NULL DEFAULT FALSE,
	completed_at DATETIME NULL,
	created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (checklist_id),
	CONSTRAINT fk_checklist_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
	CONSTRAINT fk_checklist_trip FOREIGN KEY (trip_id) REFERENCES trips (trip_id) ON DELETE CASCADE,
	KEY idx_checklist_user_status (user_id, is_completed),
	KEY idx_checklist_trip (trip_id)
) ENGINE=InnoDB;

CREATE TABLE reports (
	report_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
	user_id BIGINT UNSIGNED NOT NULL,
	report_type VARCHAR(60) NOT NULL,
	period_start DATE NULL,
	period_end DATE NULL,
	generated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	report_data JSON NOT NULL,
	PRIMARY KEY (report_id),
	CONSTRAINT fk_reports_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
	KEY idx_reports_user_type_date (user_id, report_type, generated_at)
) ENGINE=InnoDB;

CREATE OR REPLACE VIEW vw_trip_budget_summary AS
SELECT
	t.trip_id,
	t.user_id,
	CONCAT(d.city, ', ', d.country) AS destination,
	t.start_date,
	t.end_date,
	t.budget,
	COALESCE(SUM(e.amount), 0.00) AS spent,
	t.budget - COALESCE(SUM(e.amount), 0.00) AS remaining,
	CASE WHEN t.budget = 0 THEN 0 ELSE ROUND(COALESCE(SUM(e.amount), 0.00) / t.budget * 100, 2) END AS budget_utilization_percent
FROM trips t
JOIN destinations d ON d.destination_id = t.destination_id
LEFT JOIN expenses e ON e.trip_id = t.trip_id
GROUP BY t.trip_id, t.user_id, d.city, d.country, t.start_date, t.end_date, t.budget;

CREATE OR REPLACE VIEW vw_monthly_expense_summary AS
SELECT
	t.user_id,
	DATE_FORMAT(e.expense_date, '%Y-%m-01') AS month_start,
	e.category,
	COUNT(*) AS expense_count,
	SUM(e.amount) AS total_amount
FROM expenses e
JOIN trips t ON t.trip_id = e.trip_id
GROUP BY t.user_id, DATE_FORMAT(e.expense_date, '%Y-%m-01'), e.category;

DELIMITER $$

CREATE PROCEDURE sp_get_user_dashboard(IN p_user_id BIGINT UNSIGNED)
BEGIN
	SELECT COUNT(*) AS total_trips, COALESCE(SUM(budget), 0.00) AS total_budget
	FROM trips WHERE user_id = p_user_id;
	SELECT COALESCE(SUM(e.amount), 0.00) AS total_expenses
	FROM expenses e JOIN trips t ON t.trip_id = e.trip_id WHERE t.user_id = p_user_id;
	SELECT * FROM vw_trip_budget_summary WHERE user_id = p_user_id ORDER BY start_date;
END$$

CREATE PROCEDURE sp_create_trip(
	IN p_user_id BIGINT UNSIGNED,
	IN p_destination_id BIGINT UNSIGNED,
	IN p_start_date DATE,
	IN p_end_date DATE,
	IN p_budget DECIMAL(12, 2),
	IN p_hotel_name VARCHAR(180),
	IN p_transportation VARCHAR(120),
	IN p_notes TEXT
)
BEGIN
	INSERT INTO trips (user_id, destination_id, start_date, end_date, budget, hotel_name, transportation, notes)
	VALUES (p_user_id, p_destination_id, p_start_date, p_end_date, p_budget, p_hotel_name, p_transportation, p_notes);
	SELECT LAST_INSERT_ID() AS trip_id;
END$$

CREATE TRIGGER trg_checklist_completed_at
BEFORE UPDATE ON checklist
FOR EACH ROW
BEGIN
	IF NEW.is_completed = TRUE AND OLD.is_completed = FALSE THEN
		SET NEW.completed_at = CURRENT_TIMESTAMP;
	ELSEIF NEW.is_completed = FALSE THEN
		SET NEW.completed_at = NULL;
	END IF;
END$$

CREATE TRIGGER trg_expense_trip_owner
BEFORE INSERT ON expenses
FOR EACH ROW
BEGIN
	IF NOT EXISTS (SELECT 1 FROM trips WHERE trip_id = NEW.trip_id) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Expense must reference an existing trip';
	END IF;
END$$

DELIMITER ;
