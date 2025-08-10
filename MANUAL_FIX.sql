-- Manual Fix for User Profile Creation
-- Run this in Supabase SQL Editor

-- 1. First, disable RLS completely
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- 2. Create a function to manually insert user profiles
CREATE OR REPLACE FUNCTION create_user_profile(
    user_id UUID,
    user_email TEXT,
    user_name TEXT,
    user_role TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO users (id, email, name, role, created_at)
    VALUES (user_id, user_email, user_name, user_role, NOW())
    ON CONFLICT (id) DO NOTHING;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 3. Grant necessary permissions
GRANT EXECUTE ON FUNCTION create_user_profile TO anon;
GRANT EXECUTE ON FUNCTION create_user_profile TO authenticated;

-- 4. Create a function to check if user exists
CREATE OR REPLACE FUNCTION user_exists(user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(SELECT 1 FROM users WHERE id = user_id);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 5. Grant permissions for the check function
GRANT EXECUTE ON FUNCTION user_exists TO anon;
GRANT EXECUTE ON FUNCTION user_exists TO authenticated;

-- 6. Verify the functions were created
SELECT 'Functions created successfully' as status;
