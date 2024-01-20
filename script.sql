--melihat semua database => \l

SELECT datname FROM pg_database;

--melihat semua tabel = \dt
select  * from pg_tables where schemaname = 'public' ;

-- create tabel
create table barang(
kode int,
name varchar(100),
harga int,
jumlah int
);

--melihat isi tabel
select * from public.barang;

--alter table menabah kolom
alter table barang add column deskripsi text;

--alter tabel hapus kolom
alter table public.barang drop column deskripsi;

--alter table mengubah nama kolom
alter table public.barang rename name to nama;

--menghapus table
drop table public.barang;

create table barang (
kode int not null,
nama varchar(100) not null,
harga int not null default 1000,
jumlah int not null default 0,
waktu_dibuat timestamp not null default current_timestamp
);

create table products(
id varchar(10) not null,
name varchar(100) not null,
description text,
price int not null,
quantity int not null default 0,
created_at timestamp not null default current_timestamp 
);

--memasukan data ke tabel products
insert into public.products(id, name, price, quantity)
values('P0001', 'Mi ayam original', 15000, 100);

insert into public.products(id, name, description, price, quantity)
values('P0002', 'Mi Ayam bakso tahu', 'Miayam original dengan tambahan toping bakso tahu', 20000, 100);

--insert multi velue
insert into public.products(id, name, description, price, quantity)
values
('P0003', 'Nasi Padang', 'Nasi padang khas', 25000, 100),
('P0004', 'Sate', 'sate ayam oroiginal', 15000, 100),
('P0005', 'Ikan Bakar','Ikan tuna bakar spesial', 20000, 100),
('P0006', 'Nasi goreng', 'Nasi goreng spesial', 20000, 100);

--menampilkan data yang ada di tabel products
select * from public.products; 

select p.name, p.description, p.price from public.products as p;

--menambahkan primary key pada tabel yang sudah ada
alter table products add primary key (id);

--menambahakan primary key saat membuat tabel
create table users(
id varchar(10) not null,
name varchar(100) not null,
age int not null,
created_at timestamp not null default current_timestamp,
--menambahkan primary key
primary key (id)
);

--menggunakan where clause
select p.name, p.description, p.price from public.products as p where p.price < 20000;

--membuat tipedata enum
create type product_category as enum ('makanan', 'minuman', 'lain-lain');

--menambahkan tipedata enum yang telah dibuat(produc_category) pada tabel products menggunakan perintah alter
alter table public.products add column category product_category;

--update data products
update products set category = 'makanan' where products.id = 'P0006';

update products set price = price + 5000 where products.id = 'P0006';

--hapus data
delete from products where id = 'P0006';

--allias
select p.name as nama, p.description as deskripsi, p.price as harga from products as p ;

--dua kondisi
select p.name, p.description, p.price from public.products as p where p.category = 'makanan' and p.price < 20000;

insert into products (id, name, description, price, quantity, category)
values
('P0006', 'Es cendol', 'Es cendol madagaskar', 5000, 100, 'minuman'),
('P0007', 'Es cincau', 'cincau dengan tambahan suket', 10000, 100, 'minuman'),
('P0008', 'Es Doger', 'Es doger khas betawi', 10000, 100, 'minuman'),
('P0009', 'ES serut', 'Es serut khas prindapan', 2000, 100, 'minuman'),
('P0010', 'Es Dawet', 'Es dawet spesial', 4000, 100, 'minuman');

select p.name, p.description, p.price from public.products as p where p.category = 'minuman' and p.price < 15000;

select p.name, p.description, p.price, p.category from public.products as p where p.price < 20000 or p.category = 'minuman';

--operasi yang diprioritaskan 
select p.name as nama, p.description as deskripsi, p.price as harga, p.category as kategori from products as p where 
(p.quantity > 100 or p.category = 'makanan') and p.price > 1000;

