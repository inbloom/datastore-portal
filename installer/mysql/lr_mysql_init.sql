CREATE DATABASE lportal;
CREATE USER 'liferay'@'localhost' IDENTIFIED BY 'liferaywgen';
GRANT ALL PRIVILEGES ON lportal.* to liferay@localhost;
