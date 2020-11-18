-- ѧ����
create table student(
	s_id varchar(10),
	s_name varchar(20) not null default '',
	s_birth varchar(20) not null default '',
	s_sex varchar(10) not null default '��',
	primary key(s_id)
);

insert into student values('01' , '����' , '1990-01-01' , '��');
insert into Student values('02' , 'Ǯ��' , '1990-12-21' , '��');
insert into Student values('03' , '���' , '1990-05-20' , '��');
insert into Student values('04' , '����' , '1990-08-06' , '��');
insert into Student values('05' , '��÷' , '1991-12-01' , 'Ů');
insert into Student values('06' , '����' , '1992-03-01' , 'Ů');
insert into Student values('07' , '֣��' , '1989-07-01' , 'Ů');
insert into Student values('08' , '����' , '1990-01-20' , 'Ů');


-- �γ̱�
create table course(
	c_id VARCHAR(10),
	c_name VARCHAR(20) not null default '',
	t_id varchar(10) not null default '',
	primary key(c_id)
);
-- �γ̱��������
insert into Course values('01' , '����' , '02');
insert into Course values('02' , '��ѧ' , '01');
insert into Course values('03' , 'Ӣ��' , '03');

-- ��ʦ��
create table teacher(
	t_id varchar(10),
	t_name varchar(20) not null default '',
	primary key(t_id)
);
-- ��ʦ���������
insert into Teacher values('01' , '����');
insert into Teacher values('02' , '����');
insert into Teacher values('03' , '����');

-- �ɼ���
create table score(
	s_id varchar(10),
	c_id varchar(10),
	s_score varchar(10),
	primary key(s_id,c_id)
);
-- �ɼ����������
insert into Score values('01' , '01' , 80);
insert into Score values('01' , '02' , 90);
insert into Score values('01' , '03' , 99);
insert into Score values('02' , '01' , 70);
insert into Score values('02' , '02' , 60);
insert into Score values('02' , '03' , 80);
insert into Score values('03' , '01' , 80);
insert into Score values('03' , '02' , 80);
insert into Score values('03' , '03' , 80);
insert into Score values('04' , '01' , 50);
insert into Score values('04' , '02' , 30);
insert into Score values('04' , '03' , 20);
insert into Score values('05' , '01' , 76);
insert into Score values('05' , '02' , 87);
insert into Score values('06' , '01' , 31);
insert into Score values('06' , '03' , 34);
insert into Score values('07' , '02' , 89);
insert into Score values('07' , '03' , 98);





