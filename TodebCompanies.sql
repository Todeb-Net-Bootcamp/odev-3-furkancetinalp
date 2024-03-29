USE [master]
GO
/****** Object:  Database [Todeb]    Script Date: 15.07.2022 22:20:03 ******/
CREATE DATABASE [Todeb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Todeb', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Todeb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Todeb_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Todeb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Todeb] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Todeb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Todeb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Todeb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Todeb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Todeb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Todeb] SET ARITHABORT OFF 
GO
ALTER DATABASE [Todeb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Todeb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Todeb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Todeb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Todeb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Todeb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Todeb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Todeb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Todeb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Todeb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Todeb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Todeb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Todeb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Todeb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Todeb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Todeb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Todeb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Todeb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Todeb] SET  MULTI_USER 
GO
ALTER DATABASE [Todeb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Todeb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Todeb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Todeb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Todeb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Todeb] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Todeb] SET QUERY_STORE = OFF
GO
USE [Todeb]
GO
/****** Object:  UserDefinedFunction [dbo].[func_CalculateEachCompanyTotalPrice]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_CalculateEachCompanyTotalPrice]
(
 --GİRİLEN PARA MİKTARININ HER KURULUŞTA İŞLEMDEN GEÇİRİLMESİ VE HER BİRİNDEKİ TOPLAM MALİYETLER
	@price float,
	@rate float
)
RETURNS FLOAT
AS
BEGIN
	
	DECLARE	@total float;
	set @total = @price+ (@price*(@rate/100));
	return @total
END
GO
/****** Object:  UserDefinedFunction [dbo].[func_Companies_CalculatePriceWithCommission]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_Companies_CalculatePriceWithCommission]
(
	@price decimal,
	@company_id int
	--KURULUŞ ID'si ve İŞLEM MİKTARI GİRİLEREK, YAPILMAK İSTENEN İŞLEMİN MALİYETİNİ HESAPLAYAN FONKSİYON--
	--EĞER İŞLEM MİKTARI SEÇİLEN KURULUŞUN MAKSİMUM İŞLEM LİMİTİNİ AŞMIŞSA, GİRİLEN DEĞER MAX İŞLEM LİMİTİ OLARAK DEĞİŞTİRİLİR
	--EĞER GİRİLEN ID DEĞERİNE SAHİP BİR KURULUŞ YOKSA KOMİSYON ORANI 0 OLARAK ATANIR.
)
RETURNS FLOAT
AS
BEGIN

	declare @total float;
	declare @rate float;
	declare @check int;
	
	Select @rate = dtl.CommissionRate
	from CompanyDetails AS dtl where dtl.CompanyId=@company_id

	if(@rate is Null)
		Set @rate=0;

	select @check = dtl.TransactionLimit
	from CompanyDetails AS dtl where dtl.CompanyId=@company_id

	if(@price>@check)
		SET @price=@check;

	set @total= @price+ (@price*@rate/100);
	RETURN @total;

END
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] NOT NULL,
	[CategoryName] [varchar](20) NULL,
 CONSTRAINT [PK_SirketKategorisi] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[CityId] [int] NOT NULL,
	[CityName] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Companies]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[CompanyId] [int] NOT NULL,
	[CompanyName] [varchar](60) NULL,
	[DateOfRegistration] [smalldatetime] NULL,
	[Category] [int] NULL,
	[City] [int] NULL,
	[WebSite] [varchar](30) NULL,
 CONSTRAINT [PK__Kurulusl__1A6B926DD6D6B4B1] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyDetails]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDetails](
	[CompanyId] [int] NOT NULL,
	[Address] [varchar](100) NULL,
	[EstablishedDate] [smalldatetime] NULL,
	[Phone] [varchar](11) NULL,
	[CommissionRate] [float] NULL,
	[TransactionLimit] [int] NULL,
 CONSTRAINT [PK_CompanyDetails] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TODEBCompaniesAndDetails]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TODEBCompaniesAndDetails]
--TÖDEB'e dahil olan şirketlerin genel bilgilerini veren bir 'VIEW'--
--Kurum adı, Kurumun Kategorisi(Elektronik Para veya Ödeme), Web Sayfası, Adresi, Telefon Numarası ve Bağlı Olunan Şehir--

AS
SELECT

	cmp.CompanyName,
	ctg.CategoryName,
	cmp.WebSite,
	cdtls.[Address],
	cdtls.Phone,
	cty.CityName

FROM [Companies] AS cmp
inner join [CompanyDetails] AS cdtls ON cmp.CompanyId=cdtls.CompanyId
inner join [Categories] AS ctg ON ctg.CategoryId=cmp.Category
inner join [Cities] AS cty ON cty.CityId=cmp.City
GO
/****** Object:  UserDefinedFunction [dbo].[func_CompanyDetails]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_CompanyDetails]
(
)
RETURNS TABLE
-- TABLO DÖNDÜREN FONKSİYON--
AS
RETURN 
(
	SELECT 
	cmp.CompanyName,
	ctg.CategoryName,
	cmp.WebSite,
	cty.CityName,
	dtl.CommissionRate,
	dtl.TransactionLimit


	FROM 
	[Companies] AS cmp
	inner join [CompanyDetails] AS dtl ON cmp.CompanyId=dtl.CompanyId
	inner join [Categories] AS ctg ON cmp.Category=ctg.CategoryId
	inner join [Cities] AS cty ON cmp.City = cty.CityId

)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Companies_ElektronikPara]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_Companies_ElektronikPara]
(
--TÖDEB'de 2 FARKLI KATEGORİDE KURULUŞLAR VARDIR: 1.ELEKTRONİK PARA, 2.ÖDEME KURULUŞLARI--
-- ELEKTRONİK PARA KURULUŞLARINI LİSTELEYEN FONKSİYON--
)
RETURNS TABLE
AS
RETURN
(
	SELECT cmp.CompanyName,
	ctg.CategoryName,
	dtl.Phone,
	dtl.EstablishedDate,
	dtl.CommissionRate,
	dtl.TransactionLimit,
	cmp.WebSite,
	dtl.[Address]

	FROM [Companies] AS cmp 
	inner join [CompanyDetails] AS dtl ON cmp.CompanyId=dtl.CompanyId
	inner join [Categories] AS ctg ON cmp.Category=ctg.CategoryId
	inner join [Cities] AS ct ON cmp.City=ct.CityId

	WHERE ctg.CategoryId=1
)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Companies_Odeme]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_Companies_Odeme]
(
--TÖDEB'de 2 FARKLI KATEGORİDE KURULUŞLAR VARDIR: 1.ELEKTRONİK PARA, 2.ÖDEME KURULUŞLARI--
-- ÖDEME KURULUŞLARINI LİSTELEYEN FONKSİYON--
)
RETURNS TABLE
AS
RETURN
(
	SELECT cmp.CompanyName,
	ctg.CategoryName,
	dtl.Phone,
	dtl.EstablishedDate,
	dtl.CommissionRate,
	dtl.TransactionLimit,
	cmp.WebSite,
	dtl.[Address]

	FROM [Companies] AS cmp 
	inner join [CompanyDetails] AS dtl ON cmp.CompanyId=dtl.CompanyId
	inner join [Categories] AS ctg ON cmp.Category=ctg.CategoryId
	inner join [Cities] AS ct ON cmp.City=ct.CityId

	WHERE ctg.CategoryId=2
)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Companies_DesiredCommissionRate]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_Companies_DesiredCommissionRate]
(	
--KULLANICIDAN GİRİLEN KOMİSYON ORANINA SAHİP TÖDEB KURULUŞLARINI LİSTELEYEN FONKSİYON
	@desired_rate float
)
RETURNS TABLE
AS
RETURN
(
	SELECT cmp.CompanyName,
	ctg.CategoryName,
	dtl.CommissionRate,
	dtl.TransactionLimit

	FROM [Companies] AS cmp 
	inner join [CompanyDetails] AS dtl ON cmp.CompanyId=dtl.CompanyId
	inner join [Categories] AS ctg ON cmp.Category=ctg.CategoryId
	inner join [Cities] AS ct ON cmp.City=ct.CityId

	WHERE dtl.CommissionRate=@desired_rate
)
GO
/****** Object:  UserDefinedFunction [dbo].[func_Companies_TransactionLimiter]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[func_Companies_TransactionLimiter]
(	
--KULLANICIDAN GİRİLEN İŞLEM LİMİTİNDE VE BU LİMİT ÜZERİNDE İŞLEM LİMİTİNE SAHİP KURULUŞLARI LİSTELEYEN FONKSİYON
	@transaction_limit float
)
RETURNS TABLE
AS
RETURN
(
	SELECT cmp.CompanyName,
	ctg.CategoryName,
	dtl.CommissionRate,
	dtl.TransactionLimit

	FROM [Companies] AS cmp 
	inner join [CompanyDetails] AS dtl ON cmp.CompanyId=dtl.CompanyId
	inner join [Categories] AS ctg ON cmp.Category=ctg.CategoryId
	inner join [Cities] AS ct ON cmp.City=ct.CityId

	WHERE dtl.TransactionLimit>=@transaction_limit
)
GO
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (1, N'Elektronik Para')
INSERT [dbo].[Categories] ([CategoryId], [CategoryName]) VALUES (2, N'Ödeme')
GO
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (1, N'Adana')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (2, N'Adıyaman')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (3, N'Afyon')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (4, N'Ağrı')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (5, N'Amasya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (6, N'Ankara')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (7, N'Antalya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (8, N'Artvin')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (9, N'Aydın')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (10, N'Balıkesir')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (11, N'Bilecik')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (12, N'Bingöl')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (13, N'Bitlis')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (14, N'Bolu')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (15, N'Burdur')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (16, N'Bursa')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (17, N'Çanakkale')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (18, N'Çankırı')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (19, N'Çorum')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (20, N'Denizli')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (21, N'Diyarbakır')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (22, N'Edirne')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (23, N'Elazığ')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (24, N'Erzincan')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (25, N'Erzurum')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (26, N'Eskişehir')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (27, N'Gaziantep')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (28, N'Giresun')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (29, N'Gümüşhane')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (30, N'Hakkari')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (31, N'Hatay')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (32, N'Isparta')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (33, N'Mersin')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (34, N'İstanbul')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (35, N'İzmir')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (36, N'Kars')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (37, N'Kastamonu')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (38, N'Kayseri')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (39, N'Kırklareli')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (40, N'Kırşehir')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (41, N'Kocaeli')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (42, N'Konya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (43, N'Kütahya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (44, N'Malatya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (45, N'Manisa')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (46, N'Kahramanmaraş')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (47, N'Mardin')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (48, N'Muğla')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (49, N'Muş')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (50, N'Nevşehir')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (51, N'Niğde')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (52, N'Ordu')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (53, N'Rize')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (54, N'Sakarya')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (55, N'Samsun')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (56, N'Siirt')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (57, N'Sinop')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (58, N'Sivas')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (59, N'Tekirdağ')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (60, N'Tokat')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (61, N'Trabzon')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (62, N'Tunceli')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (63, N'Şanlıurfa')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (64, N'Uşak')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (65, N'Van')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (66, N'Yozgat')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (67, N'Zonguldak')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (68, N'Aksaray')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (69, N'Bayburt')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (70, N'Karaman')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (71, N'Kırıkkale')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (72, N'Batman')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (73, N'Şırnak')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (74, N'Bartın')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (75, N'Ardahan')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (76, N'Iğdır')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (77, N'Yalova')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (78, N'Karabük')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (79, N'Kilis')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (80, N'Osmaniye')
INSERT [dbo].[Cities] ([CityId], [CityName]) VALUES (81, N'Düzce')
GO
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (1, N'CMT Elektronik Para ve Ödeme Hizmetleri ', CAST(N'2020-06-10T00:00:00' AS SmallDateTime), 1, 34, N'www.cmtcuzdan.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (2, N'AHLATCI Ödeme ve Elektronik Para Hizmetleri A.Ş.', CAST(N'2021-04-29T00:00:00' AS SmallDateTime), 1, 34, N'www.ahlpay.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (3, N'Aköde Elektronik Para ve Ödeme Hizmetleri A.Ş.
', CAST(N'2020-06-12T00:00:00' AS SmallDateTime), 1, 34, N'www.akode.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (4, N'BELBİM Elektronik Para ve Ödeme Hizmetleri A.Ş.
', CAST(N'2020-06-25T00:00:00' AS SmallDateTime), 1, 34, N'www.belbim.istanbul')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (5, N'Birleşik Ödeme Hizmetleri ve Elektronik Para A.Ş
', CAST(N'2020-06-26T00:00:00' AS SmallDateTime), 1, 34, N'www.birlesikodeme.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (6, N'BPN Ödeme ve Elektonik Para Hizmetleri A. Ş.
', CAST(N'2020-06-21T00:00:00' AS SmallDateTime), 1, 34, N'www.bpn.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (7, N'Dgpara Ödeme ve Elektronik Para A.Ş.
', CAST(N'2020-06-27T00:00:00' AS SmallDateTime), 1, 34, N'www.dgpays.com
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (8, N'Efix Ödeme Hizmetleri A.Ş.
', CAST(N'2020-07-01T00:00:00' AS SmallDateTime), 2, 47, N'www.efixfatura.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (9, N'Elekse Elektronik Para ve Ödeme Kuruluşu A.Ş.
', CAST(N'2020-07-02T00:00:00' AS SmallDateTime), 2, 34, N'www.elekse.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (10, N'ERPA Ödeme Hizmetleri ve Elektronik Para A. Ş.
', CAST(N'2020-07-03T00:00:00' AS SmallDateTime), 1, 6, N'erpapay.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (11, N'Fastpay Elektronik Para ve Ödeme Hizmetleri A. Ş.', CAST(N'2020-07-04T00:00:00' AS SmallDateTime), 1, 34, N'www.fastpay.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (12, N'Ceo Ödeme Kuruluşu A.Ş.
', CAST(N'2020-09-12T00:00:00' AS SmallDateTime), 2, 7, N'www.faturatim.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (13, N'Faturakom Ödeme Hizmetleri A.Ş.
', CAST(N'2020-10-10T00:00:00' AS SmallDateTime), 2, 6, N'www.faturakom.com
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (14, N'Faturamatik Elektronik Para ve Ödeme Kuruluşu A.Ş.', CAST(N'2020-11-11T00:00:00' AS SmallDateTime), 1, 34, N'www.faturamatik.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (15, N'Föy Fatura Ödeme Kuruluşu A.Ş.
', CAST(N'2020-12-10T00:00:00' AS SmallDateTime), 2, 34, N'www.faturaodemeyeri.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (16, N'Global Ödeme Hizmetleri A.Ş.', CAST(N'2020-12-28T00:00:00' AS SmallDateTime), 2, 34, N'getmoneyglobal.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (17, N'GönderAl Ödeme Hizmetleri A.Ş.', CAST(N'2020-12-03T00:00:00' AS SmallDateTime), 2, 34, N'gonder-al.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (18, N'D Ödeme Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-10-19T00:00:00' AS SmallDateTime), 1, 34, N'www.hepsipay.com
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (19, N'IQ Money Ödeme Hizmetleri ve Elektronik Para A. Ş.', CAST(N'2020-08-22T00:00:00' AS SmallDateTime), 1, 34, N'www.iqmoney.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (20, N'İninal Ödeme ve Elektronik Para Hizmetleri A.Ş.', CAST(N'2020-07-07T00:00:00' AS SmallDateTime), 1, 34, N'www.ininal.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (21, N'Aypara Ödeme Kuruluşu A.Ş.', CAST(N'2020-06-28T00:00:00' AS SmallDateTime), 2, 34, N'www.ipara.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (22, N'İstanbul Ödeme ve Elektronik Para  A.Ş.', CAST(N'2020-07-25T00:00:00' AS SmallDateTime), 2, 34, N'www.ist-pay.com
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (23, N'İyzi Ödeme ve Elektronik Para Hizmetleri A.Ş.', CAST(N'2020-09-26T00:00:00' AS SmallDateTime), 1, 34, N'www.iyzico.com
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (24, N'Lydians Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-07-22T00:00:00' AS SmallDateTime), 1, 34, N'https://fups.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (25, N'Moka Ödeme ve Elektronik Para Kuruluşu A.Ş.', CAST(N'2020-07-07T00:00:00' AS SmallDateTime), 1, 34, N'www.moka.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (26, N'MoneyGram Turkey Ödeme Hizmetleri A.Ş.', CAST(N'2020-08-13T00:00:00' AS SmallDateTime), 2, 34, N'moneygram.com.tr
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (27, N'N Kolay Ödeme ve Elektronik Para Kuruluşu A.Ş.', CAST(N'2020-07-19T00:00:00' AS SmallDateTime), 2, 34, N'www.nkolayislem.com.tr
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (28, N'Octet Express Ödeme Kuruluşu A.Ş.', CAST(N'2020-08-14T00:00:00' AS SmallDateTime), 2, 34, N'www.octet.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (29, N'Ozan Elektronik Para A.Ş.', CAST(N'2020-06-28T00:00:00' AS SmallDateTime), 1, 34, N'www.ozan.com/tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (30, N'Ödeal Ödeme Kuruluşu A.Ş.', CAST(N'2020-07-08T00:00:00' AS SmallDateTime), 2, 34, N'www.Ode.al')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (31, N'Papara Elektronik Para A.Ş.', CAST(N'2020-09-27T00:00:00' AS SmallDateTime), 1, 34, N'www.papara.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (32, N'Paragram Ödeme Hizmetleri A.Ş.', CAST(N'2020-09-09T00:00:00' AS SmallDateTime), 2, 6, N'www.pgpara.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (33, N'Nestpay Ödeme Hizmetleri A.Ş.', CAST(N'2020-06-23T00:00:00' AS SmallDateTime), 2, 34, N'www.paratika.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (34, N'Pay Fix Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-09-12T00:00:00' AS SmallDateTime), 2, 34, N'www.payfix.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (35, N'Paybull Ödeme Hizmetleri A.Ş.', CAST(N'2020-10-17T00:00:00' AS SmallDateTime), 2, 34, N'www.paybull.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (36, N'Klon Ödeme Kuruluşu A.Ş.', CAST(N'2020-09-18T00:00:00' AS SmallDateTime), 2, 34, N'www.payby.me')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (37, N'Turkcell Ödeme ve Elektronik Para  Hizmetleri A.Ş.', CAST(N'2020-11-27T00:00:00' AS SmallDateTime), 1, 34, N'paycell.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (38, N'Trend Ödeme Kuruluşu A.Ş.', CAST(N'2020-12-01T00:00:00' AS SmallDateTime), 2, 34, N'www.payguru.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (39, N'Paynet Ödeme Hizmetleri A.Ş.', CAST(N'2020-06-30T00:00:00' AS SmallDateTime), 2, 34, N'www.paynet.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (40, N'Hızlıpara Ödeme Hizmetleri ve Elektronik Para A. Ş', CAST(N'2020-09-06T00:00:00' AS SmallDateTime), 1, 34, N'www.payporter.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (41, N'Paytr Ödeme ve Elektronik Para Kuruluşu A.Ş.', CAST(N'2020-07-08T00:00:00' AS SmallDateTime), 1, 34, N'www.paytr.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (42, N'Paytrek Ödeme Kuruluşu Hizmetleri A.Ş.', CAST(N'2020-09-15T00:00:00' AS SmallDateTime), 2, 34, N'www.paytrek.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (43, N'Paladyum Elektronik Para ve Ödeme Hizmletleri A.Ş.', CAST(N'2020-07-26T00:00:00' AS SmallDateTime), 1, 34, N'www.peple.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (44, N'Pratik İşlem Ödeme Kuruluşu A.Ş.', CAST(N'2002-12-20T00:00:00' AS SmallDateTime), 2, 34, N'www.pratikislem.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (45, N'Ria Turkey Ödeme Kuruluşu A.Ş.', CAST(N'2020-09-27T00:00:00' AS SmallDateTime), 1, 34, N'tr.riafinancial.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (46, N'Sender Ödeme Hizmetleri A.Ş.', CAST(N'2020-10-01T00:00:00' AS SmallDateTime), 2, 34, N'www.send-r.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (47, N'SiPay Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-06-20T00:00:00' AS SmallDateTime), 1, 34, N'www.sipay.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (48, N'Tronapay Ödeme Hizmetleri A.Ş.', CAST(N'2020-09-22T00:00:00' AS SmallDateTime), 2, 34, N'www.tronapay.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (49, N'TURK Elektronik Para A. Ş.', CAST(N'2020-07-07T00:00:00' AS SmallDateTime), 1, 34, N'https://param.com.tr/')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (50, N'TT Ödeme ve Elektronik Para Hizmetleri A.Ş.', CAST(N'2020-06-07T00:00:00' AS SmallDateTime), 1, 34, N'turktelekomodemehizmetleri.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (51, N'UPT Ödeme Hizmetleri ve Elektronik Para A.Ş.', CAST(N'2020-09-16T00:00:00' AS SmallDateTime), 1, 34, N'www.upt.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (52, N'Vezne24 Tahsilat Sistemleri ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-07-09T00:00:00' AS SmallDateTime), 2, 34, N'www.v24.com.tr
')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (53, N'Vizyon Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-06-22T00:00:00' AS SmallDateTime), 1, 34, N'vizyonepara.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (54, N'Vodafone Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2020-08-08T00:00:00' AS SmallDateTime), 1, 34, N'vodafonepay.com.tr')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (55, N'Western Union Turkey Ödeme Hizmetleri A.Ş.', CAST(N'2020-07-24T00:00:00' AS SmallDateTime), 2, 34, N'westernunion.com')
INSERT [dbo].[Companies] ([CompanyId], [CompanyName], [DateOfRegistration], [Category], [City], [WebSite]) VALUES (56, N'Nomu Pay Ödeme ve Elektronik Para Hizmetleri A.Ş.', CAST(N'2020-06-06T00:00:00' AS SmallDateTime), 1, 34, N'wirecard.com.tr')
GO
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (1, N'Büyükdere Cad. Yapı Kredi Plaza C Blok Kat: 11 Lev', CAST(N'2015-01-01T00:00:00' AS SmallDateTime), N'08502600960', 2.29, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (2, N'İçerenköy Mahallesi Yeşilvadi Sokak No:3/4 Kat:8 A', CAST(N'2021-04-29T00:00:00' AS SmallDateTime), N'4449066', 2.7, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (3, N'Aköde Elektronik Para ve Ödeme Hizmetleri A.Ş.
', CAST(N'2018-02-19T00:00:00' AS SmallDateTime), N'08504770867', 2.5, 150000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (4, N'Yeşilköy Mah. Atatürk Havalimanı Cad.
İstanbul Dü', CAST(N'1987-01-01T00:00:00' AS SmallDateTime), N'02124655193', 2.6, 120000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (5, N'Esentepe Mah. Büyükdere Cad. No:102 /14 Maya Akar Center B Blok K: 3 Şişli / İstanbul
', CAST(N'2010-01-01T00:00:00' AS SmallDateTime), N'02122415459', 2.442, 130000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (6, N'Maslak Mah. AOS 53.Sok. No:7 Sarıyer / İstanbul

', CAST(N'2012-01-01T00:00:00' AS SmallDateTime), N'08503129900', 2.24, 160000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (7, N'Maslak Mahallesi Büyükdere Cad. No:249/6 Kat:4 Sarıyer/İstanbul
', CAST(N'2017-01-01T00:00:00' AS SmallDateTime), N'02122904010', 2.43, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (8, N'Yenişehir Mah. Ravza Cd. Kanza Apt. Altı No:8 Artuklu, Mardin

', CAST(N'2015-01-01T00:00:00' AS SmallDateTime), N'04822133300', 1.89, 20000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (9, N'Merkez Mahallesi Ayazma Caddesi No:37/91 Papirus Plaza Kat:5 34406 Kağthane / İstanbul

', CAST(N'2005-01-01T00:00:00' AS SmallDateTime), N'02122356600', 1.87, 25000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (10, N'Mustafa Kemal Mah. 2125. Sok. No: 5 Erpa Plaza Çankaya / Ankara

', CAST(N'1998-01-01T00:00:00' AS SmallDateTime), N'03124390439', 1.9, 30000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (11, N'Büyükdere Cad. No:141 Kat:4 Esentepe Şişli / İstanbul

', CAST(N'2013-01-01T00:00:00' AS SmallDateTime), N'08507377777', 1.77, 40000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (12, N'Yukarı Hisar Mahallesi, 7003 Sokak Mustafa Duman İş Merkezi, No: 2/16 Manavgat / Antalya

', CAST(N'2015-01-01T00:00:00' AS SmallDateTime), N'08508851846', 1.74, 50000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (13, N'Oğuzlar Mah. Çetin Emeç Bulvarı No:60/9 Balgat Çankaya / Ankara

', CAST(N'2005-02-01T00:00:00' AS SmallDateTime), N'02165613434', 1.54, 60000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (14, N'Zümrütevler Mah. Acarlar Sok. No:16 Maltepe / İstanbul

', CAST(N'1999-03-01T00:00:00' AS SmallDateTime), N'02165613434', 1.34, 70000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (15, N'Yıldız Plaza Eski Edirne Asfaltı Cad. No:407 Kat:3 Bayrampaşa / İstanbul

', CAST(N'2009-01-01T00:00:00' AS SmallDateTime), N'4449369
', 1.3, 80000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (16, N'Maslak Mahallesi Eski Büyükdere Caddesi 2000 Plaza No:7/65, 34485 Sarıyer / İstanbul

', CAST(N'2013-06-20T00:00:00' AS SmallDateTime), N'02122527777', 1.27, 125000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (17, N'İz Plaza Giz. D: 58 Maslak 34485 Sarıyer / İstanbul
', CAST(N'2016-02-26T00:00:00' AS SmallDateTime), N'08502150955', 1.98, 200000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (18, N'Kuştepe Mah. Mecidiyeköy Yolu Cad. Trump Tower Blok No: 12 I·c¸ Kapı No: 434 S¸is¸li / I·stanbul

', CAST(N'2018-06-04T00:00:00' AS SmallDateTime), N'08502524000', 1.22, 150000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (19, N'Küçükbakkalköy, Kayışdağı Cd. No:1, Allianz Tower No: 13 34752 Ataşehir / İstanbul

', CAST(N'2018-03-30T00:00:00' AS SmallDateTime), N'02162081190', 1.19, 160000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (20, N'Mecidiyeköy Yolu Caddesi No:12 Trump Towers 2. Kule Kat:9 N:448 Şişli / İstanbul

', CAST(N'2017-02-02T00:00:00' AS SmallDateTime), N'08503117701', 1.42, 120000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (21, N'Kultepe Mah. Mecidiyeköy Yolu Cad. Trump Tower Blok No:12, İç Kapı No:452 Şişli / İstanbul
', CAST(N'2012-04-06T00:00:00' AS SmallDateTime), N'02123368880', 1.48, 149000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (22, N'Esentepe Mah. Büyükdere Cad. Levent Plaza No: 173 10.Kat İç kapı No:34 Şişli-İSTANBUL
', CAST(N'2018-04-28T00:00:00' AS SmallDateTime), N'02123368880', 1.11, 165000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (23, N'Maslak Mah. AOS 55. Sok. 42 Maslak A Blok Sitesi No:2/140 Sarıyer / İstanbul
', CAST(N'2013-06-24T00:00:00' AS SmallDateTime), N'02165990100', 0.99, 249000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (24, N'Lydians Elektronik Para ve Ödeme Hizmetleri A.Ş.', CAST(N'2017-02-03T00:00:00' AS SmallDateTime), N'02168860250', 1, 260000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (25, N'Levent Mh. Meltem Sk. İş Bankası Kuleleri No:10/4 34788 Beşiktaş / İstanbul
', CAST(N'2016-04-12T00:00:00' AS SmallDateTime), N'08503339899', 0.98, 200000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (26, N'Büyükdere Cad. Kırgülü Sok. Metrocity AVM D Blok Kat:4 34394 Levent Şişli / Istanbul
', CAST(N'1988-01-10T00:00:00' AS SmallDateTime), N'02129881432', 0.99, 130000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (27, N'Maltepe Mah. Davutpaşa Cad. Cebe Ali Bey Sok. No:7 Zeytinburnu / İstanbul', CAST(N'2006-01-01T00:00:00' AS SmallDateTime), N'08503777374', 1.65, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (28, N'Gazi Umur Paşa Sok. Bimar Plaza No:38/6 Balmumcu Beşiktaş / İstanbul', CAST(N'2008-12-12T00:00:00' AS SmallDateTime), N'08503601511', 1.39, 990000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (29, N'Büyükdere Caddesi No:193 Levent 34394 Şişli İstanbul/Türkiye', CAST(N'2019-06-15T00:00:00' AS SmallDateTime), N'08502206926', 1.12, 105000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (30, N'Yeşilce Mah. Destegül Sok. No:1/A Kağıthane / İstanbul', CAST(N'2014-05-05T00:00:00' AS SmallDateTime), N'08502000022', 1.09, 995000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (31, N'Fatih Sultan Mehmet Mh. Balkan Cd. No:62-A Oda No:109-111 Ümraniye / İstanbul', CAST(N'2016-04-01T00:00:00' AS SmallDateTime), N'08503400340', 1.68, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (32, N'Cevizlidere Mah. Mevlana Blv. Yıldırım Kule No: 221/12  Kat: 4  Çankaya / Ankara
', CAST(N'2016-06-06T00:00:00' AS SmallDateTime), N'03124956688', 2.11, 150000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (33, N'Spine Tower Büyükdere Cad. No:243, Kat:24 Maslak - Sarıyer / İstanbul', CAST(N'2004-11-23T00:00:00' AS SmallDateTime), N'02123190625', 2.04, 109000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (34, N'Kuştepe Mah. Mecidiyeköy Yolu CAd. No:12 Trump Office Tower Kat:8 Şişli / İstanbul', CAST(N'2018-03-14T00:00:00' AS SmallDateTime), N'08504551111', 2.49, 150000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (35, N'Altunizade Mh. Kuşbakışı Cd. | Maden İş Merkezi No:7 Üsküdar/İSTANBUL', CAST(N'2020-04-04T00:00:00' AS SmallDateTime), N'08502418418', 1.99, 250000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (36, N'Tophanelioğlu Caddesi Arduman İş Merkezi C Blok No:8 34662 Altunizade-Üsküdar /İstanbul', CAST(N'2012-04-28T00:00:00' AS SmallDateTime), N'08505325040', 1.98, 200000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (37, N'Turkcell Tepebaşı Plaza, Asmalımescit Mah. Meşrutiyet Cad. No:71 Beyoğlu / İstanbul', CAST(N'2000-01-02T00:00:00' AS SmallDateTime), N'08506226060', 2.19, 130000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (38, N'Reşitpaşa Mahallesi Katar Caddesi Teknokent ARI 1 Binası No:2/5/23 34398 Sarıyer / Istanbul', CAST(N'2016-05-05T00:00:00' AS SmallDateTime), N'02122854600', 2.01, 300000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (39, N'Maslak Mah. Büyükdere Caddesi No:245 Uso Center Kat:17 Maslak - Sarıyer / İstanbul', CAST(N'2019-06-17T00:00:00' AS SmallDateTime), N'447729', 0.99, 120000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (40, N'Fulya Mahallesi Büyükdere Caddesi Likör Yanı Sokak No:1/13 Akabe Ticaret Merkezi Şişli / İstanbul', CAST(N'2014-09-30T00:00:00' AS SmallDateTime), N'08508110077', 0.97, 50000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (41, N'Atatürk Caddesi No:126 Kat:5 İç Kapı No:51 Alsancak / İzmir', CAST(N'2009-11-27T00:00:00' AS SmallDateTime), N'08504413266', 1.49, 125000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (42, N'Davut Paşa, Eski Londra Asfaltı Cd. No:151 D:1E, 34220 Esenler / İstanbul', CAST(N'2015-05-15T00:00:00' AS SmallDateTime), N'08503602000', 1.03, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (43, N'Maslak Mahallesi Bilim Sokak Sun Plaza Blok No:5/A İç Kapı No: 5 Sarıyer / İstanbul', CAST(N'2017-08-21T00:00:00' AS SmallDateTime), N'08504505040', 1.85, 500000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (44, N'Kaptanpaşa Mahallesi Halit Ziya Türkkan Sokak Famas Plaza C Blok Kat: No:19 - 34384 Şişli / İstanbul', CAST(N'2016-06-06T00:00:00' AS SmallDateTime), N'08504806060', 1.02, 200000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (45, N'Büyükdere Caddesi 193 Plaza No:193 Kat:2 Levent Şişli / İstanbul', CAST(N'2012-04-19T00:00:00' AS SmallDateTime), N'02123714680', 1.49, 399999)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (46, N'İstiklal Cad. No:187-5 Beyoğlu İş Merkezi Kat:6 34433 Tomtom Mah. Beyoğlu / İstanbul', CAST(N'2017-05-16T00:00:00' AS SmallDateTime), N'02122932939', 1.79, 300000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (47, N'Altunizade Mah. Kuşbakışı Cad. Maden İş Merkezi No:7 Kat:2 Üsküdar / İSTANBUL', CAST(N'2018-12-29T00:00:00' AS SmallDateTime), N'02127061112', 1.89, 250000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (48, N'Oruç Reis Mahallesi Giyimkent Caddesi No:2 Avek Plaza, Atışalanı Esenler / İstanbul', CAST(N'2019-04-04T00:00:00' AS SmallDateTime), N'02126288766', 1.89, 150000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (49, N' Prof. Dr. Ahmet Taner Kışlalı Mahallesi 2405 Sokak No: 5 Çankaya / Ankara', CAST(N'2014-01-01T00:00:00' AS SmallDateTime), N'08509888875', 1.24, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (50, N'Gayrettepe Mahallesi Yıldız Posta Caddesi Vefa Bayırı Sokak No:2 Kule Bina Kat:15, Beşiktaş/İstanbul', CAST(N'2002-02-02T00:00:00' AS SmallDateTime), N'441444', 1.89, 50000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (51, N'Esentepe Mah. Kore Şehitleri Cad. No:8/1 Şişli / İstanbul', CAST(N'2013-06-20T00:00:00' AS SmallDateTime), N'08507240878', 1.77, 80000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (52, N'FSM Mahallesi Poligon Cad. Buyaka 2 Sitesi Kule: 3 No:8C-95 34771 Ümraniye / İstanbul', CAST(N'2002-02-01T00:00:00' AS SmallDateTime), N'08504208963', 1.1, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (53, N'Esentepe Mahallesi Büyükdere Caddesi No: 102 Maya Akar Center Kat:8 37-38 Şişli / İstanbul', CAST(N'2008-05-29T00:00:00' AS SmallDateTime), N'08505330333', 1.49, 250000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (54, N'Maslak Mah. AOS 55.SK. 42 Maslak B Blok Sitesi No:4/665 Sarıyer / İstanbul', CAST(N'2015-06-14T00:00:00' AS SmallDateTime), N'08505420000', 1.79, 120000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (55, N'Maslak Mah. Ahi Evran Cad. Polaris İş Merkezi Apt. No:21/29 34398 Sarıyer / İstanbul', CAST(N'2000-01-01T00:00:00' AS SmallDateTime), N'02123755750', 1.99, 100000)
INSERT [dbo].[CompanyDetails] ([CompanyId], [Address], [EstablishedDate], [Phone], [CommissionRate], [TransactionLimit]) VALUES (56, N'Maslak Mah. AOS 55. Sk. 42 Maslak B Blok Sitesi No: 4 Kat:18 D:2/658 Sarıyer / İstanbul', CAST(N'1999-05-05T00:00:00' AS SmallDateTime), N'02122862718', 1.79, 120000)
GO
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Categories] FOREIGN KEY([Category])
REFERENCES [dbo].[Categories] ([CategoryId])
GO
ALTER TABLE [dbo].[Companies] CHECK CONSTRAINT [FK_Companies_Categories]
GO
ALTER TABLE [dbo].[Companies]  WITH CHECK ADD  CONSTRAINT [FK_Companies_Cities] FOREIGN KEY([City])
REFERENCES [dbo].[Cities] ([CityId])
GO
ALTER TABLE [dbo].[Companies] CHECK CONSTRAINT [FK_Companies_Cities]
GO
ALTER TABLE [dbo].[CompanyDetails]  WITH CHECK ADD  CONSTRAINT [FK_Details_Companies] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Companies] ([CompanyId])
GO
ALTER TABLE [dbo].[CompanyDetails] CHECK CONSTRAINT [FK_Details_Companies]
GO
/****** Object:  StoredProcedure [dbo].[sp_ChangeCommissionRate]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ChangeCommissionRate]
	-- Girilen id değerine göre istenen kuruluşun komisyon oranını değiştiren ve güncel halini gösteren prosedür
	@companyId int,
	@new_commissionRate float

AS
BEGIN
	update CompanyDetails set CommissionRate=@new_commissionRate
	where CompanyId=@companyId

	select 
	cmp.CompanyName,
	ctg.CommissionRate

	from CompanyDetails as ctg 
	inner join Companies as cmp on ctg.CompanyId=cmp.CompanyId

	where cmp.CompanyId=@companyId
END
GO
/****** Object:  StoredProcedure [dbo].[sp_ChangeTransactionLimit]    Script Date: 15.07.2022 22:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ChangeTransactionLimit]
	-- Girilen id değerine göre istenen kuruluşun İŞLEM LİMİTİNİ değiştiren ve güncel halini gösteren prosedür
	@companyId int,
	@new_transactionLimit float

AS
BEGIN
	update CompanyDetails set TransactionLimit=@new_transactionLimit
	where CompanyId=@companyId

	select 
	cmp.CompanyName,
	ctg.TransactionLimit

	from CompanyDetails as ctg 
	inner join Companies as cmp on ctg.CompanyId=cmp.CompanyId

	where cmp.CompanyId=@companyId
END
GO
USE [master]
GO
ALTER DATABASE [Todeb] SET  READ_WRITE 
GO
