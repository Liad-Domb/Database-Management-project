------------------------------------------
--p1
create table Department(
    DEPname varchar(100) primary key ,
    DEPdescription varchar(100)
)

create table Employee(
    EID integer primary key ,
    Ename varchar(100),
    DEPname varchar(100) not null ,
    foreign key (DEPname)
        references Department on delete cascade
)

create table manager(
    EID integer primary key ,
    salary integer,
    foreign key (EID)
        references Employee on delete cascade
)

create table Technical_expert(
    EID integer primary key ,
    Specialty varchar(100),
    foreign key (EID)
        references Employee on delete cascade
)

create table Manage(
    EID integer,
    DEPname varchar(100) ,
    foreign key (EID)
        references manager,
    foreign key(DEPname)
        references Department on delete cascade,
    primary key(EID,DEPname)
)
--p2
create table Family(
    FID integer primary key ,
    Fname varchar(100) ,
    wealth_level integer
        check (wealth_level between 1 and 9),
)

create table Family_member(
    FMname varchar(100),
    phone integer,
    BirthDay date,
    FID integer,
    foreign key (FID) references Family on delete cascade,
    primary key(FID,FMname)
)
--At the DDL level, it is not possible to verify that the wealth level of a normal family is 6 or below.
create table Regular_family(
    FID integer primary key,
    foreign key(FID) references Family on delete cascade
)
--At the DDL level, it is not possible to verify that the wealth level of a premium family is 7 and above.
create table Premium_family(
    FID integer primary key,
    Technical_expert_EID integer,
    foreign key(FID) references Family on delete cascade,
    foreign key(Technical_expert_EID) references Technical_expert(EID)
)

--P3
create table Request(
    Rdate date primary key,
)

create table Logout_request(
    FID integer,
    Rdate date,
    EID integer,
    logout_cause varchar(50) not null ,
    final_result varchar(50) not null ,
    foreign key(FID) references Regular_family,
    foreign key (Rdate) references Request,
    foreign key(EID) references manager,
    primary key(FID,Rdate,EID)
)

create table Forward_request(
    FID integer,
    Rdate date,
    EID_from integer,
    EID_to integer,
    Forward_cause varchar(50),
    check (EID_from<>EID_to),
    foreign key (FID, Rdate, EID_from) references Logout_request,
    foreign key (EID_to) references manager,
    primary key(EID_from,FID,Rdate,EID_to)
)
--P4

--It is not possible to verify at the DDL level that a new converter that will be installed in any family will
-- get CID according to the installation order - this can be verified by a SQL query that will implement this.

--In addition, it is not possible to verify at the DDL level that each family has at least one converter
create table converter(
    CID integer,
    FID integer,
    foreign key(FID) references Family on delete cascade,
    primary key (FID,CID)
)

--It is not possible to verify at the DDL level that in the case of a converter fix - if the family is a
-- premium family, then the converter will be sent for fixing to the technical expert who is responsible for the care
-- of the family - this can be verified using an SQL query that will check whether the family is a premium family -
-- and if so, he will send the converter for fixing At the technical expert who is responsible for the family.
create table converter_fix(
    price integer,
    CID integer,
    FID integer,
    EID_expert integer not null ,
    foreign key (FID,CID) references converter,
    foreign key (EID_expert) references Technical_expert(EID),
    primary key(FID,CID)
)

--P5

create table channel(
    CHnum integer primary key,
    CHname varchar(100)
)

create table show(
    Sname varchar(100) primary key ,
    genre varchar(100),
    length float
        check(length>0)
)

create table screend_in(
    Sname varchar(100),
    CHnum integer,
    primary key(Sname,CHnum),
    foreign key (Sname) references show on delete cascade,
    foreign key (CHnum) references channel
)

--It is not possible to verify at the DDL level that each converter has at least one available channel
create table Channel_list(
        CHnum integer,
        CID integer,
        FID integer,
        foreign key(FID, CID) references converter on delete cascade,
        foreign key (CHnum) references channel,
        primary key (FID, CID, CHnum)
)

create table Time(
    exect_time datetime primary key
)

create table Broadcast_schedule(
    exect_time datetime,
    CHnum integer,
    Sname varchar(100),
    foreign key (Sname,CHnum) references screend_in on delete cascade ,
    foreign key (exect_time) references Time,
    primary key (exect_time,CHnum,Sname)
)
--Clarification: The meaning here is the converter and the channel to which the switch was made
create table change_channel(
        exect_time datetime,
        CHnum integer,
        CID integer,
        FID integer,
        foreign key (FID, CID, CHnum) references Channel_list,
        foreign key(exect_time) references Time,
        primary key (exect_time,CHnum,CID,FID)
)

--delete
drop table change_channel
drop table Broadcast_schedule
drop table Time
drop table Channel_list
drop table screend_in
drop table show
drop table channel
drop table converter_fix
drop table converter
drop table Forward_request
drop table Logout_request
drop table Request
drop table Premium_family
drop table Regular_family
drop table Family_member
drop table Family
drop table Manage
drop table Technical_expert
drop table manager
drop table Employee
drop table Department

--------------------------------------------------------------