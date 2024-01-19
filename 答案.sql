# 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数

select st.s_name, st.s_birth, st.s_sex,coalesce(s1.s_score,0) as '课程01分数', coalesce(s2.s_score,0) as '课程02分数'
from student st
left join score s1 on s1.s_id = st.s_id and s1.c_id = '01'left join score s2 on s2.s_id = st.s_id and s2.c_id = '02'
where coalesce(s1.s_score,0) > coalesce(s2.s_score,0);


# 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数
select st.s_name, st.s_birth, st.s_sex,coalesce(s1.s_score,0) as '课程01分数', coalesce(s2.s_score,0) as '课程02分数'
from student st
left join score s1 on s1.s_id = st.s_id and s1.c_id = '01'
left join score s2 on s2.s_id = st.s_id and s2.c_id = '02'
where coalesce(s1.s_score,0) < coalesce(s2.s_score,0);

# 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩

select st.s_id, round(avg(s1.s_score),2),sum(s1.s_score)
from student st 
left join score s1 on st.s_id = s1.s_id 
where s1.s_score is not null
GROUP BY st.s_id;

# 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的) 

select st.s_id, round(avg(IFNULL(s1.s_score,0)),2) as avg ,sum(IFNULL(s1.s_score,0)) as sum
from student st  
left join score s1 on st.s_id = s1.s_id 
GROUP BY st.s_id
having avg < 60;

# 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩

select st.*,count(s1.c_id) ,SUM(IFNULL(s1.s_score,0))
from student st 
left join score s1 on st.s_id = s1.s_id 
group by st.s_id;


# 6、查询"李"姓老师的数量

select '李', count(*) 
from student 
where s_name like '%李%';


# 7、查询学过"张三"老师授课的同学的信息

select * 
from student st 
left join score s on st.s_id = s.s_id
left join course c on s.c_id = c.c_id
left join teacher t on c.t_id = t.t_id
where t.t_name = '张三';


# 8、查询没学过"张三"老师授课的同学的信息
select * from student where s_id not in (
select st.s_id 
from student st 
left join score s on st.s_id = s.s_id
left join course c on s.c_id = c.c_id
left join teacher t on c.t_id = t.t_id
where t.t_name = '张三');

# 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息

select st.*from student st 
where st.s_id in (
	select s_id 
	from score s 
	where s.s_id in (select s_id from score where c_id in ('01'))
	and s.s_id in (select s_id from score where c_id in ('02'))
)


# 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息

select st.*
from student st 
where st.s_id in (
	select s_id 
	from score s 
	where s.s_id in (select s_id from score where c_id = '01')
	  and s.s_id not in (select s_id from score where c_id = '02')
)


# 11、查询没有学全所有课程的同学的信息

select st.*
from student st 
where st.s_id not in (
	select s_id 
	from score s 
	where s.s_id in (select s_id from score where c_id = '01')
	  and s.s_id in (select s_id from score where c_id = '02') 
		and s.s_id in (select s_id from score where c_id = '03')
)


# 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息

select st.*
from student st 
where st.s_id in (
	select s_id 
	from score s 
	where s.s_id in (select s_id from score where c_id in (select c_id from score where s_id = '01'))
)

# 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息

select * from student where s_id in (
select s_id 
from score 
group by s_id
having GROUP_CONCAT(c_id) = (select GROUP_CONCAT(c_id) 
from score 
where s_id = '01'
group by s_id)) and s_id <> '01'


# 14、查询没学过"张三"老师讲授的任一门课程的学生姓名

select * from student where s_id not in (
select s_id 
from score s 
left join course c on s.c_id = c.c_id 
left join teacher t on t.t_id = c.t_id 
where t_name = '张三'
)


# 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩

select st.*, round(avg(s1.s_score),2) as '平均成绩'
from student st 
left join score s1 on st.s_id = s1.s_id  
where s_score < 60 
group by s1.s_id 
having count(c_id) >= 2


# 16、检索"01"课程分数小于60，按分数降序排列的学生信息

select st.* 
from student st 
left join score s1 on st.s_id = s1.s_id  
where s_score < 60 and c_id = '01'
order by s_score desc 


# 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩

select st.s_id, s1.s_score, round((avg(s1.s_score) over (PARTITION BY s1.s_id)),2) as avg
from score s1 
left join course c on c.c_id = s1.c_id
left join student st on st.s_id = s1.s_id 
group by s1.s_id,s1.s_score
order by avg desc, s1.s_score desc 


# 18、查询各科成绩最高分、最低分和平均分：
# 以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率，及格为>=60，
# 中等为：70-80，优良为：80-90，优秀为：>=90

select c.c_id, c.c_name, 
max(s_score) as '最高分',
min(s_score) as '最低分',
round(avg(s_score),2) as '平均分',
concat(round((count(case when s_score >= 60 then 1 else null end) / count(s_score)* 100),2)  , '%') as '及格率',
round((count(case when s_score >= 70 and s_score < 80 then 1 else null end) / count(s_score)),2) as '中等率',
round((count(case when s_score >= 80 and s_score < 90 then 1 else null end) / count(s_score)),2) as '优良率',
round((count(case when s_score >= 90 then 1 else null end) / count(s_score)),2) as '优秀率'
from score s 
left join course c on s.c_id = c.c_id 
group by c.c_id, c.c_name


# 19、按各科成绩进行排序，并显示排名
# mysql8.0以上才有rank函数
select s_id, s_score, rank() over(order by s_score desc) as rank1 
from score 


# 20、查询学生的总成绩并进行排名
select s_id, sum(s_score) as s, rank() over(order by sum(s_score) desc) as pm from score
group by s_id


# 21、查询不同老师所教不同课程平均分从高到低显示

select c_id, round(avg(s_score),2) as avg
from score 
group by c_id


