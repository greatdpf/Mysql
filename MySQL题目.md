MySQL 练习

```mysql
-- 1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数
-- 先查询student表得学生信息；在连接两次score表，分别查询课程01和课程02的信息;然后再筛选出01大于02的分数；
select 
	st.s_id as '学号', 
	st.s_name as '姓名', 
	st.s_birth as '学生生日', 
	st.s_sex as '学生性别',
	sc01.s_score as '课程01的成绩',
	sc02.s_score as '课程02的成绩'
from student st
join score sc01
on st.s_id = sc01.s_id and sc01.c_id = '01' -- 查询 01 课程的成绩
join score sc02
on sc01.s_id = sc02.s_id and sc02.c_id = '02' -- 查询 02 课程的成绩
where sc01.s_score > sc02.s_score;

-- 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数 
select 
	st.s_id as '学号', 
	st.s_name as '姓名', 
	st.s_birth as '学生生日', 
	st.s_sex as '学生性别',
	sc01.s_score as '课程01的成绩',
	sc02.s_score as '课程02的成绩'
from student st 
inner join score sc01
on st.s_id = sc01.s_id and sc01.c_id = '01' 
inner join score sc02
on st.s_id = sc02.s_id and sc02.c_id = '02'
where sc01.s_score  < sc02.s_score;

-- 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
-- 平均成绩保留两位小数
select s_id, sum(s_score), round(avg(s_score), 2)
from score
group by s_id;
-- 学生的信息以及平均成绩
select st.s_id as '学生编号', st.s_name as '学生姓名', round(avg(s_score), 2) as '平均成绩'
from student st
inner join score sc
on st.s_id = sc.s_id
group by st.s_id, st.s_name
having avg(sc.s_score) > 60

-- 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的) 
select st.s_id as '学生编号', st.s_name as '学生姓名', avg(sc.s_score) as '平均成绩'
from student st
left join score sc
on st.s_id = sc.s_id
group by st.s_id, st.s_name
having ifnull(avg(sc.s_score), 0) < 60
-- if函数：ifnull(column, a) 如果column 为空，则值为 a 
select st.s_id as '学生编号', st.s_name as '学生姓名', ifnull(avg(sc.s_score), 0) as '平均成绩'
from student st
left join score sc
on st.s_id = sc.s_id
group by st.s_id, st.s_name
having ifnull(avg(sc.s_score), 0) < 60

-- 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select st.s_id, st.s_name, count(sc.c_id), sum(sc.s_score)
from student st
left join score sc
on st.s_id = sc.s_id
group by st.s_id, st.s_name

-- 6、查询"李"姓老师的数量
select * from teacher;
select count(t_name) as '李姓老师的数量'
from teacher
where t_name like '李%'

-- 7、查询学过"张三"老师授课的同学的信息
select st.*, co.c_name, t.t_name
from student st 
inner join score sc 
on st.s_id = sc.s_id
inner join course co
on sc.c_id = co.c_id
inner join teacher t
on co.t_id = t.t_id
where t.t_name = '张三'

select * 
from teacher t
inner join course co
on co.t_id = t.t_id
inner join score sc 
on sc.c_id = co.c_id
inner join student st
on st.s_id = sc.s_id
where t.t_name = '张三'

select a.* from 
    student a 
    join score b on a.s_id=b.s_id where b.c_id in(
        select c_id from course where t_id =(
            select t_id from teacher where t_name = '张三'));


-- 8、查询没学过"张三"老师授课的同学的信息 
-- 查找张三老师的id
select * from teacher where t_name in ('张三');
-- 查找张三老师教课的课程的id
select * from course where t_id in (select t_id from teacher where t_name in ('张三'))
-- 查找报了这门课的同学分数
select * from score where c_id in (select c_id from course where t_id in (select t_id from teacher where t_name in ('张三')));
-- 查找除这门课以外的同学分数！
select * from student where s_id not in (select s_id from score where c_id in (select c_id from course where t_id in (select t_id from teacher where t_name in ('张三'))));



-- 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息 
select * from course where c_id = '01' or c_id = '02';
select * from score where c_id in (select c_id from course where c_id = '01' or c_id = '02');
select * from student where s_id in (select s_id from score where c_id in (select c_id from course where c_id = '01' or c_id = '02'));

select * 
from student st
inner join score sc
on st.s_id = sc.s_id 
where sc.c_id in any(select c_id from course where t_id in (select t_id from teacher))



select * 
from student 
where s_id in (
	
)

-- 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息


-- 11、查询没有学全所有课程的同学的信息 
-- 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息 
-- 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息  
-- 14、查询没学过"张三"老师讲授的任一门课程的学生姓名 
-- 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩 
-- 16、检索"01"课程分数小于60，按分数降序排列的学生信息
-- 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
-- 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率，及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
-- 19、按各科成绩进行排序，并显示排名(实现不完全)
-- mysql没有rank函数
-- 20、查询学生的总成绩并进行排名

-- 21、查询不同老师所教不同课程平均分从高到低显示 
-- 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩 
-- 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比
-- 24、查询学生平均成绩及其名次 
-- 25、查询各科成绩前三名的记录
-- 26、查询每门课程被选修的学生数  
-- 27、查询出只有两门课程的全部学生的学号和姓名 
-- 28、查询男生、女生人数 
-- 29、查询名字中含有"风"字的学生信息
-- 30、查询同名同性学生名单，并统计同名人数 

-- 31、查询1990年出生的学生名单 
-- 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列 
-- 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩 
-- 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数 
-- 35、查询所有学生的课程及分数情况； 
-- 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数； 
-- 37、查询不及格的课程
-- 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名； 
-- 39、求每门课程的学生人数 
-- 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩

-- 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩 
-- 42、查询每门功成绩最好的前两名 
-- 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列  
-- 44、检索至少选修两门课程的学生学号 
-- 45、查询选修了全部课程的学生信息 
-- 46、查询各学生的年龄
-- 47、查询本周过生日的学生
-- 49、查询本月过生日的学生
-- 50、查询下月过生日的学生
```

