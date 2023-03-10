USE [master]
GO
/****** Object:  Database [BlogMentor]    Script Date: 24-May-19 10:57:35 PM ******/
CREATE DATABASE [BlogMentor]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BlogMentor', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\BlogMentor.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'BlogMentor_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\BlogMentor_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BlogMentor] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BlogMentor].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BlogMentor] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BlogMentor] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BlogMentor] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BlogMentor] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BlogMentor] SET ARITHABORT OFF 
GO
ALTER DATABASE [BlogMentor] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BlogMentor] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [BlogMentor] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BlogMentor] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BlogMentor] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BlogMentor] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BlogMentor] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BlogMentor] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BlogMentor] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BlogMentor] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BlogMentor] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BlogMentor] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BlogMentor] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BlogMentor] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BlogMentor] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BlogMentor] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BlogMentor] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BlogMentor] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BlogMentor] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BlogMentor] SET  MULTI_USER 
GO
ALTER DATABASE [BlogMentor] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BlogMentor] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BlogMentor] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BlogMentor] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [BlogMentor]
GO
/****** Object:  User [pasha]    Script Date: 24-May-19 10:57:36 PM ******/
CREATE USER [pasha] FOR LOGIN [pasha] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[spGetBlogComments]    Script Date: 24-May-19 10:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetBlogComments]

@BlogID bigint

AS BEGIN

SELECT	BC.*,
		U.FullName

FROM	BlogComments BC
		INNER JOIN Users U ON U.ID = BC.UserID

WHERE	BC.BlogID = @BlogID