# 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩

select * from (
select s_id, s_score, rank() over(order by s_score desc) as r
from score
) as s
where r between 2 and 3


# 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比

select c.c_id, c.c_name, 
count(case when s_score <60 then 1 else null end) / count(s_score) as '[0-60]',
count(case when s_score <70 and s_score >=60 then 1 else null end) / count(s_score) as '[60-70]',
count(case when s_score <85 and s_score >=70 then 1 else null end) / count(s_score) as '[70-85]',
count(case when s_score >=85 then 1 else null end) / count(s_score) as '[100-85]'
from score s  
left join course c on c.c_id = s.c_id 
group by c.c_id,c.c_name


# 24、查询学生平均成绩及其名次 

select s_id, round(avg(s_score),2) as 'avg', rank() over(order by round(avg(s_score),2) desc) as r
from score
group by s_id


# 25、查询各科成绩前三名的记录

select * from (
select s_id, c.c_id,c.c_name,s.s_score, rank() over(PARTITION BY c.c_id  order by s_score desc) as 'pm'
from course c 
left join score s on c.c_id = s.c_id 
group by c.c_id,s_id,c.c_name,s.s_score 
order by c_id, s_score desc) s
where pm <= 3


# 26、查询每门课程被选修的学生数
select c.c_id,c.c_name,count(s.s_score) 
from course c 
left join score s on c.c_id = s.c_id 
group by c.c_id 


# 27、查询出只有两门课程的全部学生的学号和姓名
select st.*, count(s.s_score) as '课程数'
from student st  
left join score s on st.s_id = s.s_id 
group by st.s_id 
having count(s.s_score) = 2


# 28、查询男生、女生人数 

select count(case when s1.s_sex = '男' then 1 else null end) as '男生人数', 
count(case when s1.s_sex = '女' then 1 else null end) as '女生人数'
from student s1 

# 29、查询名字中含有"风"字的学生信息
select * 
from student 
where s_name like '%风%'


# 30、查询同名同性学生名单，并统计同名人数 
select s_name,count(s_name) as '同名人数'
from student 
group by s_name 
having count(s_name) > 1


# 31、查询1990年出生的学生名单 
select *
from student 
where year(s_birth) = 1990 


# 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 

select c.c_id, round(avg(s_score), 2)
from score s left join course c on s.c_id = c.c_id 
group by c.c_id
order by avg(s_score) desc, c.c_id 

# 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
select st.s_id, st.s_name, round(avg(s.s_score),2) as 'avg' 
from student st 
left join score s on st.s_id = s.s_id 
group by st.s_id 
having avg > 85


# 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
select st.s_name, s.s_score  
from student st 
left join score s on s.s_id = st.s_id 
left join course c on s.c_id = c.c_id 
where c.c_name = '数学' and s.s_score < 60


# 35、查询所有学生的课程及分数情况；

select st.s_name, c.c_name, s.s_score 
from student st 
left join score s on s.s_id = st.s_id 
left join course c on c.c_id = s.c_id 

# 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数

select st.s_name, c.c_name, s.s_score 
from student st 
left join score s on st.s_id = s.s_id 
left join course c on s.c_id = c.c_id 
where s.s_score > 70

# 37、查询不及格的课程
select * from score where s_score < 60 

# 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 
select distinct st.s_id, st.s_name  
from student st 
left join score s on st.s_id = s.s_id 
where c_id = '01' and s.s_score > 80

# 39、求每门课程的学生人数 
select c.c_id, count(s_score) 
from course c 
left join score s on c.c_id = s.c_id 
group by c.c_id 

# 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

select st.*, s.s_score  
from student st 
left join score s on st.s_id = s.s_id 
where s.s_score = (
select max(s_score)
from score s 
left join course c on s.c_id = c.c_id 
left join teacher t on t.t_id = c.t_id 
where t.t_name = '张三' )

# 如果有最高分是相同的人，则这里就会有问题
select * 
from student st 
left join score s on st.s_id = s.s_id 
left join course c on s.c_id = c.c_id 
left join teacher t on t.t_id = c.t_id 
where t.t_name = '张三' 
order by s_score desc 
limit 1;


# 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
select distinct s1.s_id,s1.c_id,s1.s_score 
from score s1 
inner join score s2 on s1.s_id = s2.s_id and s1.c_id <> s2.c_id and s1.s_score = s2.s_score

# 42、查询每门功成绩最好的前两名 
select s_id,c_id,s_score from (
select s_id,c_id, s_score , rank() over(PARTITION BY c_id  order by s_score desc) ra
from score s 
) as a where ra <= 2

# 43、统计每门课程的学生选修人数（超过5人的课程才统计）。
# 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列  

select c_id, count(s_score) as c 
from score s 
group by c_id 
having c > 5
order by c desc, c_id

# 44、检索至少选修两门课程的学生学号 

select s_id
from score 
group by s_id
having count(s_score) >= 2


# 45、查询选修了全部课程的学生信息 
select s_id,count(s_id)
from score 
group by s_id
having count(s_id) = (select count(c_id) from course) 

# 46、查询各学生的年龄

select *,TIMESTAMPDIFF(year, s_birth, curdate()) as '年龄'
from student 

# 47、查询本周过生日的学生

select * 
from student 
where DATE_FORMAT(s_birth,'%m-%d') BETWEEN DATE_FORMAT(date_sub(curdate(), interval weekday(curdate()) day ),'%m-%d') and DATE_FORMAT(date_add(curdate(), interval 6 - weekday(curdate()) day ) ,'%m-%d')


# 49、查询本月过生日的学生

select *
from student 
where month(s_birth) = month(CURDATE())

# 50、查询下月过生日的学生

select *
from student 
where month(s_birth) = month(CURDATE()) + 1





