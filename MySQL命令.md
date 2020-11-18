[toc]



# Mysql详细命令

## 显示信息命令（SHOW）

```mysql
-- 显示数据库信息
SHOW DATABASES
-- 选择某个数据库
USE 数据库
-- 显示表信息
SHOW TABLES
-- 显示表的列信息
SHOW COLUMNS FROM customers;
DESCRIBE customers;
-- 显示服务器状态信息
SHOW STATUS;
-- 显示服务器错误信息
SHOW ERRORRS;
-- 显示服务器警告信息
SHOW WARNINGS;
-- 显示创建特定数据库的语句信息
SHOW CREATE DATABASE 数据库名;
-- 显示创建特定表的语句信息
SHOW CREATE TABLE 表名;
-- 显示授予用户的安全权限信息
SHOW GRANTS;
```



## 检索数据命令（SELECT）

SELECT 子句顺序

| 子句     | 说明                 | 是否必须使用           |
| -------- | -------------------- | ---------------------- |
| SELECT   | 要返回的列或者表达式 | 是                     |
| FROM     | 从中检索数据的表     | 仅在从表选择数据时使用 |
| WHERE    | 行级过滤             | 需要过滤行数据时使用   |
| GROUP BY | 分组说明             | 仅在按组计算聚集时使用 |
| HAVING   | 组级过滤             | 需要过滤组数据时使用   |
| ORDER BY | 排序顺序             | 数据需要进行排序时使用 |
| LIMIT    | 要检索的行数         | 需要限制检索行数时使用 |



```mysql
-- 检索数据，返回单个列
SELECT cust_id FROM customers;
-- 检索数据，返回多个列
SELECT cust_id, cust_name[,列名] FROM customers;
-- 检索数据，返回全部列
SELECT * FROM customers;
-- 检索数据，去除重复数据（distinct）
SELECT DISTINCT vend_id FROM product;
-- 检索数据，限制数据条数（第一行的行号为：0）
SELECT prod_name FROM products LIMIT 5;
SELECT prod_name FROM products LIMIT 需返回的行数;
SELECT prod_name FROM products LIMIT 开始的行号, 需返回的行数;
-- 检索数据，使用完全限定的表明
SELECT products.prod_name FROM crashcourse.products;
-- 检索数据，将数据按照单个列进行排序
SELECT prod_name FROM products ORDER BY prod_name;
-- 检索数据，将数据按照多个列进行排序（先按照price，再按照name排序）
SELECT prod_id, prod_price, prod_name 
FROM products 
ORDER BY prod_price, prod_name;
-- 检索数据，指定排序方向（DESC：降序；ASC：升序）
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC;
-- 检索数据，将数据按照多个列排序（DESC：降序；ASC：升序）
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_id DESC, prod_name;
-- 检索数据，利用排序和限制语句查询最大值或者最小值
SELECT prod_i5 FROM products DESC LIMIT 1;


-- 检索数据，使用 WHERE 子句（where）
-- 判断数字相等
SELECT prod_name, prod_price 
FROM products
WHERE prod_price = 2.5;
-- 判断字符相等，mysql默认不区分大小写，所以Fuses和fuses匹配
SELECT prod_name, prod_price
FROM products
WHERE prod_name='fuses';
-- 判断是否在两个数字之间
SELECT prod_name, prod_price
FROM products
WHERE prod_price BETWEEN 5 AND 10;
-- 判断空值
SELECT prod_name
FROM products
WHERE prod_price IS NULL;


-- 检索数据，组合WHERE子句（AND 和 OR）
-- AND 操作符
SELECT prod_id, prod_price, prod_name
FROM products
WHERE vend_id = 1003 AND prod_price <= 10;
-- OR 操作符
SELECT prod_name, prod_price
FROM products
WHERE vend_id = 1002 OR vend_id = 10033;
-- AND 和 OR 操作符连用
SELECT prod_name, prod_price
FROM products
WHERE (vend_id = 1002 OR vend_id = 1003) AND prod_price >= 10;
-- IN 操作符
SELECT prod_name, prod_price
FROM products
WHERE vend_id IN (1002, 1003)
ORDER BY prod_name;
-- NOT 操作符
SELECT prod_name, prod_price
FROM products
WHERE vend_id NOT IN (1002, 1003)
ORDER BY prod_name;


-- 检索数据，用通配符进行过滤
-- LIKE 操作符
-- 百分号通配符（ % ）:表示匹配‘ % ’之后所有的任意字符，任意个数
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE 'jet%';
-- 下划线（_）通配符：仅匹配‘ 单个 ’任意字符
SELECT prod_id, prod_name
FROM products
WHERE prod_name LIKE 'jet_';


-- 检索数据，使用正则表达式过滤（REGEXP：其后跟正则表达式）
-- 基本字符匹配
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000'
ORDER BY prod_name;
-- 使用 ‘ . ’ 字符
SELECT prod_name
FROM products
WHERE prod_name REGEXP '.000'
ORDER BY prod_name;
-- 进行 OR 匹配
SELECT prod_name
FROM products
WHERE prod_name REGEXP '1000|2000'
ORDER BY prod_name;
-- 匹配几个字符之一
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[123] Ton'
ORDER BY prod_name;
-- 匹配范围
SELECT prod_name
FROM products
WHERE prod_name REGEXP '[1-5] Ton'
ORDER BY prod_name;



-- 创建分组
SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id;

SELECT vend_id, COUNT(*) AS num_prods
FROM products
GROUP BY vend_id WITH ROLLUP

SELECT cust_id, COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;

SELECT vend_id, COUNT(*) AS num_prods
FROM products
WHERE prod_price >= 10
GROUP BY vend_id
HAVING COUNT(*) >= 2;

SELECT order_num, SUM(quantity * item_price) AS ordertotal
FROM orderitems
GROUP BY order_num
HAVING SUM(quantity * item_price) >= 50;



-- 子查询
-- 利用子查询进行过滤
SELECT cust_name 
FROM customers 
WHERE cust_id IN (SELECT cust_id 
                  FROM orders 
                  WHERE order_num IN (SELECT order_num 
                                      FROM orderitems 
                                      WHERE prod_id='TNT2'));


SELECT cust_name, 
       cust_state, 
       (SELECT COUNT(*) 
        FROM orders 
        WHERE orders.cust_id = customers.cust_id) AS orders
FROM customers
ORDER BY orders;


-- 创建联结
SELECT vend_name, prod_name, prod_price
FROM vendors, products
WHERE vendors.vend_id = products.vend_id
ORDER BY vend_name, prod_name;

-- 内部联结
SELECT vend_name, prod_name, prod_price
FROM vendors INNER JOIN products
ON vendors.vend_id = products.vend_id;

-- 联结多个表
SELECT prod_name, vend_name, prod_price, quantity
FROM orderitems, products, vendors
WHERE products.vend_id = vendors.vend_id
AND products.prod_id = orderitems.prod_id
AND order_num = 20005;

-- 外部联结



```