END
GO
/****** Object:  StoredProcedure [dbo].[spGetBlogs]    Script Date: 24-May-19 10:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetBlogs]

@BlogID BIGINT

AS BEGIN

SELECT	B.*,
		U.FullName

FROM	Blogs B
		INNER JOIN Users U ON U.ID = B.UserID

WHERE	(B.ID = @BlogID OR @BlogID = 0)

END
GO
/****** Object:  UserDefinedFunction [dbo].[SplitString]    Script Date: 24-May-19 10:57:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitString]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT
 
      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END
 
      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END
 
      RETURN
END

GO
/****** Object:  Table [dbo].[BlogComments]    Script Date: 24-May-19 10:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlogComments](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[BlogID] [bigint] NULL,
	[CommentText] [varchar](2000) NULL,
	[CommentDate] [datetime] NULL,
	[IsApproved] [bit] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_BlogComments] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 24-May-19 10:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Blogs](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](500) NULL,
	[Tags] [varchar](500) NULL,
	[Description] [varchar](max) NULL,
	[CoverPicUrl] [varchar](200) NULL,
	[Quote] [varchar](1000) NULL,
	[Dated] [datetime] NULL,
	[UserID] [int] NULL,
 CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RefUserType]    Script Date: 24-May-19 10:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RefUserType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_RefUserType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 24-May-19 10:57:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [varchar](100) NULL,
	[Email] [varchar](50) NULL,
	[ContactNo] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[UserTypeID] [int] NULL,
	[IsApproved] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BlogComments] ON 

INSERT [dbo].[BlogComments] ([ID], [BlogID], [CommentText], [CommentDate], [IsApproved], [UserID]) VALUES (3, 1, N'First Comment', CAST(0x0000AA5100000000 AS DateTime), 1, 3)
INSERT [dbo].[BlogComments] ([ID], [BlogID], [CommentText], [CommentDate], [IsApproved], [UserID]) VALUES (5, 1, N'New Commwnt', CAST(0x0000AA5101215613 AS DateTime), 1, 2)
INSERT [dbo].[BlogComments] ([ID], [BlogID], [CommentText], [CommentDate], [IsApproved], [UserID]) VALUES (6, 1, N'Anonymus comment', CAST(0x0000AA5100000000 AS DateTime), 0, 3)
INSERT [dbo].[BlogComments] ([ID], [BlogID], [CommentText], [CommentDate], [IsApproved], [UserID]) VALUES (7, 4, N'This is first comment', CAST(0x0000AA52011FFF1B AS DateTime), 1, 3)
INSERT [dbo].[BlogComments] ([ID], [BlogID], [CommentText], [CommentDate], [IsApproved], [UserID]) VALUES (10, 4, N'New Comment', CAST(0x0000AA5201235DA7 AS DateTime), 1, 3)
SET IDENTITY_INSERT [dbo].[BlogComments] OFF
SET IDENTITY_INSERT [dbo].[Blogs] ON 

INSERT [dbo].[Blogs] ([ID], [Title], [Tags], [Description], [CoverPicUrl], [Quote], [Dated], [UserID]) VALUES (1, N'Travelling with Baby', N'Traveling,Baby', N'For as long as I can remember I have loved to travel.

I suffer from acute wanderlust, always dreaming of my next adventure.

There’s just nothing quite like taking that first step off the plane and gulping down the air of a new world. Whether it’s cold and dry, hot and steamy, or warm and thick with spices, the first taste of a trip is always the sweetest.

I was a little concerned that I’d find myself landlocked after having a baby. I didn’t know what life would be like, if we’d be able to travel or would find ourselves just too exhausted with nappy changes to even leave the house. But as with everything in life, the things you worry most about tend not to be a problem when it comes down to it.

Lily is now two months old and we thought it was high time for her first adventure. So while she snoozed, I schemed.', N'/Content/theme/img/blogPics/Joe Denly.jpg', N'For as long as I can remember I have loved to travel. ', CAST(0x0000AA4D0025BEC3 AS DateTime), 3)
INSERT [dbo].[Blogs] ([ID], [Title], [Tags], [Description], [CoverPicUrl], [Quote], [Dated], [UserID]) VALUES (2, N'Spring Wedding Guest', N'Life Style,Wedding', N'Thankfully the sun is shining and it seems we’re set for a hot one.
What better time to toast to lovebirds, sip bubbly on the lawn and dance in a storm of confetti?
This time of year offers a few more sartorial difficulties than wedding thrown in summer.
Sure, it’s boiling now but that grey cloud on the horizon has other ideas…
Luckily my best friend Julia has a solution! Her new collection of dresses have matching cosy cardigans for throwing on should the breeze pick up, or in case the church gets chilly.', N'/Content/theme/img/blogPics/Bob Jhons2.jpg', N'Thankfully the sun is shining.', CAST(0x0000AA5101828219 AS DateTime), 3)
INSERT [dbo].[Blogs] ([ID], [Title], [Tags], [Description], [CoverPicUrl], [Quote], [Dated], [UserID]) VALUES (3, N'Chocolate Orange Smoothie', N'Food,Smoothie', N'I used to have them for breakfast, whereas now I have one in the afternoon or after supper instead of dessert, in front of the tv! This particular take on my classic “healthy gut” recipe came about due to an abundance of Christmas citruses, and I think it’s the best yet.

To make one (double as required) you’ll need:

1 frozen chopped banana

1 cup organic kefir milk

1 Greek yogurt (sugar free, full fat if poss)

Juice of one large orange (right from the orange, not a carton)

1 scoop raw cocoa powder

1 handful of ice

1 sachet of VSL3 Probiotics (the most concentrated source of probiotics on the market)', N'/Content/theme/img/blogPics/Bob Jhons3.jpg', N'I still swear by them and am forever dreaming up new ways', CAST(0x0000AA51018A0E95 AS DateTime), 3)
INSERT [dbo].[Blogs] ([ID], [Title], [Tags], [Description], [CoverPicUrl], [Quote], [Dated], [UserID]) VALUES (4, N'New Years Revolution', N'Life Style,New Year', N'Skip the tired old resolutions.

Don’t go on a juice cleanse.

Skip the soup diets.

Forget fasting.

Ditch the “detox tea” (or anything with detox in the name, to be honest).

Steer well clear of the low fat aisle.

This year have your own little New Years Revolution! Decide that instead of punishing yourself you’re going to do something that’ll have all of those ridiculous fad-diet companies shaking in their boots.

Decide to love yourself.

In a world driven by an economy that wants you to hate yourself, to constantly need to buy into new schemes pushing you towards an utterly unobtainable goal, simply loving yourself if the biggest, bravest act of resistance.', N'/Content/theme/img/blogPics/Bob Jhons4.jpg', N'Skip the tired old resolutions.', CAST(0x0000AA52011F9CF3 AS DateTime), 3)
INSERT [dbo].[Blogs] ([ID], [Title], [Tags], [Description], [CoverPicUrl], [Quote], [Dated], [UserID]) VALUES (10, N'Tesla’s Automated Lane Change Poses ‘Potential Safety Risks''', N'Technology,Automobile', N'Tesla’s latest automated lane change update to its controversial “Autopilot” software doesn’t appear to react to brake lights or turn signals, according to a report published Wednesday by Consumer Reports. The update gives drivers the ability to let the car change lanes for them, without any human input.

The company says the update is part of its effort to make driving “more seamless.” But according to Consumer Reports, the technology comes with potentially dangerous ramifications. 

“In practice, we found that Navigate on Autopilot lagged far behind a human driver’s skill set: The feature cut off cars without leaving enough space and even passed other cars in ways that violate state laws, according to several law enforcement representatives CR interviewed for this report,” the report said. “As a result, the driver often had to prevent the system from making poor decisions.”', N'/Content/theme/img/blogPics/Bob Jhons10.jpg', N'In practice, we found that Navigate on Autopilot lagged far behind a human driver’s skill set', CAST(0x0000AA57000CD7E9 AS DateTime), 3)
SET IDENTITY_INSERT [dbo].[Blogs] OFF
SET IDENTITY_INSERT [dbo].[RefUserType] ON 

INSERT [dbo].[RefUserType] ([ID], [Description]) VALUES (1, N'Admin')
INSERT [dbo].[RefUserType] ([ID], [Description]) VALUES (2, N'Author')
INSERT [dbo].[RefUserType] ([ID], [Description]) VALUES (3, N'RegisteredUser')
INSERT [dbo].[RefUserType] ([ID], [Description]) VALUES (4, N'AnonymousUser')
SET IDENTITY_INSERT [dbo].[RefUserType] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([ID], [FullName], [Email], [ContactNo], [Username], [Password], [UserTypeID], [IsApproved]) VALUES (2, N'Joe Denly', N'joe@gmail.com', N'123', N'joe', N'joe123', 1, 1)
INSERT [dbo].[Users] ([ID], [FullName], [Email], [ContactNo], [Username], [Password], [UserTypeID], [IsApproved]) VALUES (3, N'Bob Jhons', N'Bob@gmail.com', N'125', N'bob', N'bob123', 2, 1)
INSERT [dbo].[Users] ([ID], [FullName], [Email], [ContactNo], [Username], [Password], [UserTypeID], [IsApproved]) VALUES (5, N'ZZZ', N'ZZZ@gmail.com', N'333', N'zzz', N'zzz123', 3, 1)
SET IDENTITY_INSERT [dbo].[Users] OFF
ALTER TABLE [dbo].[BlogComments]  WITH CHECK ADD  CONSTRAINT [FK_BlogComments_Blogs] FOREIGN KEY([BlogID])
REFERENCES [dbo].[Blogs] ([ID])
GO
ALTER TABLE [dbo].[BlogComments] CHECK CONSTRAINT [FK_BlogComments_Blogs]
GO
ALTER TABLE [dbo].[BlogComments]  WITH CHECK ADD  CONSTRAINT [FK_BlogComments_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[BlogComments] CHECK CONSTRAINT [FK_BlogComments_Users]
GO
ALTER TABLE [dbo].[Blogs]  WITH CHECK ADD  CONSTRAINT [FK_Blogs_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([ID])
GO
ALTER TABLE [dbo].[Blogs] CHECK CONSTRAINT [FK_Blogs_Users]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_RefUserType] FOREIGN KEY([UserTypeID])
REFERENCES [dbo].[RefUserType] ([ID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_RefUserType]
GO
USE [master]
GO
ALTER DATABASE [BlogMentor] SET  READ_WRITE 
GO
