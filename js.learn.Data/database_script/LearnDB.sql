-- DATABASE --

IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = 'LearnDB')
BEGIN
	CREATE DATABASE LearnDB;
END

ELSE BEGIN
	DROP DATABASE LearnDB;
END

GO
USE LearnDB
GO

-- MIGRATION --

IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
	CREATE TABLE [__EFMigrationsHistory] (
		[MigrationId] nvarchar(150) NOT NULL,
		[ProductVersion] nvarchar(32) NOT NULL,
		CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
	);
END;
GO


-- MODELS --

BEGIN TRANSACTION;
GO

CREATE TABLE UserProfile (
	UserId INT IDENTITY(1,1),
	DisplayName NVARCHAR(100) NOT NULL CONSTRAINT DF_UserProfile_DisplayName DEFAULT 'Guest',
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	AdObjId NVARCHAR(128) NOT NULL,
    CONSTRAINT PK_UserProfile_UserId PRIMARY KEY (UserId)
);

CREATE TABLE Roles (
	RoleId INT IDENTITY (1,1),
	RoleName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Roles_RoleId PRIMARY KEY (RoleId)
)

CREATE TABLE SmartApp (
	SmartAppId INT IDENTITY(1,1),
	AppName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_SmartApp_SmartAppId PRIMARY KEY (SmartAppId)
);

CREATE TABLE UserRole (
	UserRoleId INT IDENTITY(1,1),
	RoleId INT NOT NULL,
	UserId INT NOT NULL,
	SmartAppId INT NOT NULL,

	CONSTRAINT PK_UserRole_UserRoleId PRIMARY KEY (UserRoleId),
    CONSTRAINT FK_UserRole_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId),
    CONSTRAINT FK_UserRole_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
	CONSTRAINT FK_UserRole_SmartApp FOREIGN KEY (SmartAppId) REFERENCES SmartApp(SmartAppId)
)

CREATE TABLE CourseCategory (
	CategoryId INT IDENTITY(1,1),
	CategoryName NVARCHAR(50) NOT NULL,
	Description NVARCHAR(250),
    CONSTRAINT PK_CourseCategory_CategoryId PRIMARY KEY (CategoryId)
);