### GROUP BY 规定

1. GROUP BY 子句可以包含任意数目的列
2. 使用 GROUP BY 子句 必须出现在 WHERE 子句之后，ORDER BY 子句之前
3. 除聚集计算语句外，SELECT 语句中的每个列都必须在 GROUP BY 子句中给出



### 分组和排序

| ORDER BY                                     | GROUP BY                                                 |
| -------------------------------------------- | -------------------------------------------------------- |
| 排序产生的输出                               | 分组行，但是输出可能不是分组的顺序                       |
| 任意列都可以使用（甚至非选择的列也可以使用） | 只可能使用选择列或表达式列，而且必须使用每个选择列表达式 |
| 不一定需要                                   | 如果与聚集函数一起使用列（或表达式），则必须使用         |



### WHERE 和 HAVING 差别

WHERE 过滤行，HAVING 过滤分组

#### WHERE子句操作符

| 操作符  | 说明               |
| ------- | ------------------ |
| =       | 等于               |
| <>      | 不等于             |
| !=      | 不等于             |
| <       | 小于               |
| <=      | 小于等于           |
| >       | 大于               |
| >=      | 大于等于           |
| BETWEEN | 在指定的两个值之间 |





## 函数

### 常用的文本处理函数

| 函数        | 说明               |
| ----------- | ------------------ |
| SubString() | 返回子串的字符     |
| Length()    | 返回串的长度       |
| Locate()    | 找出串的一个子串   |
| Upper()     | 将文本转换为大写   |
| Lower()     | 将串转换为小写     |
| RTrim()     | 去除列值右边的空格 |
| LTrim()     | 去掉串左边的空格   |
| Right()     | 返回串右边的字符   |
| Left()      | 返回串左边的字符   |



### 日期和时间处理函数

**日期格式**：yyyy-mm-dd

| 函数          | 说明                           |
| ------------- | ------------------------------ |
| AddDate()     | 增加一个日期（天、周等）       |
| AddTime()     | 增加一个时间（时、分等）       |
| CurDate()     | 返回当前日期                   |
| CurTime()     | 返回当前时间                   |
| **Date()**    | **返回日期时间的日期部分**     |
| DateDiff()    | 计算两个日期之差               |
| Date_Add()    | 高度灵活的日期运算函数         |
| Date_Format() | 返回一个格式化的日期或时间串   |
| Day()         | 返回一个日期的天数部分         |
| DayOfWeek()   | 对于一个日期，返回对应的星期几 |
| Hour()        | 返回一个时间的小时部分         |
| Minute()      | 返回一个时间的分钟部分         |
| Month()       | 返回一个日期的月份部分         |
| Now()         | 返回当前日期和时间             |
| Second()      | 返回一个时间的秒部分           |
| **Time()**    | **返回一个日期时间的时间部分** |
| Year()        | 返回一个日期的年份部分         |



### 数值处理函数

| 函数   | 说明               |
| ------ | ------------------ |
| Abs()  | 返回一个数的绝对值 |
| Cos()  | 返回一个角度的余弦 |
| Exp()  | 返回一个数的指数值 |
| Mod()  | 返回除操作的余数   |
| Pi()   | 返回圆周率         |
| Rand() | 返回一个随机数     |
| Sin()  | 返回一个角度的正弦 |
| Sqrt() | 返回一个数的平方根 |
| Tan()  | 返回一个角度的正切 |



### 聚集函数

| 函数    | 说明             |
| ------- | ---------------- |
| AVG()   | 返回某列的平均值 |
| COUNT() | 返回某列的行数   |
| MAX()   | 返回某列的最大值 |
| MIN()   | 返回某列的最小值 |
| SUM()   | 返回某列值之和   |

**注意**：

1. WHERE子句和ORDER BY同时使用时，应该让ORDER BY位于WHERE之后
2. 







