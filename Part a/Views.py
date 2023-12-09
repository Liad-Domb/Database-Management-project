VIEWS_DICT = {
    "Q3":
[
"""CREATE VIEW class_family
AS
SELECT h.hID
FROM Households h
where h.size>=3 and h.netWorth>5;""",

"""CREATE VIEW hate_reality
AS SELECT  distinct h.hID
FROM Households h
EXCEPT
    (SELECT  distinct d.hID
     FROM Viewing v, Programs p, Devices d
    where v.dID=d.dID and v.pCode=p.pCode and p.genre ='Reality' );""",

"""CREATE VIEW family_with_class_and_hate_reality
AS
SELECT cf.hID
FROM class_family cf, hate_reality hr
where cf.hID=hr.hID;""",

"""CREATE VIEW family_devices
AS
SELECT fd2.hID, count(d.hID) as DevicesNum
FROM family_with_class_and_hate_reality fd2
left join Devices D on fd2.hID = D.hID
group by fd2.hID;"""
]
 ,
    "Q4":
        ["""Create view longest_program_in_genre
AS
SELECT distinct p1.pCode
from Programs p1
where p1.genre is not null and p1.duration >ALL(
    SELECT p2.duration
    from Programs p2
    where p2.genre=p1.genre and p1.pCode<>p2.pCode
    );""",

"""CREATE VIEW popular_program_new
AS
(SELECT popular_program_all.pCode
from
     (SELECT distinct d.hID ,lp.pCode
    FROM  longest_program_in_genre lp, Viewing v, Devices d
    where v.dID=d.dID and lp.pCode=v.pCode
    group by d.hID, lp.pCode) AS popular_program_all

group by popular_program_all.pCode
having count(*)>=3
);""",

"""CREATE VIEW modern_family
AS
(SELECT modern_family_all.hID
from
     (SELECT distinct d.hID ,ppn.pCode
FROM  popular_program_new ppn, Viewing v, Devices d
where v.dID=d.dID and ppn.pCode=v.pCode
group by d.hID, ppn.pCode) AS modern_family_all

group by modern_family_all.hID
having count(*)>=3
);""",

"""Create view Show_time_temp
    as
    (
    select MF.hID,p.title, v.eTime
    from modern_family MF, popular_program_new ppn, Programs p, Viewing v, Devices d
    where p.pCode=ppn.pCode and MF.hID=d.hID and d.dID=v.dID and v.pCode=ppn.pCode
    );""",

"""Create view Show_time
    as
    (
    select stt.hID,stt.title, stt.eTime
    from Show_time_temp stt
    where stt.eTime<= all(
        select stt2.eTime
        from Show_time_temp stt2
        where stt.hID=stt2.hID
             )
    );"""
]
    
}