--operasi like dan ilike
--like -> case sensitive
select * from products as p where p.name like '%mi%';
--ilike -> in case sensitive
select * from products as p where p.name ilike '%es% ';

--null operasi
--is null
select * from products where description is null;
--is not null
select * from products where description is not null;

--between operasi
--beetwen
select * from products where price between 10000 and 20000;
--not between
select * from products where price not between 15000 and 20000;

--in operator
--opertator in mirip seperti or namun bisa menggunakan banyak objek, tidak seperti operaso or yang hanya 2 objek
--in
select * from products where category in ('makanan', 'minuman');
--not in
select * from products where price not in (1000, 15000);

--order by
select * from products order by price asc , id desc;

--limit clause
select * from products where price > 0 order by price asc, id desc limit 3;

--offset clasue : menskip data yang pertama kali didapat
select * from products where price > 0 order by price asc, id desc limit 3 offset 2;

--distinct: menghilangkan data duplikat dari hasil query select
select distinct category from products ;

--Aritmatic operator
select 10 + 10 as hasil;

select id, name, price / 1000 as price_in_k from products ;

--matematical function
select pi();

select sin(10), cos(10), tan(10); 

select power(10, 4) ;

--auto incremen
create table admin(
--id auto increment
id serial not null,
first_name varchar(100) not null,
last_name varchar(100) not null	,
primary key(id)
);

insert into admin(first_name, last_name)
values
('alliano', 'alli'),
('allia', 'azahra');

select * from admin;

--melihat id terakir auto increment
select currval(pg_get_serial_sequence('admin', 'id')); 

select currval('admin_id_seq') ;

--sequence

-- membuat sequence
create sequence contoh_sequence;

select nextval('contoh_sequence');

select currval('contoh_sequence'); 

--String function
select id, lower(name), length(name), lower(description) from products;

--date and time function 
select id, extract(year from created_at), extract(month from created_at) from products ;

--flow control function
select id, category, case 
	when category = 'makanan' then 'wenak'
	when category = 'minuman' then 'seger'
	else 'gakksenak :v'
end as category
from products ;


select price as harga, case
	when price <= 15000 then 'Murah'
	when price >= 20000 then 'Mahal'
	else 'mahal banget aj:v'
end as murah
from products ;

select name, description, case 
	when description is null then 'Kosong'
	else description
end as deskripsi
from products;

--agregate function
select count(id) from products ;

select avg(price) from products ;

select max(price) from products;

select min(price) from products ; 

--grouping
select category, count(category) as jumlah, 
	avg(price) as "harga rata-rata", 
	max(price) as "Paling mahal", 
	min(price) as "paling murah" 
from products group by category; 

--having : menggunakan having harus menggunakan agregate dan group by. having sama seperti where
select category, count(id) as "jumlah produk"
from products group by category
having count(id) > 3 ;

--constrain
-- unique constrrain
CREATE TABLES customer (
    id SERIAL Not NULL,
    email VARCHAR(100) NULL NULL,
    first_name VARCHAR(100) not NULL,
    last_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT unique_email UNIQUE (email)
);

INSERT INTO customer(email, first_name, last_name)
VALUES
('allianoanonymoust@gmail.com', 'alliano', 'alli');

INSERT INTO customer(email, first_name, last_name)
VALUES
('allia@gmail.com', 'allia', 'azahra'),
('entah@gmail.com', 'entah', 'gatau'),
('koktanyasaya@gmail.com', 'jokowi', 'widodo');

-- menghapus constrain
ALTER TABLE customer DROP CONSTRAINT unique_email;

-- menambahakan constrain ke tabel existing
ALTER TABLE customer ADD CONSTRAINT unique_email UNIQUE (email);

-- check constrain
CREATE Table products(
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT price_check CHECK (price >= 100)
);

-- menambahkan constrain check pada existing tabel
ALTER TABLE products ADD CONSTRAINT price_check CHECK (price >= 1000);

ALTER TABLE products ADD CONSTRAINT quantity_check CHECK (quantity >= 0);

