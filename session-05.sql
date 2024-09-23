select * from product; 
DELETE from product;
INSERT INTO product(name,price,category_id) VALUES
("QUAN",100,2), 
("MU",100,2),
("AO QUAN",100,2);
-- Đánh chỉ mục của bảng sản phẩm 
USE session01_demo2;
CREATE INDEX indx_name_pro ON product(name);

SHOW INDEX FROM product;
-- Dánh chỉ unique 

create table account(
	id int primary key,
    full_name varchar(100),
    address varchar(255)
);
INSERT INTO account VALUES 
(3,'Ngọc Anh','Hà Nội'),
(1,'Ngọc Anh','Hà Nội'),
(5,'Ngọc Anh','Hà Nội'),
(7,'Ngọc Anh','Hà Nội');

DELETE FROM account WHERE full_name = 'a';
SELECT * FROM account; 

CREATE INDEX indx_full_name_acc ON account(full_name);
INSERT INTO account VALUES 
(44,'a','Hà Nội'),
(14,'c','Hà Nội'),
(54,'a','Hà Nội'),
(744,'d','Hà Nội');
-- Xóa chỉ mục 

ALTER TABLE account DROP INDEX indx_full_name_acc; 
-- INDEX UNIQUE 
CREATE UNIQUE INDEX indx_full_name_acc ON account(full_name);

-- TẠO VIEW 
create view vw_show_pro_all_with_cate_name AS 
	SELECT p.id,p.name,p.price,c.name as category_name 
    FROM category c 
    JOIN product p 
    ON c.id = p.category_id;


-- tạo mới hoặc thay thê 
create or replace view vw_show_pro_all_with_cate_name AS 
	SELECT p.id as pro_id,p.name,p.price,c.name as category_name 
    FROM category c 
    JOIN product p 
    ON c.id = p.category_id;

-- gọi view (bảng) 
select * FROM vw_show_pro_all_with_cate_name;

-- Tạo thủ tục lấy về danh sách sản phẩm gồm id,name,price,tên danh mục 

DELIMITER $$
	create procedure proc_get_all_product()
    BEGIN
		SELECT p.id as pro_id,p.name,p.price,c.name as category_name 
		FROM category c 
		JOIN product p 
		ON c.id = p.category_id;
    END
$$
DELIMITER ; 

-- Gọi thủ tục 
CALL proc_get_all_product();

-- Thủ tục có tham số truyền vào 
SELECT * FROM product WHERE category_id = ? 
-- viết thủ tục tìm về danh sách sản phẩm theo mã danh mục truyền vào 
DELIMITER $$
	create procedure proc_getAll_pro_by_categoyr_id(IN cate_id int)
    BEGIN	
		SELECT * FROM product WHERE category_id = cate_id;
    END
$$
DELIMITER ;
-- Gọi thủ tục 
CALL proc_getAll_pro_by_categoyr_id(2);

-- thủ tục có tham số đầu ra 
-- viết thủ tục trả về số sản phẩm theo mã danh mục 
DELIMITER $$
	CREATE procedure get_total_pro_by_cate_id(IN cate_id int, OUT total int)
	BEGIN
			SET total = (SELECT count(p.category_id) AS total_pro 
			from category c 
			left join product p 
			ON c.id = p.category_id 
			group by c.id HAVING c.id = cate_id);
    END $$
DELIMITER ;
-- goi thu tuc co tham so dau vao va dau ra
CALL get_total_pro_by_cate_id(2,@total);
SELECT @total as total_pro;

