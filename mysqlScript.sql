CREATE DATABASE library_db;

USE library_db;

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(50) UNIQUE NOT NULL,
    available_copies INT NOT NULL
);

CREATE TABLE borrow_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    librarian_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    return_date DATE,

    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (librarian_id) REFERENCES librarians(librarian_id)
);

CREATE TABLE librarians (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO members (name, email,phone) VALUES
('Bat-Erdene','bat@example.com','99112233'),
('Saraa','saraa@example.com','99113344'),
('Bold','bold@example.com','99114455');

INSERT INTO books (title, author, isbn, available_copies) VALUES
('Database Systems','Thomas Connolly','9781234561',5),
('Learning SQL','Alan Beaulieu','9781234562',3),
('Python Programming','Mark Lutz','9781234563',4);

INSERT INTO librarians (name,email) VALUES
('Tungalag','tungalag@library.com'),
('Munkh','munkh@library.com');

INSERT INTO borrow_records (member_id, book_id, librarian_id, borrow_date, return_date) VALUES
(1,1,1,'2026-03-01','2026-03-10'),
(1,2,2,'2026-03-05',NULL),
(2,1,1,'2026-03-07','2026-03-15'),
(3,3,2,'2026-03-10',NULL),
(1,3,1,'2026-03-15',NULL);

SELECT 
m.name AS member,
b.title AS book,
l.name AS librarian,
br.borrow_date
FROM borrow_records br
JOIN members m ON br.member_id = m.member_id
JOIN books b ON br.book_id = b.book_id
JOIN librarians l ON br.librarian_id = l.librarian_id;

SELECT 
b.title,
COUNT(br.record_id) AS borrow_count
FROM books b
LEFT JOIN borrow_records br 
ON b.book_id = br.book_id
GROUP BY b.title;

SELECT 
b.title,
COUNT(br.record_id) AS borrow_count
FROM books b
JOIN borrow_records br
ON b.book_id = br.book_id
GROUP BY b.title
ORDER BY borrow_count DESC
LIMIT 1;

SELECT 
m.name,
COUNT(br.book_id) AS borrowed_books
FROM members m
JOIN borrow_records br
ON m.member_id = br.member_id
GROUP BY m.name
HAVING COUNT(br.book_id) >= 2;

SELECT book_id, COUNT(*)
FROM borrow_records
GROUP BY book_id;

CREATE USER 'admin_user'@'localhost'
IDENTIFIED BY 'admin123';

GRANT ALL PRIVILEGES 
ON library_db.* 
TO 'admin_user'@'localhost';

CREATE USER 'report_user'@'localhost'
IDENTIFIED BY 'report123';

GRANT SELECT
ON library_db.*
TO 'report_user'@'localhost';

SHOW GRANTS FOR 'admin_user'@'localhost';

SHOW GRANTS FOR 'report_user'@'localhost';