-- Student Information System Database Schema

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('admin', 'student', 'faculty', 'staff') NOT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Students Table
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    student_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    suffix VARCHAR(10),
    birth_date DATE NOT NULL,
    birth_place VARCHAR(100) NOT NULL,
    country_of_birth VARCHAR(50) NOT NULL,
    civil_status ENUM('single', 'married', 'widowed', 'separated') NOT NULL,
    gender ENUM('male', 'female', 'other') NOT NULL,
    religion VARCHAR(50),
    mobile_number VARCHAR(20),
    telephone_number VARCHAR(20),
    email_address VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Addresses Table
CREATE TABLE addresses (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    address_type ENUM('present', 'permanent') NOT NULL,
    country VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    city_municipality VARCHAR(50) NOT NULL,
    house_street VARCHAR(100) NOT NULL,
    barangay VARCHAR(50) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Courses Table
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    units INT NOT NULL,
    description TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- Classes Table
CREATE TABLE classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    section VARCHAR(20) NOT NULL,
    school_year VARCHAR(9) NOT NULL,
    term ENUM('1st', '2nd', '3rd', 'summer') NOT NULL,
    schedule VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    enrolled INT DEFAULT 0,
    reserved INT DEFAULT 0,
    status ENUM('open', 'closed', 'cancelled') DEFAULT 'open',
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Enrollments Table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    class_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('registered', 'enrolled', 'dropped') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Grades Table
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT,
    midterm_grade DECIMAL(5,2),
    final_grade DECIMAL(5,2),
    remarks VARCHAR(50),
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
);

-- Scholarships Table
CREATE TABLE scholarships (
    scholarship_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_rate DECIMAL(5,2) NOT NULL,
    requirements TEXT,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- Student Scholarships Table
CREATE TABLE student_scholarships (
    student_scholarship_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    scholarship_id INT,
    school_year VARCHAR(9) NOT NULL,
    term ENUM('1st', '2nd', '3rd', 'summer') NOT NULL,
    status ENUM('pending', 'approved', 'rejected') NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(scholarship_id)
);

-- Documents Table
CREATE TABLE documents (
    document_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    category ENUM('academic_calendar', 'registrar_manual', 'student_handbook') NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    uploaded_by INT,
    valid_until DATE,
    require_agreement BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Teacher Evaluations Table
CREATE TABLE teacher_evaluations (
    evaluation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    class_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 7),
    comments TEXT,
    evaluation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

-- Financial Transactions Table
CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    transaction_type ENUM('payment', 'assessment') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reference_number VARCHAR(50),
    description TEXT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Clearances Table
CREATE TABLE clearances (
    clearance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    office VARCHAR(50) NOT NULL,
    status ENUM('pending', 'cleared', 'blocked') NOT NULL,
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- Create indexes for better performance
CREATE INDEX idx_student_number ON students(student_number);
CREATE INDEX idx_course_code ON courses(course_code);
CREATE INDEX idx_enrollment_status ON enrollments(status);
CREATE INDEX idx_class_schedule ON classes(schedule);
CREATE INDEX idx_transaction_date ON financial_transactions(transaction_date);
CREATE INDEX idx_clearance_status ON clearances(status); 