# Quick Fix Guide - User Profile Creation

## **🔧 Issue: User Profile Not Being Created**

Even with RLS disabled, the user profile is not being created in the database. Here's the quick fix:

## **Step 1: Check if Users Table Exists**

1. **Go to Supabase Dashboard** → **Table Editor**
2. **Look for "users" table**
3. **If it doesn't exist**, run this SQL in **SQL Editor**:

```sql
-- Create users table if it doesn't exist
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('job_seeker', 'employer')),
    skills TEXT[] DEFAULT '{}',
    experience TEXT DEFAULT '',
    maternity_status BOOLEAN DEFAULT FALSE,
    resume_url TEXT DEFAULT '',
    company_name TEXT DEFAULT '',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Disable RLS on users table
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
```

## **Step 2: Create Helper Function (Optional)**

Run this in **SQL Editor** to create a helper function:

```sql
-- Create function to insert user profile
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
```

## **Step 3: Test Account Creation**

1. **Run the app**: `flutter run -d chrome`
2. **Try creating account** with:
   - Name: "Test User"
   - Email: "test@example.com" 
   - Password: "password123"
   - Role: "Job Seeker"

## **Step 4: Verify in Database**

1. **Go to Table Editor** → **users table**
2. **Click "Browse" tab**
3. **Check if your user appears** in the list

## **Alternative: Manual Profile Creation**

If automatic creation still fails, you can manually create the profile:

1. **After signing up**, note the user ID from console logs
2. **Go to SQL Editor** and run:

```sql
INSERT INTO users (id, email, name, role, created_at)
VALUES (
    'YOUR_USER_ID_HERE',
    'test@example.com',
    'Test User',
    'job_seeker',
    NOW()
);
```

## **Expected Result:**

- ✅ **Account creation** works
- ✅ **User profile** appears in database
- ✅ **Login** works with created account
- ✅ **No more "0 rows" errors**

## **If Still Having Issues:**

1. **Check browser console** for detailed error messages
2. **Verify table structure** matches the schema
3. **Try with a completely new email** address
4. **Clear browser cache** and try again

The account creation should work after these steps!
