# Supabase Setup Guide

## **🔧 Database Setup Required**

The account creation is failing because the Supabase database schema needs to be set up. Follow these steps:

## **Step 1: Access Supabase Dashboard**

1. **Go to**: https://supabase.com/dashboard
2. **Sign in** to your account
3. **Select your project**: `tdarvqbnuoloxndknqqq`

## **Step 2: Run Database Schema**

1. **Click on "SQL Editor"** in the left sidebar
2. **Click "New Query"**
3. **Copy and paste** the entire content from `supabase_schema.sql`
4. **Click "Run"** to execute the schema

## **Step 3: Verify Tables Created**

1. **Go to "Table Editor"** in the left sidebar
2. **Verify these tables exist**:
   - ✅ `users`
   - ✅ `jobs` 
   - ✅ `applications`

## **Step 4: Check RLS Policies**

1. **Click on each table** in Table Editor
2. **Go to "Policies" tab**
3. **Verify RLS is enabled** and policies are created

## **Step 5: Test Account Creation**

1. **Run the app**: `flutter run -d chrome`
2. **Try creating an account** with:
   - Name: "Test User"
   - Email: "test@example.com"
   - Password: "password123"
   - Role: "Job Seeker"

## **Alternative: Quick Fix**

If you want to test without the full schema, you can temporarily disable RLS:

1. **Go to "Table Editor"**
2. **Click on "users" table**
3. **Go to "Settings" tab**
4. **Disable RLS** temporarily
5. **Try creating account again**

## **Common Issues & Solutions:**

### **Issue: "Table doesn't exist"**
- **Solution**: Run the schema SQL in SQL Editor

### **Issue: "Permission denied"**
- **Solution**: Check RLS policies or temporarily disable RLS

### **Issue: "Invalid role"**
- **Solution**: Make sure the role values match: 'job_seeker' or 'employer'

### **Issue: "Email already exists"**
- **Solution**: Use a different email address

## **Expected Behavior After Setup:**

- ✅ **Account creation** works
- ✅ **Login** works with created account
- ✅ **User profile** loads correctly
- ✅ **Job listings** display
- ✅ **Job details** accessible

## **If Still Having Issues:**

1. **Check browser console** for error messages
2. **Check Supabase logs** in the dashboard
3. **Verify Supabase URL and key** in `lib/utils/supabase_config.dart`
4. **Try with a fresh email** address

The account creation should work once the database schema is properly set up!