INSERT INTO products(id, name, price, quantity, category) 
VALUES
('X0002', 'contoh gagal', 30000, -100, 'makanan');

DELETE FROM products WHERE id IN ('X0001', 'X0002', 'X0003');

-- menghapus coinstrain check
ALTER TABLE products DROP CONSTRAINT price_check;



-- index
CREATE TABLE sellers (
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (id), -- saat membuat PRIMARY KEY, portgres secara otomatis akan membuatkan index
    CONSTRAINT email_unique UNIQUE (email) -- saat membuat constraint, posthres secara oromatis juga membuatkan index
);

INSERT INTO sellers(name, email)
VALUES 
('alas store', 'alastrore@gmail.com'),
('shoes store', 'shoes@gmail.com'),
('aerostreet store', 'areoss@gmail.com'),
('vemtela', 'ventela@gmail.com'),
('jordan', 'jordanofficeial112@gmail.com');

SELECT * FROM sellers WHERE id = 1; -- ini akan menggunakan index
SELECT * FROM sellers WHERE id = 1 OR name = 'alas store'; -- ini tidak akan menggunakan index karna kita tidak punya gabungan index id dan name
CREATE INDEX sellers_id_and_name_index ON sellers (id, name); -- membuatkan gambungan index id dan name
SELECT * FROM sellers WHERE id = 1 OR name = 'alas store'; -- ini akan menggunakan index karna kita memiliki gabungan index id dan name
SELECT * FROM sellers WHERE name = 'alas store' OR email = 'alastore@gmail.com'; -- ini tidak akan menggunakan index karna kita nga punya gabungan index email dan name
CREATE INDEX sllers_name_and_email_index ON sellers (name, email);
SELECT * FROM sellers WHERE name = 'alas store' OR email = 'alastore@gmail.com'; -- ini akan menggunakan index karna kita memiliki gabungan index name dan email
SELECT * FROM sellers WHERE name = 'alas store'; -- ini tiak akan menggunakan index 
CREATE INDEX sellers_name_index ON sellers (name);
SELECT * FROM sellers WHERE name = 'alas store'; -- ini akan menggunakan index

-- perlu diketahui saat kita menambahkan index, proses query select emg cepet
-- namun unutk operasi insert, update, delete akan menjadi lambat karena setipa proses
-- insert update delete akan mengupdate juga tipe data btree nya


-- FUlLL TEXT SEARCH
SELECT cfgname FROM pg_ts_config; -- meilihat bahasa yang didukung untuk melakukan full-text-search
-- sebelum menggunakan full test search kita harus membuat terlebih dahulu index untuk full tex search nya pada kolom yang kita ingin cari.
CREATE INDEX products_name_search on products USING GIN (to_tsvector('indonesian', name));
CREATE INDEX products_description_search on products USING GIN (to_tsvector('indonesian', description));

-- untuk melakukan SEARCH menggunakan fulltext search itu menggunakan @@ to_tsquery('')
SELECT * FROM products WHERE name @@ to_tsquery('mi');
SELECT * FROM products WHERE description @@ to_tsquery('tambahan');

-- menghapus index
DROP INDEX products_name_search;
DROP INDEX products_description_search;


