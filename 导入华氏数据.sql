USE [主数据库]
GO
/****** Object:  StoredProcedure [dbo].[导入华氏数据]    Script Date: 2018-03-30 13:14:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[导入华氏数据]

AS
BEGIN

declare @今日日期 int
set @今日日期 = day(getdate())

	
	truncate table 导入数据库.dbo.华氏商品对照表



--insert into 导入数据库.dbo.华氏商品对照表(ARTIID,ARTICODE,RETAILPRICE,STAXRATE,BULKSALEPRICE)
-- select *  from openquery(HSLSDB,'select ARTIID,ARTICODE,RETAILPRICE,STAXRATE,BULKSALEPRICE from WXLINK.TBB_ARTICLE') 

select * into #aa from openquery(HSLSDB,'select ARTIID,
ARTICODE,
artiname,
artiabbr,
ARTISPEC,
ARTIUNIT,
MANUFACTORY,
STAXRATE,
RETAILPRICE,
goods_buyer,
goods_manager from WXLINK.TBB_ARTICLE ') 

--select * INTO #ii   from openquery(HSLSDB,'    select  companyid ,B.ARTIID,DISTPRICE1 as distprice1 from WXLINK.TBL_DEPT  A , WXLINK.TBD_STKCOST
--B WHERE A.DEPTID = B.DEPTID AND COMPANYID  in （3000,4000,5000,6000,7000,1000,2000）  AND DISTPRICE1 >0
--')

--select companyid ,ARTIID,round(avg(DISTPRICE1),2) as distprice1 INTO #bb   from #ii 
--GROUP BY  companyid,ARTIID

select *   INTO #bb   from openquery(HSLSDB,'    select  companyid ,B.ARTIID,round(avg(DISTPRICE1),2) as distprice1 from WXLINK.TBL_DEPT  A , WXLINK.TBD_STKCOST
B WHERE A.DEPTID = B.DEPTID AND  COMPANYID < 8000  AND DISTPRICE1 >0
group by companyid ,B.ARTIID')



--select * INTO #jj  from openquery(LYSDB,'    select  companyid,DEPTTYPEID ,B.ARTIID,DISTPRICE1 as distprice1 from WXLINK.TBL_DEPT  A , WXLINK.TBD_STKCOST
--B WHERE A.DEPTID = B.DEPTID AND COMPANYID = 8000  AND DISTPRICE1 >0 and DEPTTYPEID<>62
--')

--select companyid,DEPTTYPEID ,ARTIID,round(avg(DISTPRICE1),2) as distprice1 INTO #cc   from #jj
--GROUP BY  companyid,DEPTTYPEID ,ARTIID

select * INTO #cc  from openquery(LYSDB,'    select  companyid,DEPTTYPEID ,B.ARTIID,round(avg(DISTPRICE1),2) as distprice1 from WXLINK.TBL_DEPT  A , WXLINK.TBD_STKCOST
B WHERE A.DEPTID = B.DEPTID AND COMPANYID = 8000  AND DISTPRICE1 >0 and DEPTTYPEID<>62
group by  companyid,DEPTTYPEID ,B.ARTIID
')


select * into #dd  from openquery(HSLSDB,'select artiid,b.Uncarticlassname from  WXLINK.Tbc_UncArticlassrela a ,WXLINK.tbc_uncarticlass b 
 where  a.Uncarticlasscode = b.Uncarticlasscode 
 and b.uncarticlasscode like ''08%'' ') 

select * into #ee   from openquery(HSLSDB,'   select * from WXLINK.v_tbc_uncarticlass_lines ')

select *  into #gg from openquery(HSLSDB,'select  artiid,uncarticlassname from  WXLINK.Tbc_UncArticlassrela a ,WXLINK.tbc_uncarticlass b 
 where  a.Uncarticlasscode = b.Uncarticlasscode  and
b.uncarticlassname = ''医保品种'' ') 

select a.ARTIID AS 商品id,articode as 商品编码,artiname as 商品名称 ,artiabbr as 商品名,
artispec as 商品规格, artiunit as 计量单位 ,manufactory as 厂家, staxrate/100 as 税率,REtailprice as 零售价,
classname4 as 商品线大类,classname6 as 商品线中类,classname8 as 商品线小类,classname10 as 商品线次小类,
d.uncarticlassname as 商品经营类型,f.uncarticlassname as 医保类型,
b.distprice1 as 华氏直营配送价,g.distprice1 as 西部配送价,h.distprice1 as 崇明配送价,
i.distprice1 as 杨浦配送价,j.distprice1 as 北区配送价,k.distprice1 as 华氏加盟配送价,l.distprice1 as 批发配送价,c.distprice1 as 雷允上直营配送价,
m.distprice1 as 雷允上加盟配送价,
goods_buyer as 采购员,goods_manager as 商品经理
into #ff
from #aa as a LEFT OUTER join #bb as b on a.artiid =b.artiid and b.COMPANYID = 2000
LEFT OUTER join #bb as g on a.artiid =g.artiid and g.COMPANYID = 3000
LEFT OUTER join #bb as h on a.artiid =h.artiid and h.COMPANYID = 4000
LEFT OUTER join #bb as i on a.artiid =i.artiid and i.COMPANYID = 5000
LEFT OUTER join #bb as j on a.artiid =j.artiid and j.COMPANYID = 6000
LEFT OUTER join #bb as k on a.artiid =k.artiid and k.COMPANYID = 7000
LEFT OUTER join #bb as l on a.artiid =l.artiid and l.COMPANYID = 1000
LEFT OUTER join #cc as c on a.artiid =c.artiid and c.DEPTTYPEID = 60
LEFT OUTER join #cc as m on a.artiid =m.artiid and m.DEPTTYPEID = 61
LEFT OUTER join #dd as d on a.artiid =d.artiid
LEFT OUTER join #ee as e on a.artiid =e.artiid
LEFT OUTER join #gg as f on a.artiid =f.artiid

insert into [导入数据库].[dbo].[华氏商品对照表]([商品id]
      ,[商品编码]
      ,[商品名称]
      ,[商品名]
      ,[商品规格]
      ,[计量单位]
      ,[厂家]
      ,[税率]
      ,[零售价]
      ,[商品线大类]
      ,[商品线中类]
      ,[商品线小类]
      ,[商品线次小类]
      ,[商品经营分类]
      ,[医保类型]
      ,[华氏直营配送价]
      ,[西部配送价]
      ,[崇明配送价]
      ,[杨浦配送价]
      ,[北区配送价]
      ,[华氏加盟配送价]
      ,[批发配送价]
      ,[雷允上直营配送价]
      ,[雷允上加盟配送价]
      ,[采购员]
      ,[商品经理])
select [商品id]
      ,[商品编码]
      ,[商品名称]
      ,[商品名]
      ,[商品规格]
      ,[计量单位]
      ,[厂家]
      ,[税率]
      ,[零售价]
      ,[商品线大类]
      ,[商品线中类]
      ,[商品线小类]
      ,[商品线次小类]
      ,[商品经营类型]
      ,[医保类型]
      ,[华氏直营配送价]
      ,[西部配送价]
      ,[崇明配送价]
      ,[杨浦配送价]
      ,[北区配送价]
      ,[华氏加盟配送价]
      ,[批发配送价]
      ,[雷允上直营配送价]
      ,[雷允上加盟配送价]
      ,[采购员]
      ,[商品经理]
	  from #ff

drop table #aa
drop table #bb
drop table #cc
drop table #dd
drop table #ee
drop table #ff
drop table #gg
--drop table #ii
--drop table #jj

select *  into #hh from openquery(HSLSDB,'    select  COMP_GOODS_ID AS ARTIID,APPRAISAL_PRICE
from  WXLINK.SYS_GOODS_APPRAISAL_PRICE WHERE COMP_PARTY_ID = 2000')


update [导入数据库].[dbo].[华氏商品对照表]
set 考核价 = APPRAISAL_PRICE
from  [导入数据库].[dbo].[华氏商品对照表] as a inner join #hh as b on a.商品id = b.ARTIID

update [导入数据库].[dbo].[华氏商品对照表]
set 考核价 = 华氏直营配送价
from  [导入数据库].[dbo].[华氏商品对照表] as a
where 考核价 is null

update [导入数据库].[dbo].[华氏商品对照表]
set 考核毛利额 = iif(零售价=0,0,零售价/(税率+1)-考核价),
考核价毛利率 = iif(零售价 = 0 ,0,(1-(考核价/(零售价/(税率+1))))*100)
from  [导入数据库].[dbo].[华氏商品对照表] as a 

drop table #hh





 truncate table 导入数据库.dbo.华氏总部库存
  --truncate table 导入数据库.dbo.总部库存对照表

 --  insert into 导入数据库.dbo.总部库存对照表(ARTIID,STKQTY)
 --  select *   from openquery(HSLSDB,' SELECT ARTIID,SUM(STKQTY) STKQTY
 --   FROM WXLINK.V_TBD_STKLOC_BULK
 --      GROUP BY ARTIID')

 --insert into 导入数据库.dbo.华氏总部库存(ARTIID,STKQTY)
 -- select  CONVERT(nvarchar(40),ARTIID) as ARTIID,
 --      CONVERT(decimal(18,2),stkqty) as stkqty  from 导入数据库.dbo.总部库存对照表


	      insert into 导入数据库.dbo.华氏总部库存(ARTIID2,STKQTY)
   select *   from openquery(HSLSDB,' SELECT ARTIID,SUM(STKQTY) STKQTY
    FROM WXLINK.V_TBD_STKLOC_BULK
       GROUP BY ARTIID')

	   update 导入数据库.dbo.华氏总部库存
	   set ARTIID = CONVERT(nvarchar(40),ARTIID2)

truncate table 导入数据库.dbo.华氏门店对照表

insert into 导入数据库.dbo.华氏门店对照表(DEPTID,DEPTNO,DEPTNAME,DEPTTYPEID,SETTLEMANID)
select DEPTID,DEPTNO,DEPTNAME,DEPTTYPEID,SETTLEMANID
 from HSLSDB..WXLINK
 .TBL_DEPT




-- truncate table 导入数据库.dbo.华氏资信额度

-- INSERT into 导入数据库.dbo.华氏资信额度  (DEPTID,TRUSTAMT)
--    select *  from openquery
--	(HSLSDB,'select WXBULK.TBL_DEPT.DEPTID,WXBULK.TBL_DEPT.TRUSTAMT from WXBULK.TBL_DEPT,WXBULK.TBL_SETTLEMAN 
--	WHERE WXBULK.TBL_SETTLEMAN.SETTLEMANID = WXBULK.TBL_DEPT.SETTLEMANID') 

--update 导入数据库.dbo.华氏门店对照表
--set TRUSTAMT = b.TRUSTAMT
--from 导入数据库.dbo.华氏门店对照表 as a inner join 导入数据库.dbo.华氏资信额度 as b on a.DEPTID = b.DEPTID




--truncate table 导入数据库.dbo.华氏门店库存对照表

--insert into 导入数据库.dbo.华氏门店库存对照表(DEPTID,ARTIID,TOLQTY,BATCHCODE,VALIDDATE,COSTAMT)
-- select *  from openquery
-- (HSLSDB,'select DEPTID,ARTIID,STKQTY,BATCHCODE,VALIDDATE,COSTAMT from WXLINK.TBD_STKLOC where 
-- STKQTY > 0') 

 


truncate table 导入数据库.dbo.导入华氏库存

--insert into [导入数据库].[dbo].[导入华氏库存] ([门店编码]
--      ,[门店名称]
--      ,[商品编码]
--	  ,总金额
--      ,[实际数量]
--      ,[批号]
--      ,[效期]
--	  ,成本金额)
-- select b.deptno,b.deptname,商品编码,tolqty*零售价,tolqty as saleprice,batchcode,validdate,costamt
-- from 导入数据库.dbo.华氏门店库存对照表 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  
--inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id
----inner join 导入数据库.dbo.华氏直营门店目录 as d on a.deptid = d.deptid  
----where tolqty > 0

insert into [导入数据库].[dbo].[导入华氏库存] (deptid
      ,artiid
      ,[实际数量]
      ,[批号]
      ,[效期]
	  ,成本金额)
	   select *  from openquery
 (HSLSDB,'select DEPTID,ARTIID,STKQTY,BATCHCODE,VALIDDATE,COSTAMT from WXLINK.TBD_STKLOC where 
 STKQTY > 0') 

update [导入数据库].[dbo].[导入华氏库存]
set 门店编码 = b.deptno
from [导入数据库].[dbo].[导入华氏库存] as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  

update [导入数据库].[dbo].[导入华氏库存]
set 商品编码 = c.商品编码,总金额 =实际数量*零售价
from [导入数据库].[dbo].[导入华氏库存] as a inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id


update [导入数据库].[dbo].[导入华氏库存]
set 效期 = '2001-1-1'
where 效期 < '2001-1-1'

update [导入数据库].[dbo].[导入华氏库存]
set 效期 = '2040-12-31'
where 效期 > '2040-12-31'

delete from [导入数据库].[dbo].[导入华氏库存] where 门店编码 = 'TEST'
delete from [导入数据库].[dbo].[导入华氏库存] where 门店编码 is null
delete from [导入数据库].[dbo].[导入华氏库存] where 商品编码 is null


--truncate table  导入数据库.dbo.华氏调拨对照表
truncate table  导入数据库.dbo.导入华氏调拨
truncate table  导入数据库.dbo.华氏店际调拨对照表
truncate table  导入数据库.dbo.华氏店际调拨对象表

--insert into  导入数据库.dbo.华氏调拨对照表(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID)
--select *   from openquery
--(HSLSDB,'select SHIFTDATE,DEPTID,ARTIID,ARTIQTY,(COSTAMT+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID 
--from WXLINK.TBD_DISTRIBUTE
-- WHERE SHIFTDATE > (SYSDATE-14) ') 

-- insert into  导入数据库.dbo.华氏调拨对照表(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
--select *   from openquery
--(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
--from wxbulk.TBD_DISTRIBUTE a 
-- WHERE outdate > (SYSDATE-40) and BussStatus >=10  ')

-- insert into  导入数据库.dbo.华氏调拨对照表(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
-- select *   from openquery
--(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
--from wx_pszx.TBD_DISTRIBUTE a 
-- WHERE outdate > (SYSDATE-40) and BussStatus >=10  ')

----  insert into  导入数据库.dbo.华氏调拨对照表(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
----select *   from openquery
----(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
----from wx_pszx.TBD_DISTRIBUTE a 
---- WHERE outdate > (SYSDATE-40) and BussStatus >=10  ')

--insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,b.DEPTno,ARTIcode,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
--select OUTDATE,b.DEPTno,商品编码,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml  
--from 导入数据库.dbo.华氏调拨对照表 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  
--inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id
----inner join 导入数据库.dbo.华氏直营门店目录 as d on a.deptid = d.deptid  
-- where outdate is not null

if @今日日期 = 28

begin

 insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
select *   from openquery
(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
from wxbulk.TBD_DISTRIBUTE a 
 WHERE outdate > (SYSDATE-80) and BussStatus >=10  ')

  insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
 select *   from openquery
(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
from wx_pszx.TBD_DISTRIBUTE a 
 WHERE outdate > (SYSDATE-80) and BussStatus >=10  ')
 end

 else

 begin
 insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
select *   from openquery
(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
from wxbulk.TBD_DISTRIBUTE a 
 WHERE outdate > (SYSDATE-3) and BussStatus >=10  ')

  insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,DEPTID,ARTIID,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,pzml )
 select *   from openquery
(HSLSDB,'select outdate ,DEPTID,ARTIID,-(ARTIQTY) as artiqty,-(SaleAmt+TAXAMT) AS COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,BussStatus,(saleamt - costamt)*-1 as pzml
from wx_pszx.TBD_DISTRIBUTE a 
 WHERE outdate > (SYSDATE-3) and BussStatus >=10  ')
 end

  update 导入数据库.dbo.导入华氏调拨
set DEPTno = b.DEPTno
from
导入数据库.dbo.导入华氏调拨 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  

  update 导入数据库.dbo.导入华氏调拨
set ARTIcode = c.商品编码
from
导入数据库.dbo.导入华氏调拨 as a inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id


--  update 导入数据库.dbo.导入华氏调拨
--set 类别 = '自主请货'
--where  BUSSEVENTID = 400
--print '更新自主请货标记完成'

 update 导入数据库.dbo.导入华氏调拨
set 类别 = '自主请货'
where  BUSSEVENTID = 40
print '更新自主请货标记完成'

update 导入数据库.dbo.导入华氏调拨
set 类别 = '退货'
where BUSSEVENTID = 50
print '更新退货标记完成'

if @今日日期 = 28

begin

insert into 导入数据库.dbo.华氏店际调拨对照表(OUTDATE,INDEPTID,ARTIID,TRANQTY,COSTAMT,OUTTAXAMT,BATCHCODE,VALIDDATE,TRANNO,BUSSEVENTID,OUTDEPTID,pzml)
select *   from openquery
(HSLSDB,'select OUTDATE,INDEPTID,ARTIID,TRANQTY,COSTAMT,OUTTAXAMT,BATCHCODE,VALIDDATE,TRANNO,BUSSEVENTID,OUTDEPTID,0 as pzml  from WXLINK.TBM_ARTITRANS
 WHERE OUTDATE > (SYSDATE-80)') 

 end

 else

 begin

insert into 导入数据库.dbo.华氏店际调拨对照表(OUTDATE,INDEPTID,ARTIID,TRANQTY,COSTAMT,OUTTAXAMT,BATCHCODE,VALIDDATE,TRANNO,BUSSEVENTID,OUTDEPTID,pzml)
select *   from openquery
(HSLSDB,'select OUTDATE,INDEPTID,ARTIID,TRANQTY,COSTAMT,OUTTAXAMT,BATCHCODE,VALIDDATE,TRANNO,BUSSEVENTID,OUTDEPTID,0 as pzml  from WXLINK.TBM_ARTITRANS
 WHERE OUTDATE > (SYSDATE-3)') 

 end

 update 导入数据库.dbo.华氏店际调拨对照表
 set costamt = COSTAMT+OUTTAXAMT
 from 导入数据库.dbo.华氏店际调拨对照表 as a inner join 导入数据库.dbo.华氏商品对照表 as b on a.artiid = b.商品id 
 where outtaxamt is not null

  update 导入数据库.dbo.华氏店际调拨对照表
 set costamt = COSTAMT * (1+税率)
 from 导入数据库.dbo.华氏店际调拨对照表 as a inner join 导入数据库.dbo.华氏商品对照表 as b on a.artiid = b.商品id 
 where outtaxamt is  null

insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,b.DEPTno,ARTIcode,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,pzml)
select [OUTDATE] ,b.[DEPTNO],c.[商品编码],[TRANQTY],[COSTAMT],[BATCHCODE],[VALIDDATE],[TRANNO],[BUSSEVENTID] ,pzml
from 导入数据库.dbo.华氏店际调拨对照表 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.indeptid = b.deptid  
inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id 
--inner join 导入数据库.dbo.华氏直营门店目录 as d on a.indeptid = d.deptid  
 where outdate is not null


 update 导入数据库.dbo.导入华氏调拨
set 类别 = '调入'
where 类别 is null
print '更新调入标记完成'


insert into 导入数据库.dbo.导入华氏调拨(OUTDATE,b.DEPTno,ARTIcode,ARTIQTY, COSTAMT,BATCHCODE,VALIDDATE,REQSHTNO,BUSSEVENTID,pzml)
select [OUTDATE] ,b.[DEPTno],c.[商品编码],[TRANQTY] * -1,[COSTAMT] * -1,[BATCHCODE],[VALIDDATE],[TRANNO],[BUSSEVENTID],pzml * -1
from 导入数据库.dbo.华氏店际调拨对照表 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.outdeptid = b.deptid  
inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id
--inner join 导入数据库.dbo.华氏直营门店目录 as d on a.indeptid = d.deptid  
 where outdate is not null

  update 导入数据库.dbo.导入华氏调拨
set 类别 = '调出'
where 类别 is null
print '更新调出标记完成'

--drop table 导入数据库.dbo.华氏未开票配送

--select CONVERT(varchar(20),reqshtno) as reqshtno  
--into 导入数据库.dbo.华氏未开票配送
-- from openquery
--(HSLSDB,'select distinct REQSHTNO
--from wxbulk.TBD_DISTRIBUTE a 
-- WHERE BussStatus =10  ')

if @今日日期 = 28

begin

 insert into 导入数据库.dbo.华氏店际调拨对象表(单据号,调入仓库,调出仓库)
select *  from openquery
(HSLSDB,'select distinct TRANNO,INDEPTID,OUTDEPTID  from WXLINK.TBM_ARTITRANS
 WHERE OUTDATE > (SYSDATE-62)')  as a 

 end

 else

 begin

 insert into 导入数据库.dbo.华氏店际调拨对象表(单据号,调入仓库,调出仓库)
select *  from openquery
(HSLSDB,'select distinct TRANNO,INDEPTID,OUTDEPTID  from WXLINK.TBM_ARTITRANS
 WHERE OUTDATE > (SYSDATE-3)')  as a 

 end

 update 导入数据库.dbo.华氏店际调拨对象表
 set 调出仓库 = b.DEPTNO
 from 导入数据库.dbo.华氏店际调拨对象表 as a
 inner join 导入数据库.dbo.华氏门店对照表 as b on a.调出仓库 = b.deptid

  update 导入数据库.dbo.华氏店际调拨对象表
 set 调入仓库 = b.DEPTNO
 from 导入数据库.dbo.华氏店际调拨对象表 as a
 inner join 导入数据库.dbo.华氏门店对照表 as b on a.调入仓库 = b.deptid

delete from 导入数据库.dbo.导入华氏调拨 where deptno = 'TEST'
delete from 导入数据库.dbo.导入华氏调拨 where deptno is null
delete from 导入数据库.dbo.导入华氏调拨 where ARTIcode is null



truncate table 导入数据库.dbo.华氏人员对照表
truncate table 导入数据库.dbo.华氏销售明细
truncate table 导入数据库.dbo.华氏销售对照表
truncate table  [导入数据库].[dbo].[华氏加工费]
truncate table  [导入数据库].[dbo].[华氏销售分类]


insert into 导入数据库.dbo.华氏人员对照表 (EMPID,DEPTID,EMPNO,EMPNAME,EMPDUTY)
select *  from openquery
(HSLSDB,'select EMPID,DEPTID,EMPNO,EMPNAME,EMPDUTY from WXLINK.TBL_EMPLOYEE') 


-------------------------------------------------------
--insert into 导入数据库.dbo.华氏销售对照表([TRANDATE] ,[CASHID],[ARTIID] ,[DEPTID] ,[ASSIID] ,[SALEQTY] ,[SALEAMT] ,[UNTAXAMT] ,[BATCHCODE] ,[VALIDDATE] ,[RETAILAMT],[YH],[COSTAMT] ,[TRANCOUNTID],APPRAISAL_PRICE)
--select *   from openquery
--(HSLSDB,'select TRANDATE,CASHID,ARTIID,DEPTID,ASSIID,(SALEQTY*-1) AS SALEQTY,(SALEAMT*-1) AS SALEAMT
--,(UNTAXPRICE*-1) AS UNTAXAMT,BATCHCODE,VALIDDATE,(RETAILAMT*-1) AS RETAILAMT,(RETAILAMT+SALEAMT)*-1 AS YH, (COSTAMT*-1) AS COSTAMT,TRANID,(APPRAISAL_PRICE*SALEQTY*-1) as APPRAISAL_PRICE
--from WXLINK.TBV_TRANDETAILCOUNT
-- WHERE TRANDATE > (SYSDATE-45)  ') 

-- update  导入数据库.dbo.华氏销售对照表
-- set APPRAISAL_PRICE = COSTAMT
-- where APPRAISAL_PRICE is null
-------------------------------------------------------

if @今日日期 = 28

begin

insert into 导入数据库.dbo.华氏销售对照表(countdate,[TRANDATE] ,[CASHID],[ARTIID] ,[DEPTID] ,[ASSIID] ,[SALEQTY] ,[SALEAMT] ,[UNTAXAMT] ,[BATCHCODE] ,[VALIDDATE] ,[RETAILAMT],[COSTAMT] ,[TRANCOUNTID],APPRAISAL_PRICE)
select *   from openquery
(HSLSDB,'select countdate,TRANDATE,CASHID,ARTIID,DEPTID,ASSIID,SALEQTY,SALEAMT
,TAXamt,BATCHCODE,VALIDDATE,RETAILAMT, COSTAMT,TRANID,APPRAISAL_PRICE
from WXLINK.TBV_TRANDETAILCOUNT
 WHERE countdate > (SYSDATE-80)  ') 

end

else

begin

insert into 导入数据库.dbo.华氏销售对照表(countdate,[TRANDATE] ,[CASHID],[ARTIID] ,[DEPTID] ,[ASSIID] ,[SALEQTY] ,[SALEAMT] ,[UNTAXAMT] ,[BATCHCODE] ,[VALIDDATE] ,[RETAILAMT],[COSTAMT] ,[TRANCOUNTID],APPRAISAL_PRICE)
select *   from openquery
(HSLSDB,'select countdate,TRANDATE,CASHID,ARTIID,DEPTID,ASSIID,SALEQTY,SALEAMT
,TAXamt,BATCHCODE,VALIDDATE,RETAILAMT, COSTAMT,TRANID,APPRAISAL_PRICE
from WXLINK.TBV_TRANDETAILCOUNT
 WHERE countdate > (SYSDATE-3)  ') 

end

  update  导入数据库.dbo.华氏销售对照表
 set APPRAISAL_PRICE = (APPRAISAL_PRICE*SALEQTY*-1)



  update  导入数据库.dbo.华氏销售对照表
 set SALEQTY = SALEQTY*-1,SALEAMT=SALEAMT*-1,
 RETAILAMT=RETAILAMT*-1,COSTAMT=COSTAMT*-1

  update  导入数据库.dbo.华氏销售对照表
 set APPRAISAL_PRICE = COSTAMT
 where APPRAISAL_PRICE is null or APPRAISAL_PRICE=0

  update  导入数据库.dbo.华氏销售对照表
 set UNTAXAMT=SALEAMT+UNTAXAMT

--insert into [导入数据库].[dbo].[华氏销售明细]( [零售时间]
--      ,[商品编码]
--      ,[门店编码]
--      ,[销售员]
--	  ,[收银员]
--      ,[数量]
--      ,[含税销售金额]
--      ,[无税销售金额]
--      ,[批号]
--      ,[效期]
--      ,[零售价金额]
--      ,[折让金额]
--      ,[考核毛利额]
--      ,[真实单据号])
--select [TRANDATE],[ARTIcode] ,b.[DEPTno] ,f.empname ,e.empname ,[SALEQTY] ,[SALEAMT] ,round([SALEAMT]/(1+c.STAXRATE/100),2) ,[BATCHCODE] ,[VALIDDATE] ,[RETAILAMT],[RETAILAMT]-saleamt,round([SALEAMT]/(1+c.STAXRATE/100)-[COSTAMT],2) ,[TRANCOUNTID]
--from 导入数据库.dbo.华氏销售对照表  as a  inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  
--inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.artiid
----inner join 导入数据库.dbo.华氏直营门店目录 as d on a.deptid = d.deptid  
--inner join 导入数据库.dbo.华氏人员对照表 as e on a.cashid = e.empid
--inner join 导入数据库.dbo.华氏人员对照表 as f on a.assiid = f.empid
----where trandate > '2015-2-27'

insert into [导入数据库].[dbo].[华氏销售明细]( 会计日,[零售时间]
      ,[商品编码]
      ,[门店编码]
      ,[销售员]
	  ,[收银员]
      ,[数量]
      ,[含税销售金额]
      ,[无税销售金额]
      ,[批号]
      ,[效期]
      ,[零售价金额]
      ,[折让金额]
      ,[考核毛利额]
      ,[真实单据号]
	  ,真实毛利额)
select countdate,[TRANDATE],[商品编码] ,b.[DEPTno] ,f.empname ,e.empname ,[SALEQTY] ,[SALEAMT] ,a.UNTAXAMt ,[BATCHCODE] ,[VALIDDATE] ,[RETAILAMT],[RETAILAMT]-saleamt,round(a.UNTAXAMt-APPRAISAL_PRICE,2) ,[TRANCOUNTID],round(a.UNTAXAMt-[COSTAMT],2)
from 导入数据库.dbo.华氏销售对照表  as a  inner join 导入数据库.dbo.华氏门店对照表 as b on a.deptid = b.deptid  
inner join 导入数据库.dbo.华氏商品对照表 as c on a.artiid = c.商品id
--inner join 导入数据库.dbo.华氏直营门店目录 as d on a.deptid = d.deptid  
inner join 导入数据库.dbo.华氏人员对照表 as e on a.cashid = e.empid
left outer  join 导入数据库.dbo.华氏人员对照表 as f on a.assiid = f.empid
--where trandate > '2015-2-27'

--update  导入数据库.dbo.华氏销售明细
--set 销售员 = '无'
--where 销售员 = '0'

--update  导入数据库.dbo.华氏销售明细
--set 销售员 = f.empname
--FROM [导入数据库].[dbo].[华氏销售明细]  as a  inner join 导入数据库.dbo.华氏人员对照表 as f on CONVERT(varchar(20),a.销售员) = CONVERT(varchar(20),f.empid)


delete from 导入数据库.dbo.华氏销售明细 where 会计日 >=convert(date,getdate(),14)

delete from 导入数据库.dbo.华氏销售明细 where 门店编码 = 'TEST'

delete from 导入数据库.dbo.华氏销售明细 where 真实单据号 is null

insert into  [导入数据库].[dbo].[华氏加工费]( [TRANDATE]
      ,[DEPTNO]
      ,[SERVICECODE]
      ,[SERVICEQTY]
      ,[SERVICEAMT]
      ,[TRANID])
  select *    from openquery
  (HSLSDB,'select trandate,deptno,
tbv_servicetype.servicecode,
tbv_tranService.Serviceqty,
tbv_tranService.Serviceamt
, tranid
from WXLINK.tbv_tranService ,WXLINK.tbv_servicetype ,WXLINK.tbl_dept
where TRANDATE > (SYSDATE-21) and tbv_tranService.Deptid=tbl_dept.Deptid
and tbv_tranService.servicetypeid =tbv_servicetype.servicetypeid
and tbv_tranService.BussStatus>=10
')  

insert into [导入数据库].[dbo].[华氏销售分类]( [DEPTID]
      ,[TRANID]
      ,[TRANTYPEID])
	  select * from openquery
(HSLSDB,'select deptid,tranid,trantypeid
from WXLINK.tbv_transaction
where trantypeid <> 1000 and trantypeid <> 2000 and trantypeid <> 0  ') 

drop table 导入数据库.dbo.销售分类表

select * into 导入数据库.dbo.销售分类表 from openquery
(HSLSDB,'select *
from WXLINK.tbv_trantype ') 

if
not exists (select distinct a.DEPTno,b.DEPTNAME from 导入数据库.dbo.导入华氏调拨 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.DEPTno = b.DEPTNO
 where a.DEPTno not in (select 门店编码 from 门店信息 where 公司 <> '雷允上')) 
 print '华氏数据无新门店'
 else
 select distinct a.DEPTno,b.DEPTNAME from 导入数据库.dbo.导入华氏调拨 as a inner join 导入数据库.dbo.华氏门店对照表 as b on a.DEPTno = b.DEPTNO
 where a.DEPTno not in (select 门店编码 from 门店信息 where 公司 <> '雷允上')





END
