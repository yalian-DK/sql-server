USE [财务服务器]
GO
/****** Object:  StoredProcedure [dbo].[门店收入核对]    Script Date: 2018-03-29 10:22:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[门店收入核对]
	
AS
BEGIN

declare
@今日日期 date

select @今日日期 =convert(date,getdate(),14)

declare
@数据更新日期 date

select @数据更新日期 = '2017-11-15'
--(select min(distinct 日期) from
--报表服务器.dbo.财务002银行pos机收入差异 )

 drop table 报表服务器.dbo.财务001新增pos机终端号 
drop table 报表服务器.dbo.财务002银行pos机收入差异 
drop table 报表服务器.dbo.财务003pos收入入账清单
drop table 报表服务器.dbo.财务004卡到日收入差异 
drop table 报表服务器.dbo.财务005卡销售到日入账清单 
drop table 报表服务器.dbo.财务006卡销售到日异常明细 
drop table 报表服务器.dbo.财务007现金到日收入差异 
drop table 报表服务器.dbo.财务008雷允上新增pos机终端号 
drop table 报表服务器.dbo.财务009雷允上银行pos机收入差异
drop table 报表服务器.dbo.财务010雷允上pos收入入账清单
drop table 报表服务器.dbo.财务011现金销售到日入账清单
drop table 报表服务器.dbo.财务012现金解款质量情况

insert into 财务服务器.dbo.pos机门店对照表
(公司,门店编码,终端号)
SELECT '华氏', 门店编码,终端号
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
pos对照表
where 终端号 not in (select 终端号 from 财务服务器.dbo.pos机门店对照表 where 公司 = '华氏')

insert into 财务服务器.dbo.pos机门店对照表
(公司,门店编码,终端号)
SELECT '雷允上', 门店编码,终端号
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
雷允上pos对照表
where 终端号 not in (select 终端号 from 财务服务器.dbo.pos机门店对照表 where 公司 = '雷允上')

SELECT distinct '华氏' as 公司,消费日期 as 日期,终端号
into #导入pos数据临时表
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
pos数据



delete 财务服务器.dbo.pos数据 from 财务服务器.dbo.pos数据 as a inner join  #导入pos数据临时表 as b
on a.公司 = b.公司 and a.日期 = b.日期 and a.终端号 = b.终端号


insert into 财务服务器.dbo.pos数据
(公司,日期,终端号,消费金额,手续费,结算金额)
SELECT '华氏',消费日期,终端号,消费金额,手续费,结算金额
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
pos数据

SELECT distinct '雷允上' as 公司,消费日期 as 日期,终端号
into #导入pos数据临时表2
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
雷允上pos数据



delete 财务服务器.dbo.pos数据 from 财务服务器.dbo.pos数据 as a inner join  #导入pos数据临时表2 as b
on a.公司 = b.公司 and a.日期 = b.日期 and a.终端号 = b.终端号


insert into 财务服务器.dbo.pos数据
(公司,日期,终端号,消费金额,手续费,结算金额)
SELECT '雷允上',消费日期,终端号,消费金额,手续费,结算金额
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
雷允上pos数据

SELECT distinct '华氏' as 公司, 日期,门店编码  into #删除pos调节表
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
调整银行pos金额 where 日期 is not null


delete 财务服务器.dbo.调整银行pos数据 from 财务服务器.dbo.调整银行pos数据 as a inner join #删除pos调节表
 as b on a.公司 = b.公司 and a.日期 = b.日期 and a.门店编码
  = b.门店编码


insert into 财务服务器.dbo.调整银行pos数据
(公司,日期,门店编码,银行pos金额)
SELECT '华氏',日期,门店编码,银行pos金额
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
调整银行pos金额 where 日期 is not null

SELECT distinct '雷允上' as 公司, 日期,门店编码  into #删除pos调节表2
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
雷允上调整银行pos金额 where 日期 is not null


delete 财务服务器.dbo.调整银行pos数据 from 财务服务器.dbo.调整银行pos数据 as a inner join #删除pos调节表2
 as b on a.公司 = b.公司 and a.日期 = b.日期 and a.门店编码
  = b.门店编码


insert into 财务服务器.dbo.调整银行pos数据
(公司,日期,门店编码,银行pos金额)
SELECT '雷允上',日期,门店编码,银行pos金额
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
雷允上调整银行pos金额 where 日期 is not null

delete 财务服务器.dbo.卡销售到日 where 日期 in (
SELECT distinct 日期
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
卡销售到日 where 日期 is not null)


insert into 财务服务器.dbo.卡销售到日
(日期,门店编码,消费金额,类型)
SELECT 日期,门店编码,金额,类型
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
卡销售到日 where 日期 is not null


delete from 导入收入名称表

insert into 导入收入名称表(cashtypeid,cashtypename)
  select *   from openquery(HSLSDB,'select  cashtypeid,cashtypename from  WXLINK.Tbv_cashtype  ') 

  select  *  into #更新日期临时表 from openquery(HSLSDB,'select distinct trandate from  WXLINK.Tbv_trancashcount  WHERE 
 trandate >= (SYSDATE-40)  ') where trandate > '2017-11-14' and trandate >= @数据更新日期



  delete  财务服务器.dbo.导入收入明细表 from 财务服务器.dbo.导入收入明细表 as a inner join #更新日期临时表 as b on a.trandate = b.trandate

 insert into 财务服务器.dbo.导入收入明细表 (deptid,cashtypeid,trandate,countamt)
  select  *   from openquery(HSLSDB,'select  deptid,cashtypeid,trandate,countamt from  WXLINK.Tbv_trancashcount  WHERE 
 trandate >= (SYSDATE-40) ') where trandate > '2017-11-14' and trandate >= @数据更新日期

  insert into 财务服务器.dbo.导入收入明细表 (deptid,cashtypeid,trandate,countamt)
  select  *   from openquery(LYSDB,'select  deptid,cashtypeid,trandate,countamt from  WXLINK.Tbv_trancashcount  WHERE 
 trandate >= (SYSDATE-40)  ') where trandate > '2017-11-14' and trandate >= @数据更新日期


 delete 门店付款方式明细  from 门店付款方式明细 as a inner join #更新日期临时表 as b on a.日期 = b.trandate

 insert into 财务服务器.dbo.门店付款方式明细 (日期,门店编码,付款方式,金额)
 select convert(date,a.trandate) as 日期,convert(nvarchar(20),c.DEPTNO) as 门店编码
 ,convert(nvarchar(20),cashtypename) as 付款方式,convert(numeric(18, 2), countamt) as 金额
 from 财务服务器.dbo.导入收入明细表 as a inner join 导入收入名称表 as b on a.cashtypeid = b.cashtypeid
 inner join 导入数据库.dbo.华氏门店对照表 as c on a.deptid = c.deptid 
 inner join  #更新日期临时表 as d on a.trandate = d.trandate




  SELECT distinct [解款日期]
      ,[门店编码]
      ,[销售日期]
      ,[银行代码] into #现金解款临时表
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
现金到日 where 解款日期 is not null

delete 财务服务器.dbo.现金到日明细 from 财务服务器.dbo.现金到日明细 as a inner join  #现金解款临时表 as b 
on a.解款日期 = b.解款日期 and a.门店编码 = b.门店编码 and a.销售日期 = b.销售日期 and a.银行代码 = b.银行代码


 insert into 财务服务器.dbo.现金到日明细
 ( [解款日期]
      ,[门店编码]
      ,[销售日期]
      ,[金额]
      ,[银行代码])
 SELECT [解款日期]
      ,[门店编码]
      ,[销售日期]
      ,sum([金额]) as 金额
      ,[银行代码]
FROM OpenDataSource
( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
现金到日 where 解款日期 is not null and 销售日期 < @今日日期
group by [解款日期]
      ,[门店编码]
      ,[销售日期]
      ,[银行代码]




-- delete 财务服务器.dbo.门店付款方式明细 where 日期 in (
--SELECT distinct 销售日期
--FROM OpenDataSource
--( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
--付款方式)

--insert into 财务服务器.dbo.门店付款方式明细
--( [日期]
--      ,[门店编码]
--      ,[合计销售金额]
--      ,[现金]
--      ,[分币误差]
--      ,[医保卡]
--      ,[OK卡]
--      ,[得仕卡]
--      ,[健康商务（绿）]
--      ,[杉德卡]
--      ,[益企保]
--      ,[银联POS]
--      ,[转账]
--      ,[阿里健康]
--      ,[脱机OK卡]
--      ,[脱机银联卡]
--      ,[微信]
--      ,[医卡通]
--      ,[支付宝]
--      ,[万达直付保]
--      ,[普康卡]
--      ,[斯玛特卡]
--      ,[健保通卡]
--      ,[京东到家]
--      ,[平安卡]
--      ,[企健网]
--      ,[商银通]
--      ,[银联二维码]
--      ,[银联刷卡UMS]
--      ,[银联钱包]
--      ,[销售收入]
--      ,[会员卡消费]
--      ,[索迪斯卡]
--      ,[卖场收款]
--      ,[外保卡]
--      ,[健康商务（蓝）]
--      ,[劳保处方])
--SELECT  [销售日期]
--      ,[门店编码]
--      ,[合计销售金额]
--      ,[现金]
--      ,[分币误差]
--      ,[医保卡]
--      ,[OK卡]
--      ,[得仕卡]
--      ,[健康商务（绿）]
--      ,[杉德卡]
--      ,[益企保]
--      ,[银联POS]
--      ,[转账]
--      ,[阿里健康]
--      ,[脱机OK卡]
--      ,[脱机银联卡]
--      ,[微信]
--      ,[医卡通]
--      ,[支付宝]
--      ,[万达直付保]
--      ,[普康卡]
--      ,[斯玛特卡]
--      ,[健保通卡]
--      ,[京东到家]
--      ,[平安卡]
--      ,[企健网]
--      ,[商银通]
--      ,[银联二维码]
--      ,[银联刷卡UMS]
--      ,[银联钱包]
--      ,[销售收入]
--      ,[会员卡消费]
--      ,[索迪斯卡]
--      ,[卖场收款]
--      ,[外保卡]
--      ,[健康商务（蓝）]
--      ,[劳保处方]
--FROM OpenDataSource
--( 'Microsoft.ACE.OLEDB.16.0','Data Source="e:\datebase\门店收入核对.accdb";User ID=Admin;Password=')...
--付款方式

 ----------------------------------------------------------------------------
 
 --select 日期,医保合并编码,b.医保合并名称,sum(银联POS+脱机银联卡) as pos销售 
 -- into #合并到日付款方式
 --  from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 --on a.门店编码 = b.门店编码
 --where 日期 >=  dateadd(DAY,-40,@今日日期) and 公司 = '华氏'
 --group by 日期,医保合并编码,b.医保合并名称
 --having sum(银联POS+脱机银联卡)>0

   DELETE 
  from  pos数据 where 日期 is null

 --------------------------------------------------------------------------------------------------------------------------------------
 --财务001新增pos机终端号


 select a.*  into 报表服务器.dbo.财务001新增pos机终端号 
  from pos数据 as a left outer join pos机门店对照表 as b on a.终端号 = b.终端号
  where b.终端号 is null

  ----------------------------------------------------------------------------------------------------------------
  --财务002银行pos机收入差异 

  select 日期,医保合并编码,b.医保合并名称,sum(金额) as pos销售 
  into #合并到日付款方式
   from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 日期 >=  dateadd(DAY,-40,@今日日期) and 
 公司 = '华氏' AND 付款方式 in ('银联POS','脱机银联卡')
 group by 日期,医保合并编码,b.医保合并名称


 select 日期,门店编码,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into #合并pos数据
  from pos数据 as a inner join pos机门店对照表 as b on a.终端号 = b.终端号
 where 日期 >=  dateadd(DAY,-40,@今日日期) and a.公司 = '华氏'
 group by 日期,门店编码

 insert into #合并pos数据(日期,门店编码,消费金额,手续费,结算金额)
 select b.日期,b.门店编码,0,0,0 from #合并pos数据 as a right outer join 调整银行pos数据 as b on a.日期 = b.日期 and a.门店编码 = b.门店编码
 where a.日期 is null and b.公司 = '华氏'

 select b.日期 as 日期,门店编码,a.医保合并名称 as 门店名称,isnull(pos销售,0) as 万信pos销售,消费金额 as 银行pos金额,(消费金额 -isnull(pos销售,0)  ) as 差异
 into 报表服务器.dbo.财务002银行pos机收入差异 
  FROM  #合并到日付款方式 as a right outer join #合并pos数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  where (消费金额 -isnull(pos销售,0)  ) <>0
  order by (消费金额 -isnull(pos销售,0)  )  desc

  update 报表服务器.dbo.财务002银行pos机收入差异 
  set 银行pos金额 = a.银行pos金额 + b.银行pos金额 
  from 报表服务器.dbo.财务002银行pos机收入差异 as a inner join 调整银行pos数据 as b
  on a.日期 = b.日期 and a.门店编码 = b.门店编码

    update 报表服务器.dbo.财务002银行pos机收入差异 
  set 差异 = 银行pos金额 - isnull(万信pos销售,0)


  ALTER TABLE 报表服务器.dbo.财务002银行pos机收入差异 
ADD   差异类型  nvarchar(30)  null

  update 报表服务器.dbo.财务002银行pos机收入差异 
  set 差异类型 = '有差异'


  update 报表服务器.dbo.财务002银行pos机收入差异 
  set 差异类型 = '万信无'
  where 万信pos销售 = 0

 insert into 报表服务器.dbo.财务002银行pos机收入差异
   select a.日期 as 日期,医保合并编码 as 门店编码,a.医保合并名称 as 门店名称,isnull(pos销售,0) as 万信pos销售,isnull(消费金额,0) as 银行pos金额,(isnull(消费金额,0)  -isnull(pos销售,0)  ) as 差异 
   ,'银行无' as 差异类型
  FROM  #合并到日付款方式 as a left outer join #合并pos数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  where b.日期 is null and (isnull(消费金额,0)  -isnull(pos销售,0)  )<>0 and isnull(消费金额,0) =0
  order by (isnull(消费金额,0)  -isnull(pos销售,0)  ) desc

  update 报表服务器.dbo.财务002银行pos机收入差异
  set 门店名称 = 医保合并名称
  from 报表服务器.dbo.财务002银行pos机收入差异 as a inner join 主数据库.dbo.门店信息 as b 
  on a.门店编码 = b.门店编码

   delete from 报表服务器.dbo.财务002银行pos机收入差异 where 日期 > (select max(日期) from pos数据 where 公司 = '华氏')

      delete from 报表服务器.dbo.财务002银行pos机收入差异 where 差异 = 0




 -------------------------------------------------------------------------------------------------------------------
 --财务003pos收入入账清单

    select 日期,门店编码,a.终端号,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into #合并pos数据2
  from pos数据 as a inner join pos机门店对照表 as b on a.终端号 = b.终端号
 where 日期 >=  dateadd(DAY,-40,@今日日期)  and a.公司 = '华氏'
 group by 日期,门店编码,a.终端号


  select 日期,a.门店编码+医保合并名称 as 门店,终端号,消费金额,手续费,结算金额 
  into 报表服务器.dbo.财务003pos收入入账清单
  from #合并pos数据2 as a INNER join 主数据库.dbo.门店信息 as b on a.门店编码 = b.门店编码
  where 日期 >=  dateadd(DAY,-40,@今日日期) 
 
-----------------------------------------------------------------------------------------------------
--财务004卡到日收入差异

 update 卡销售到日
 set 手续费 = round(消费金额 * 费率/100,4)
 from 卡销售到日 as a inner join 卡费率 as b on a.类型 = b.类型
 where 手续费 is null

  update 卡销售到日
 set 结算金额 = round(消费金额 - 手续费,4)
 where 结算金额 is null


   select 日期,医保合并编码,b.医保合并名称,大类 as 卡种类,sum(金额) as 拉卡金额
  into #合并到日付款方式2
   from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 inner join 卡费率 as c on a.付款方式 = c.类型 and 分类 = '到日'
 where 日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 日期 >= (select min(日期) from 卡销售到日) and b.类型 <> '加盟'
 group by 日期,医保合并编码,b.医保合并名称,大类

  select 日期,b.医保合并编码 as 门店编码,c.大类 as 卡种类,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into #合并卡到日数据
  from 卡销售到日 as a inner join 主数据库.dbo.门店信息 as b on a.门店编码 = b.门店编码 
   inner join 卡费率 as c on a.类型 = c.类型 and 分类 = '到日'
 where 日期 >=  dateadd(DAY,-40,@今日日期) and
 公司 = '华氏' and b.类型 <> '加盟'
 group by 日期,b.医保合并编码,c.大类

 select b.日期 as 日期,门店编码 as 门店编码,a.医保合并名称 as 门店名称,b.卡种类,isnull(拉卡金额,0) as 万信拉卡金额,消费金额 as 平台拉卡金额,(消费金额 -isnull(拉卡金额,0)  ) as 差异
 into 报表服务器.dbo.财务004卡到日收入差异 
  FROM  #合并到日付款方式2 as a right outer join #合并卡到日数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  and a.卡种类 = b.卡种类
  where (消费金额 -isnull(拉卡金额,0)  ) <>0
  order by (消费金额 -isnull(拉卡金额,0)  )  desc

  --update 报表服务器.dbo.财务002银行pos机收入差异 
  --set 银行pos金额 = a.银行pos金额 + b.银行pos金额 
  --from 报表服务器.dbo.财务002银行pos机收入差异 as a inner join 调整银行pos数据 as b
  --on a.日期 = b.日期 and a.门店编码 = b.门店编码

  --  update 报表服务器.dbo.财务002银行pos机收入差异 
  --set 差异 = 银行pos金额 - isnull(万信pos销售,0)


  ALTER TABLE 报表服务器.dbo.财务004卡到日收入差异 
ADD   差异类型  nvarchar(30)  null

  update 报表服务器.dbo.财务004卡到日收入差异 
  set 差异类型 = '有差异'

  
  update 报表服务器.dbo.财务004卡到日收入差异 
  set 差异类型 = '万信无'
  where 万信拉卡金额 = 0



   insert into 报表服务器.dbo.财务004卡到日收入差异 
 select a.日期 as 日期,a.医保合并编码 as 门店编码,a.医保合并名称 as 门店名称,a.卡种类,isnull(拉卡金额,0) as 万信拉卡金额,isnull(消费金额,0) as 平台拉卡金额,(isnull(消费金额,0) -isnull(拉卡金额,0)  ) as 差异
    ,'平台无' as 差异类型
  FROM  #合并到日付款方式2 as a left outer join #合并卡到日数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  and a.卡种类 = b.卡种类
  where (isnull(消费金额,0) -isnull(拉卡金额,0)  ) <>0 and isnull(消费金额,0) =0
  order by (isnull(消费金额,0) -isnull(拉卡金额,0)  )  desc


  update 报表服务器.dbo.财务004卡到日收入差异
  set 门店名称 = 医保合并名称
  from 报表服务器.dbo.财务004卡到日收入差异 as a inner join 主数据库.dbo.门店信息 as b 
  on a.门店编码 = b.门店编码

   delete from 报表服务器.dbo.财务004卡到日收入差异 where 日期 > (select max(日期) from 卡销售到日)

      delete from 报表服务器.dbo.财务004卡到日收入差异 where 差异 = 0

	   -------------------------------------------------------------------------------------------------------------------
 --财务005卡销售到日入账清单 



  select 日期,a.门店编码+医保合并名称 as 门店,卡种类,消费金额,手续费,结算金额 
  into 报表服务器.dbo.财务005卡销售到日入账清单 
  from #合并卡到日数据 as a
  inner join 主数据库.dbo.门店信息 as b on a.门店编码 = b.门店编码

  --------------------------------------------------------------------------------------------------------------------
  --报表服务器.dbo.财务006卡销售到日异常明细 


    select 日期,a.门店编码,门店名称,a.类型 as 卡种类,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into 报表服务器.dbo.财务006卡销售到日异常明细 
  from 卡销售到日 as a inner join 主数据库.dbo.门店信息 as b on a.门店编码 = b.门店编码 
 where 日期 >=  dateadd(DAY,-40,@今日日期) and(
 公司 <> '华氏' or b.类型 = '加盟')
 group by 日期,a.门店编码,门店名称,a.类型

 -----------------------------------------------------------------------------------------------------
--财务007现金到日收入差异


    select 日期,医保合并编码,b.医保合并名称,sum(金额) as 现金金额
 into #现金到日付款方式
   from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 日期 >= (select min(销售日期) from 现金到日明细) and b.类型 <> '加盟'
 and 付款方式 = '现金'
 group by 日期,医保合并编码,b.医保合并名称



     select 销售日期 as 日期,医保合并编码,b.医保合并名称,sum(金额) as 现金金额
	into #现金到日明细
   from 财务服务器.dbo.现金到日明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 销售日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 销售日期 >= (select min(销售日期) from 现金到日明细) and b.类型 <> '加盟'
 group by 销售日期,医保合并编码,b.医保合并名称



 select b.日期 as 日期,b.医保合并编码,b.医保合并名称 as 门店名称,isnull(a.现金金额,0) as 万信现金金额,b.现金金额 as 现金解款金额,(b.现金金额 -isnull(a.现金金额,0)  ) as 差异
 into 报表服务器.dbo.财务007现金到日收入差异 
  FROM  #现金到日付款方式 as a right outer join #现金到日明细 as b on a.日期 = b.日期 and a.医保合并编码 = b.医保合并编码
  where (b.现金金额 -isnull(a.现金金额,0)  ) <>0
  order by (b.现金金额 -isnull(a.现金金额,0)  )  desc


--  --update 报表服务器.dbo.财务002银行pos机收入差异 
--  --set 银行pos金额 = a.银行pos金额 + b.银行pos金额 
--  --from 报表服务器.dbo.财务002银行pos机收入差异 as a inner join 调整银行pos数据 as b
--  --on a.日期 = b.日期 and a.门店编码 = b.门店编码

--  --  update 报表服务器.dbo.财务002银行pos机收入差异 
--  --set 差异 = 银行pos金额 - isnull(万信pos销售,0)


  ALTER TABLE 报表服务器.dbo.财务007现金到日收入差异 
ADD   差异类型  nvarchar(30)  null

  update 报表服务器.dbo.财务007现金到日收入差异 
  set 差异类型 = '有差异'

  
  update 报表服务器.dbo.财务007现金到日收入差异 
  set 差异类型 = '万信无'
  where 万信现金金额 = 0



   insert into 报表服务器.dbo.财务007现金到日收入差异 
 select a.日期 as 日期,a.医保合并编码,a.医保合并名称 as 门店名称,isnull(a.现金金额,0) as 万信现金金额,isnull(b.现金金额,0) as 现金解款金额,(isnull(b.现金金额,0) -isnull(a.现金金额,0)  ) as 差异
    ,'解款单无' as 差异类型
  FROM  #现金到日付款方式 as a left outer join #现金到日明细 as b on a.日期 = b.日期 and a.医保合并编码 = b.医保合并编码
  --where (isnull(b.现金金额,0) -isnull(a.现金金额,0)  ) <>0 and isnull(b.现金金额,0) =0
  where  isnull(b.现金金额,0) =0
  order by (isnull(b.现金金额,0) -isnull(a.现金金额,0)  )  desc


--  update 报表服务器.dbo.财务004卡到日收入差异
--  set 门店名称 = 医保合并名称
--  from 报表服务器.dbo.财务004卡到日收入差异 as a inner join 主数据库.dbo.门店信息 as b 
--  on a.门店编码 = b.门店编码

   delete from 报表服务器.dbo.财务007现金到日收入差异  where 日期 > (select max(销售日期) from 现金到日明细)
   and 差异类型 <> '解款单无'



      delete from 报表服务器.dbo.财务007现金到日收入差异 where 差异 = 0



  --------------------------------------------------------------------------------------------------------------------------------------
 --财务008雷允上新增pos机终端号


 select a.*  into 报表服务器.dbo.财务008雷允上新增pos机终端号 
  from pos数据 as a left outer join pos机门店对照表 as b on a.终端号 = b.终端号
  where b.终端号 is null and a.公司 = '雷允上'

  ----------------------------------------------------------------------------------------------------------------
  --财务009雷允上银行pos机收入差异 

  select 日期,医保合并编码,b.医保合并名称,sum(金额) as pos销售 
  into #雷允上合并到日付款方式
   from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 日期 >=  dateadd(DAY,-40,@今日日期) and 
 公司 = '雷允上' AND 付款方式 in ('银联POS','脱机银联卡') and 类型 <> '加盟'
 group by 日期,医保合并编码,b.医保合并名称


 select 日期,门店编码,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into #雷允上合并pos数据
  from pos数据 as a inner join pos机门店对照表 as b on a.终端号 = b.终端号
 where 日期 >=  dateadd(DAY,-40,@今日日期) and a.公司 = '雷允上'
 group by 日期,门店编码

 insert into #合并pos数据(日期,门店编码,消费金额,手续费,结算金额)
 select b.日期,b.门店编码,0,0,0 from #雷允上合并pos数据 as a right outer join 调整银行pos数据 as b on a.日期 = b.日期 and a.门店编码 = b.门店编码
 where a.日期 is null  and b.公司 = '雷允上'

 select b.日期 as 日期,门店编码,a.医保合并名称 as 门店名称,isnull(pos销售,0) as 万信pos销售,消费金额 as 银行pos金额,(消费金额 -isnull(pos销售,0)  ) as 差异
 into 报表服务器.dbo.财务009雷允上银行pos机收入差异 
  FROM  #雷允上合并到日付款方式 as a right outer join #雷允上合并pos数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  where (消费金额 -isnull(pos销售,0)  ) <>0
  order by (消费金额 -isnull(pos销售,0)  )  desc

  update 报表服务器.dbo.财务009雷允上银行pos机收入差异 
  set 银行pos金额 = a.银行pos金额 + b.银行pos金额 
  from 报表服务器.dbo.财务009雷允上银行pos机收入差异 as a inner join 调整银行pos数据 as b
  on a.日期 = b.日期 and a.门店编码 = b.门店编码

    update 报表服务器.dbo.财务009雷允上银行pos机收入差异 
  set 差异 = 银行pos金额 - isnull(万信pos销售,0)


  ALTER TABLE 报表服务器.dbo.财务009雷允上银行pos机收入差异 
ADD   差异类型  nvarchar(30)  null

  update 报表服务器.dbo.财务009雷允上银行pos机收入差异 
  set 差异类型 = '有差异'


  update 报表服务器.dbo.财务009雷允上银行pos机收入差异 
  set 差异类型 = '万信无'
  where 万信pos销售 = 0

 insert into 报表服务器.dbo.财务009雷允上银行pos机收入差异
   select a.日期 as 日期,医保合并编码 as 门店编码,a.医保合并名称 as 门店名称,isnull(pos销售,0) as 万信pos销售,isnull(消费金额,0) as 银行pos金额,(isnull(消费金额,0)  -isnull(pos销售,0)  ) as 差异 
   ,'银行无' as 差异类型
  FROM  #雷允上合并到日付款方式 as a left outer join #雷允上合并pos数据 as b on a.日期 = b.日期 and a.医保合并编码 = b.门店编码
  where b.日期 is null and (isnull(消费金额,0)  -isnull(pos销售,0)  )<>0 and isnull(消费金额,0) =0
  order by (isnull(消费金额,0)  -isnull(pos销售,0)  ) desc

  update 报表服务器.dbo.财务009雷允上银行pos机收入差异
  set 门店名称 = 医保合并名称
  from 报表服务器.dbo.财务009雷允上银行pos机收入差异 as a inner join 主数据库.dbo.门店信息 as b 
  on a.门店编码 = b.门店编码

   delete from 报表服务器.dbo.财务009雷允上银行pos机收入差异 where 日期 > (select max(日期) from pos数据 where 公司 = '雷允上')

      delete from 报表服务器.dbo.财务009雷允上银行pos机收入差异 where 差异 = 0




 -------------------------------------------------------------------------------------------------------------------
 --财务010雷允上pos收入入账清单

    select 日期,门店编码,a.终端号,sum(消费金额) as 消费金额,sum(手续费) as 手续费,sum(结算金额) as 结算金额 
 into #雷允上合并pos数据2
  from pos数据 as a inner join pos机门店对照表 as b on a.终端号 = b.终端号
 where 日期 >=  dateadd(DAY,-40,@今日日期)  and
  a.公司 = '雷允上'
 group by 日期,门店编码,a.终端号


  select 日期,a.门店编码+医保合并名称 as 门店,终端号,消费金额,手续费,结算金额 
  into 报表服务器.dbo.财务010雷允上pos收入入账清单
  from #雷允上合并pos数据2 as a INNER join 主数据库.dbo.门店信息 as b on a.门店编码 = b.门店编码
  where 日期 >=  dateadd(DAY,-40,@今日日期) and 类型 <> '加盟'
 
 --------------------------------------------------------------------------------------------------------------------------
  --财务011现金销售到日入账清单 



      select 日期,b.医保合并编码+医保合并名称 as 门店,'万信数据' as 类型,sum(金额) as 现金金额
	 into 报表服务器.dbo.财务011现金销售到日入账清单
   from 财务服务器.dbo.门店付款方式明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 日期 >= (select min(销售日期) from 现金到日明细) and b.类型 <> '加盟'
 and 付款方式 = '现金'
 group by 日期,b.医保合并编码+医保合并名称


    insert into 报表服务器.dbo.财务011现金销售到日入账清单
	(日期,门店,类型,现金金额)
     select 销售日期,b.医保合并编码+医保合并名称 as 门店,'解款单' as 类型,sum(金额) as 现金金额
   from 财务服务器.dbo.现金到日明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 销售日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 销售日期 >= (select min(销售日期) from 现金到日明细) and b.类型 <> '加盟'
 group by 销售日期,b.医保合并编码+医保合并名称



 --------------------------------------------------------------------------------------------------------------------------
 --财务012现金解款质量情况
 
 select 医保合并编码+医保合并名称 as 医保合并名称,count(distinct 解款日期) as 解款次数,count(distinct 销售日期) as 已解款销售天数,
 40-count(distinct 销售日期) as 未解款销售天数
 into 报表服务器.dbo.财务012现金解款质量情况
 from 财务服务器.dbo.现金到日明细 as a  inner join 主数据库.dbo.门店信息 as b 
 on a.门店编码 = b.门店编码
 where 销售日期 >=  dateadd(DAY,-40,@今日日期) and  
 公司 = '华氏' and 销售日期 >= (select min(销售日期) from 现金到日明细) and b.类型 <> '加盟'
 group by 医保合并编码+医保合并名称

   ALTER TABLE 报表服务器.dbo.财务012现金解款质量情况
ADD   平均解款涉及天数  decimal(18, 2)  null

update 报表服务器.dbo.财务012现金解款质量情况
set 平均解款涉及天数 = round(convert(decimal(18, 2) ,已解款销售天数)/convert(decimal(18, 2) ,解款次数),2)
where 解款次数>0

insert into 报表服务器.dbo.财务012现金解款质量情况
select 医保合并编码+门店名称,0,0,40,999999 from 报表服务器.dbo.财务007现金到日收入差异 
where 差异类型 = '解款单无' and  日期 >=  dateadd(DAY,-40,@今日日期)
group by 医保合并编码+门店名称
having count(差异类型) = 40
---------------------------------------------------------------------------------------------------------------------


 print '删除临时表'
 drop table  #合并到日付款方式
 drop table #合并pos数据
  drop table #合并pos数据2
  drop table #更新日期临时表
  drop table #删除pos调节表
  drop table #合并到日付款方式2
drop table #合并卡到日数据
drop table #现金解款临时表
drop table #现金到日明细 
drop table #导入pos数据临时表
drop table  #雷允上合并到日付款方式
drop table #雷允上合并pos数据
drop table #雷允上合并pos数据2
drop table #导入pos数据临时表2
drop table #删除pos调节表2
--drop table #更新日期临时表2 

END