CREATE TABLE Instructor (
	InstructorId INT IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
    Bio NVARCHAR(MAX),
	UserId INT NOT NULL,  
    CONSTRAINT PK_Instructor_InstructorId PRIMARY KEY (InstructorId),
	CONSTRAINT FK_Instructor_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

CREATE TABLE Course (
    CourseId INT IDENTITY(1,1),
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    CourseType NVARCHAR(10) NOT NULL CHECK (CourseType IN ('Online', 'Offline')),
    SeatsAvailable INT CHECK (SeatsAvailable >= 0),
    Duration DECIMAL(5, 2) NOT NULL, -- Duration in hours
    CategoryId INT NOT NULL,
    InstructorId INT NOT NULL,
    StartDate DATETIME, -- Applicable for Online courses
    EndDate DATETIME, -- Applicable for Online courses
  
	CONSTRAINT PK_Course_CourseId PRIMARY KEY (CourseId),
    CONSTRAINT FK_Course_CourseCategory FOREIGN KEY (CategoryId) REFERENCES CourseCategory(CategoryId),
    CONSTRAINT FK_Course_Instructor FOREIGN KEY (InstructorId) REFERENCES Instructor(InstructorId)
);

CREATE TABLE SessionDetails (
    SessionId INT IDENTITY(1,1),
    CourseId INT NOT NULL,
    Title NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    VideoUrl NVARCHAR(500),
    VideoOrder INT NOT NULL,
    CONSTRAINT PK_SessionDetails_SessionId PRIMARY KEY (SessionId),
    CONSTRAINT FK_SessionDetails_Course FOREIGN KEY (CourseId) REFERENCES Course(CourseId)
);

CREATE TABLE Enrollment (
    EnrollmentId INT IDENTITY(1,1),
    CourseId INT NOT NULL,
    UserId INT NOT NULL,
    EnrollmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentStatus NVARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')),
    CONSTRAINT PK_Enrollment_EnrollmentId PRIMARY KEY (EnrollmentId),
    CONSTRAINT FK_Enrollment_Course FOREIGN KEY (CourseId) REFERENCES Course(CourseId),
    CONSTRAINT FK_Enrollment_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

CREATE TABLE Payment (
    PaymentId INT IDENTITY(1,1),
    EnrollmentId INT NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL CHECK (PaymentStatus IN ('Pending', 'Completed', 'Failed')),
    CONSTRAINT PK_Payment_PaymentId PRIMARY KEY (PaymentId),
    CONSTRAINT FK_Payment_Enrollment FOREIGN KEY (EnrollmentId) REFERENCES Enrollment(EnrollmentId)
);

CREATE TABLE Review (
    ReviewId INT IDENTITY(1,1),
    CourseId INT NOT NULL,
    UserId INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments NVARCHAR(MAX),
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Review_ReviewId PRIMARY KEY (ReviewId),
    CONSTRAINT FK_Review_Course FOREIGN KEY (CourseId) REFERENCES Course(CourseId),
    CONSTRAINT FK_Review_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);


COMMIT;
GO


-- POPULATE --

INSERT INTO UserProfile (DisplayName, FirstName, LastName, Email, AdObjId)
VALUES 
('John Doe', 'John', 'Doe', 'john.doe@example.com', 'ad-obj-id-001'),
('Jane Smith', 'Jane', 'Smith', 'jane.smith@example.com', 'ad-obj-id-002'),
('Alice Johnson', 'Alice', 'Johnson', 'alice.johnson@example.com', 'ad-obj-id-003');


INSERT INTO Roles (RoleName)
VALUES 
('Admin'),
('Instructor'),
('Student');


INSERT INTO SmartApp (AppName)
VALUES 
('Online_Course'),
('Expense_Tracker');


DECLARE @appId int = (select SmartAppId from SmartApp where AppName= 'Online_Course')
INSERT INTO UserRole (RoleId, UserId, SmartAppId)
VALUES 
(1, 1,@appId),  -- John Doe as Admin
(2, 2,@appId),  -- Jane Smith as Instructor
(3, 3, @appId); -- Alice Johnson as Student


INSERT INTO CourseCategory (CategoryName, Description)
VALUES 
('Programming', 'Courses related to software development and programming languages.'),
('Data Science', 'Courses covering data analysis, machine learning, and AI.'),
('Design', 'Courses related to graphic design, UX/UI, and creative fields.');

INSERT INTO Instructor (FirstName, LastName, Email, Bio, UserId)
VALUES 
('Jane', 'Smith', 'jane.smith@example.com', 'Experienced software engineer with 10 years in the industry.', 2);


INSERT INTO Course (Title, Description, Price, CourseType, SeatsAvailable, Duration, CategoryId, InstructorId, StartDate, EndDate)
VALUES 
('Angular Full Course', 'Comprehensive course covering Angular from basics to advanced topics.', 199.99, 'Online', 50, 40.5, 1, 1, '2024-09-01', '2024-09-30'),
('Introduction to Data Science', 'Learn the fundamentals of data science with hands-on examples.', 149.99, 'Offline', NULL, 30.0, 2, 1, NULL, NULL),
('Graphic Design Mastery', 'Master the art of graphic design with practical projects.', 129.99, 'Offline', NULL, 25.0, 3, 1, NULL, NULL);


INSERT INTO SessionDetails (CourseId, Title, Description, VideoUrl, VideoOrder)
VALUES 
(1, 'Introduction to Angular', 'Overview of Angular and its core concepts.', 'https://example.com/angular-intro', 1),
(1, 'Angular Components', 'Deep dive into Angular components.', 'https://example.com/angular-components', 2),
(1, 'Angular Services and Dependency Injection', 'Learn how to create and use services in Angular.', 'https://example.com/angular-services', 3),
(1, 'Routing in Angular', 'Understanding routing and navigation in Angular.', 'https://example.com/angular-routing', 4),
(2, 'Data Science Introduction', 'Introduction to data science and its applications.', 'https://example.com/data-science-intro', 1),
(2, 'Python for Data Science', 'Using Python for data analysis and visualization.', 'https://example.com/python-data-science', 2),
(2, 'Machine Learning Basics', 'Introduction to machine learning concepts.', 'https://example.com/ml-basics', 3),
(3, 'Introduction to Graphic Design', 'Overview of graphic design principles.', 'https://example.com/graphic-design-intro', 1),
(3, 'Typography and Layout', 'Learn the importance of typography and layout in design.', 'https://example.com/typography-layout', 2),
(3, 'Advanced Photoshop Techniques', 'Master advanced techniques in Adobe Photoshop.', 'https://example.com/photoshop-techniques', 3);


INSERT INTO Enrollment (CourseId, UserId, EnrollmentDate, PaymentStatus)
VALUES 
(1, 3, GETDATE(), 'Completed'),
(2, 3, GETDATE(), 'Pending'),
(3, 1, GETDATE(), 'Completed');


INSERT INTO Payment (EnrollmentId, Amount, PaymentDate, PaymentMethod, PaymentStatus)
VALUES 
(1, 199.99, GETDATE(), 'Credit Card', 'Completed'),
(2, 149.99, GETDATE(), 'Credit Card', 'Pending'),
(3, 129.99, GETDATE(), 'Credit Card', 'Completed');



INSERT INTO Review (CourseId, UserId, Rating, Comments, ReviewDate)
VALUES 
(1, 3, 5, 'Excellent course, highly recommended!', GETDATE()),
(2, 3, 4, 'Great content, but could use more examples.', GETDATE()),
(3, 1, 5, 'Loved the hands-on projects and practical examples.', GETDATE());


INSERT INTO UserProfile (DisplayName, FirstName, LastName, Email, AdObjId)
VALUES 
('Michael Brown', 'Michael', 'Brown', 'michael.brown@example.com', 'ad-obj-id-004'),
('Laura White', 'Laura', 'White', 'laura.white@example.com', 'ad-obj-id-005'),
('David Green', 'David', 'Green', 'david.green@example.com', 'ad-obj-id-006');


INSERT INTO Roles (RoleName)
VALUES 
('Admin'),
('Instructor'),
('Student');


INSERT INTO UserRole (RoleId, UserId, SmartAppId)
VALUES 
(1, 4,@appId), -- Michael Brown as Admin
(2, 5,@appId), -- Laura White as Instructor
(3, 6,@appId); -- David Green as Student


INSERT INTO CourseCategory (CategoryName, Description)
VALUES 
('Web Development', 'Courses focusing on front-end and back-end web development.'),
('Cybersecurity', 'Courses covering security practices and ethical hacking.'),
('Project Management', 'Courses on managing projects, teams, and resources effectively.');


INSERT INTO Instructor (FirstName, LastName, Email, Bio, UserId)
VALUES 
('Laura', 'White', 'laura.white@example.com', 'Certified web developer and instructor with 8 years of experience.', 5);


INSERT INTO Course (Title, Description, Price, CourseType, SeatsAvailable, Duration, CategoryId, InstructorId, StartDate, EndDate)
VALUES 
('Full Stack Web Development', 'Learn to build web applications from scratch using modern technologies.', 249.99, 'Online', 40, 50.0, 4, 2, '2024-10-01', '2024-11-30'),
('Ethical Hacking Basics', 'Introduction to ethical hacking and cybersecurity fundamentals.', 199.99, 'Online', 35, 40.0, 5, 2, '2024-10-01', '2024-11-30'),
('Agile Project Management', 'Master the principles of Agile and Scrum.', 179.99, 'Offline', NULL, 30.0, 6, 2, NULL, NULL);


INSERT INTO SessionDetails (CourseId, Title, Description, VideoUrl, VideoOrder)
VALUES 
(4, 'Introduction to Web Development', 'Overview of web development and technologies.', 'https://example.com/web-development-intro', 1),
(4, 'Building APIs with Node.js', 'Learn to create APIs using Node.js.', 'https://example.com/nodejs-apis', 2),
(4, 'Frontend Development with React', 'Learn React for building user interfaces.', 'https://example.com/react-frontend', 3),
(5, 'Introduction to Cybersecurity', 'Overview of cybersecurity concepts and practices.', 'https://example.com/cybersecurity-intro', 1),
(5, 'Network Security Fundamentals', 'Learn about securing network infrastructure.', 'https://example.com/network-security', 2),
(5, 'Ethical Hacking Techniques', 'Introduction to ethical hacking tools and techniques.', 'https://example.com/ethical-hacking', 3),
(6, 'Introduction to Agile', 'Overview of Agile project management.', 'https://example.com/agile-intro', 1),
(6, 'Scrum Framework', 'Learn about the Scrum framework and roles.', 'https://example.com/scrum-framework', 2),
(6, 'Agile Tools and Techniques', 'Tools and techniques for Agile project management.', 'https://example.com/agile-tools', 3);


INSERT INTO Enrollment (CourseId, UserId, EnrollmentDate, PaymentStatus)
VALUES 
(4, 6, GETDATE(), 'Completed'),
(5, 6, GETDATE(), 'Pending'),
(6, 4, GETDATE(), 'Completed');





























































































