-- Query OPERATOR
-- to_tsquery() mendukung banyak operator
-- & => AND
-- | => OR
-- ! => NOT
-- '''' => gabungan kata

SELECT * FROM products WHERE name @@ to_tsquery('Mi & tahu');
SELECT * FROM products WHERE name @@ to_tsquery('Mi | bakso');
SELECT * FROM products WHERE name @@ to_tsquery('Mi & !bakso');
SELECT * FROM products WHERE name @@ to_tsquery(''' Mi Ayam original ''');


-- tipe data TSVECTOR
-- agar secara otomatis field dengan tipedata text dibuatkan index fulltext-search
-- kita bisa menggunkakan tipedata TSVECTOR

CREATE TABLE store(
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL,
    description TSVECTOR,
    PRIMARY KEY (id),
    CONSTRAINT store_email_unique UNIQUE (email)
);

INSERT INTO store(name, email, description)
VALUES
('Aerostreet official store', 'aeros@gmail.com', 'toko produk bermerek aerosteet'),
('Ventela official store', 'ventela34@vent.com', 'toko utama spatu ventela');

SELECT * FROM store WHERE description @@ to_tsquery('aerosteet');




-- Relasi antar tabel
CREATE TABLE wishlist(
    id SERIAL NOT NULL,
    id_product VARCHAR(10) NOT NULL,
    description TEXT,
    PRIMARY KEY (id),
    CONSTRAINT fk_wishlist_product FOREIGN KEY (id_product) REFERENCES products (id)
);

-- menghapus FOREIGN KEY
ALTER TABLE wishlist DROP CONSTRAINT fk_wishlist_product;

-- menambahkan FOREIGN KEY menggunakan perintah ALTER
ALTER TABLE wishlist ADD CONSTRAINT fk_wishlist_products FOREIGN KEY (id_product) REFERENCES products (id);

-- mengubah beavior FOREIGN
-- secara default perilaku FOREIGN KEY itu RESTRICT(tidak dapat dihapus dan update)
-- ada banyak perilaku FOREIGN KEY yang bisa dipakai

ALTER TABLE wishlist DROP CONSTRAINT fk_wishlist_products;

-- mengubahh beavior foreign key RESTRICT ke CASCADE untuk proses update dan delete
ALTER TABLE wishlist ADD CONSTRAINT fk_wishlist_products FOREIGN KEY (id_product) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE;


-- Join table
SELECT p.name, w.description, p.price FROM wishlist AS w JOIN products AS p ON p.id = w.id_product;
INSERT INTO wishlist(id_product, description)
VALUES
('P0001', 'mi ayam original khas solo'),
('P0002', 'mi ayam bakso tahu favorit'),
('P0003', 'nasi padang porsi kuli'),
('P0004', 'sate madura'),
('P0005', 'ikan bakar colocolo');

-- Multiple join
ALTER TABLE wishlist ADD COLUMN id_customer int;
ALTER TABLE wishlist ADD CONSTRAINT fk_wishlist_customer FOREIGN KEY(id_customer) REFERENCES customer (id);
UPDATE wishlist SET id_customer = 4 WHERE id = 4;
SELECT * FROM wishlist;

SELECT c.email AS email, p.id AS produk_id, p.name AS nama, w.description AS deskripsi FROM wishlist AS w 
JOIN products AS p ON (w.id_product = p.id)
JOIN customer AS c ON (c.id = w.id_customer);




-- ONE TO ONE RELATION SHIP
CREATE TABLE wallet(
    id SERIAL NOT NULL,
    id_customer INT NOT NULL,
    belance int NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT id_costumer_unique UNIQUE (id_customer),
    CONSTRAINT fk_wallet_customer FOREIGN KEY (id_customer) REFERENCES customer (id)
);

INSERT INTO wallet (id_customer, belance)
VALUES
(1, 5000000),
(2, 3000000),
(3, 9000000),
(4, 2000000);

SELECT * FROM wallet;

SELECT cu.first_name AS nama, cu.email AS email, wa.belance AS "jumlah saldo" 
FROM customer AS cu JOIN wallet AS wa ON (cu.id = wa.id_customer);

-- Many TO ONE relation ship
CREATE TABLE categories(
    id VARCHAR(10) NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (id)
);

ALTER TABLE products DROP category;

ALTER TABLE products ADD COLUMN category VARCHAR(10);

-- untuk relasi one to many relation ship artinya kolom foreign key nya nga unique, artinya dalam satu tabel boleh ada banyak data yang sama
-- satu kategori boleh dimiliki banyak produk
ALTER TABLE products ADD CONSTRAINT fk_product_category FOREIGN KEY (category) REFERENCES categories (id);

INSERT INTO categories(id, name)
VALUES
('X0001', 'makanan'),
('X0002', 'minuman'),
('X0003', 'lain-lain');

UPDATE products SET category = 'X0001' WHERE id IN ('P0001', 'P0002', 'P0003', 'P0004', 'P0005');
UPDATE products SET category = 'X0002' WHERE id IN ('P0006', 'P0007', 'P0008', 'P0009', 'P0010');

SELECT * FROM products;


-- MANY TO MANY RELATION SHIP
CREATE TABLE orders
(
    id SERIAL NOT NULL,
    total INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE orders_products_detail
(
    id_product VARCHAR(10) NOT NULL,
    id_order INT NOT NULL,
    price INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id_product, id_order)
);

ALTER TABLE orders_products_detail ADD CONSTRAINT fk_orders_detail_product FOREIGN KEY (id_product) REFERENCES products (id);
ALTER TABLE orders_products_detail ADD CONSTRAINT fk_order_detail_orders FOREIGN KEY (id_order) REFERENCES orders (id);

INSERT INTO orders_products_detail(id_product, id_order, price, quantity)
VALUES
('P0001', 2, 15000*2, 2),
('P0002', 1, 20000, 1),
('P0004', 4, 2000, 1),
('P0002', 3, 15000, 1);

INSERT INTO orders(total)
VALUES
(1),
(1),
(1),
(1),
(1);

SELECT * FROM products;

SELECT * FROM orders;

select  * from orders_products_detail opd ;

select * from orders as o join orders_products_detail as opd on opd.id_order = o.id
join products as p on opd.id_product = p.id ;


-- JOIN terbagi menjadi banyak : INNER JOINT, LEFT JOIN, RIGHT JOINT, FULL JOIN

-- Sub querys

SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);

-- sub query pada from clause
SELECT MAX(price) FROM (SELECT products.price as price FROM categories JOIN products ON products.category = categories.id) AS contoh;




-- SET OPERATOR ada banyak : UNION, UNION ALL, INTERSEC, EXCEPT
CREATE TABLE guestbooks
(
    id SERIAL NOT NULL,
    email VARCHAR(50) NOT NULL,
    title VARCHAR(100),
    content TEXT,
    PRIMARY KEY (id),
    CONSTRAINT guestbooks_email_unique UNIQUE (email)
);

SELECT * FROM customer;

INSERT INTO guestbooks(email, title, content) 
VALUES
('allianoanonymoust@gmail.com', 'feedback alliano', 'feedback dari alliano'),
('allianoanonymoust@gmail.com', 'feedback alliano', 'feedback dari alliano'),
('allia@gmail.com', 'feedback allia', 'feedback dari allia'),
('valen@gmail.com', 'feedback falen', 'feedback nya valen'),
('valen@gmail.com', 'feedback valen', 'feedback dari valen');

INSERT INTO guestbooks(email, title, content)
VALUES
('Lich@gmail.com', 'feedback lich', 'feedback dari lich');
-- menghilagkan data duplikat pada query 2 tabel ; => UNION
SELECT DISTINCT email FROM customer
UNION
SELECT DISTINCT email FROM guestbooks;

-- menampilkan 2 data pada tabel dan tidak menghiraukan duplikat atau nga ; => UNION ALL
SELECT DISTINCT email FROM customer
UNION ALL
SELECT DISTINCT email FROM guestbooks;

SELECT email, COUNT(email) FROM (
    SELECT DISTINCT email FROM customer 
    UNION ALL 
    SELECT DISTINCT email FROM guestbooks
) AS contoh
GROUP BY email;

-- INTERSECT : pengabungan 2 query tapi yang ditampilkan datanya yang ada di query pertama dan query ke dua
SELECT DISTINCT email FROM customer -- data ada
INTERSECT
SELECT DISTINCT email FROM guestbooks; -- data ada
-- maka data tersebut akan di tampilkan

-- EXCEPT : jika data pada query pertama itu sama degngan data hasil query ke 2 maka data itu akan dihilangkan, dan data yang ditampilkan hanya data pada query pertama yang tidak ada di query ke 2
SELECT email FROM customer
EXCEPT
SELECT email FROM guestbooks;


-- TRANSCTION


-- jika data dinyatakan benar maka, lakukan commit dan data akan di simpan ke db jikalau
-- data dianggap salah atau tidak valid maka lakukan rollback agar data tersebut tidak di simpan dalam database

-- LOCKING : jikalau 2 user atau lebih melakukan operasi pada 1 data, eksekusinya dilakukan sequensial
-- jika user 1 belum selesai melakukan operasi pada data tersebut maka user 2 dan seterusnya harus mengantri
-- hingga user 1 selesai melakukan operasi pada data tersebut.
-- Proses ini dilakukan saat kita menggunakan TRANSACTION
-- COMMIT
START TRANSACTION;
INSERT INTO guestbooks (email, title, content)
VALUES
('asta@gmail.com', 'kaisar sihir', 'kaisar sihir asta');

COMMIT;


-- ROLLBACK


START TRANSACTION;
INSERT INTO guestbooks (email, title, content)
VALUES
('asta@gmail.com', 'satria sihir', 'kesartia sihir asta');
ROLLBACK;



-- Locking manual

START TRANSACTION;
SELECT * FROM products WHERE id = 'P0002' FOR UPDATE;
ROLLBACK;


-- DEAD LOCK
-- proses 1 melakukan SELECT FOR UPDATE untuk data 0001
-- proses 2 melakukan SELECT FOR UPDATE untuk data 002
-- proses 1 melakukan SELECT FOR UPDATE untuk data 002; => proses 1 menggu karna data 002 di lock sama proses 2
-- proses 2 melakukan SELECT FOR UPDATE untuk data 001 => proses 2 mengunggu karna dada 001 di lock sama proses 1;
-- akirnya terjadi circular locking
-- dan terjadi deadlock


-- SCHEMA

-- meiliha sechema yang dingunakan saat ini
SELECT current_schema();
SHOW SEARCH_PATH;

-- membuat schema
CREATE SCHEMA contoh_schema;

-- menghapus schema
DROP SCHEMA contoh_schema;

-- pindah schema
SET SEARCH_PATH TO contoh_schema;

SELECT current_schema();




-- USER MANAGEMENT

CREATE ROLE alliano; -- membuat user
DROP role alliano; -- menghapus user

-- menambahkan hak akses
CREATE ROLE allia LOGIN PASSWORD 'allia-azahra' CREATEDB;

-- menambahkan hak akses kepada role existing
ALTER ROLE alliano LOGIN PASSWORD 'alliano-dev' CREATEDB SUPERUSER;

-- refrence : https://www.postgresql.org/docs/current/sql-createrole.html
-- refrence : https://www.postgresql.org/docs/current/sql-alterrole.html

-- memberi hak akses ke tabel
GRANT INSERT, UPDATE, SELECT, DELETE ON ALL TABLES IN SCHEMA public TO alliano;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO allia;


-- menghapus hak akses
REVOKE DELETE, SELECT ON ALL TABLES IN SCHEMA public FROM alliano;
REVOKE DELETE, SELECT ON customer FROM alliano;

DROP ROLE alliano, allia;
CREATE DATABASE belajar_restore;


-- BACKUP DATABASE
-- menggunakan applikasi console(terminal, CMD, dll)
-- harus menggunakan super user
pg_dump --host=localhost --port=5432 --dbname=belajar --format=plain --file=/home/alliano-dev/Latihan/Database/pg_backup1.sql --username=alliano-dev --password

-- RESTORE DB
psql --host=localhost --port=5432 --dbname=belajar_restore --username=alliano-dev --file=/home/alliano-dev/Latihan/Database/pg_backup.sql --password








