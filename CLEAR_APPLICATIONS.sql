-- Clear all existing applications to ensure only real-time submissions are shown
-- Run this in your Supabase SQL Editor

-- Delete all existing applications
DELETE FROM applications;

-- Reset the sequence if you're using auto-incrementing IDs
-- (This is optional, but helps keep IDs clean)
-- ALTER SEQUENCE applications_id_seq RESTART WITH 1;

-- Verify the table is empty
SELECT COUNT(*) as application_count FROM applications;

-- This will ensure that only applications submitted through the "Apply Now" button are shown
-- in the "My Applications" screen
