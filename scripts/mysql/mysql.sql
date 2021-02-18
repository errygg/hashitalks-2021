CREATE DATABASE mydb;
CREATE USER 'vault'@'%' IDENTIFIED BY 'vault';
GRANT ALL PRIVILEGES ON mydb.* TO 'vault'@'%' WITH GRANT OPTION;
GRANT CREATE USER ON *.* to 'vault'@'%';

USE mydb;
CREATE TABLE users (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  PRIMARY KEY ( id )
);
INSERT INTO users (name, email) VALUES ("John Smith", "jsmith@example.com");
