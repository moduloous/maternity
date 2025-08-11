-- Maternity Jobs App - Supabase Database Schema
-- Run this SQL in your Supabase SQL editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('job_seeker', 'employer')),
    skills TEXT[],
    experience TEXT,
    maternity_status BOOLEAN,
    resume_url TEXT,
    company_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create jobs table
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    company TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('full_time', 'part_time', 'remote', 'contract')),
    description TEXT NOT NULL,
    maternity_friendly BOOLEAN DEFAULT FALSE,
    employer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create applications table (updated with new fields)
CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    applicant_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT NOT NULL,
    resume_url TEXT,
    job_title TEXT,
    company_name TEXT,
    status TEXT DEFAULT 'Applied',
    location TEXT,
    salary TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_jobs_employer_id ON jobs(employer_id);
CREATE INDEX idx_jobs_maternity_friendly ON jobs(maternity_friendly);
CREATE INDEX idx_jobs_created_at ON jobs(created_at DESC);
CREATE INDEX idx_applications_job_id ON applications(job_id);
CREATE INDEX idx_applications_applicant_id ON applications(applicant_id);
CREATE INDEX idx_applications_created_at ON applications(created_at DESC);

-- Set up Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

-- Anyone can read jobs
CREATE POLICY "Anyone can view jobs" ON jobs
    FOR SELECT USING (true);

-- Employers can create jobs
CREATE POLICY "Employers can create jobs" ON jobs
    FOR INSERT WITH CHECK (auth.uid() = employer_id);

-- Employers can update their own jobs
CREATE POLICY "Employers can update own jobs" ON jobs
    FOR UPDATE USING (auth.uid() = employer_id);

-- Employers can delete their own jobs
CREATE POLICY "Employers can delete own jobs" ON jobs
    FOR DELETE USING (auth.uid() = employer_id);

-- Anyone can create applications
CREATE POLICY "Anyone can create applications" ON applications
    FOR INSERT WITH CHECK (true);

-- Users can view applications for jobs they posted
CREATE POLICY "Employers can view applications for their jobs" ON applications
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM jobs 
            WHERE jobs.id = applications.job_id 
            AND jobs.employer_id = auth.uid()
        )
    );

-- Users can view their own applications
CREATE POLICY "Users can view own applications" ON applications
    FOR SELECT USING (auth.uid() = applicant_id);

-- Users can delete their own applications
CREATE POLICY "Users can delete own applications" ON applications
    FOR DELETE USING (auth.uid() = applicant_id);

-- Insert sample data (optional)
INSERT INTO users (id, email, name, role, company_name) VALUES
    (uuid_generate_v4(), 'employer@example.com', 'Tech Corp', 'employer', 'Tech Corp Inc.'),
    (uuid_generate_v4(), 'jobseeker@example.com', 'Jane Doe', 'job_seeker', NULL);

-- Insert sample jobs
INSERT INTO jobs (title, company, type, description, maternity_friendly, employer_id) VALUES
    ('Software Engineer', 'Tech Corp Inc.', 'full_time', 'We are looking for a talented software engineer to join our team. This position offers flexible working hours and maternity-friendly policies.', true, (SELECT id FROM users WHERE email = 'employer@example.com')),
    ('Marketing Manager', 'Tech Corp Inc.', 'part_time', 'Part-time marketing manager position with remote work options and family-friendly benefits.', true, (SELECT id FROM users WHERE email = 'employer@example.com')),
    ('Data Analyst', 'Tech Corp Inc.', 'remote', 'Remote data analyst position with flexible scheduling and comprehensive benefits package.', false, (SELECT id FROM users WHERE email = 'employer@example.com'));
