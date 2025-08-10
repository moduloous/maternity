# Login Troubleshooting Guide

If you're having trouble logging in, follow these steps to identify and fix the issue.

## **Step 1: Check Database Setup**

### **1.1 Verify Database Schema**

1. Go to your Supabase dashboard: https://supabase.com/dashboard/project/tdarvqbnuoloxndknqqq
2. Navigate to **SQL Editor**
3. Run the complete `supabase_schema.sql` file
4. Verify the tables exist by running:
   ```sql
   SELECT * FROM users LIMIT 1;
   ```

### **1.2 Check if Tables Exist**

If you get an error saying tables don't exist, run the schema file first.

## **Step 2: Check Authentication Settings**

### **2.1 Verify Email Confirmation is Disabled**

1. Go to **Authentication** → **CONFIGURATION**
2. Click on **"General user signup"**
3. Make sure **"Enable email confirmations"** is **OFF**
4. Click **"Save"**

### **2.2 Check Site URL and Redirect URLs**

1. In **Authentication** → **CONFIGURATION** → **"General user signup"**
2. Set **Site URL**: `http://localhost:3000`
3. Add **Redirect URLs**: `http://localhost:3000/auth/callback`
4. Click **"Save"**

## **Step 3: Test the App**

### **3.1 Run the App with Debug Logging**

```bash
flutter run -d chrome
```

### **3.2 Check Console Output**

Open browser developer tools (F12) and check the console for:
- Authentication errors
- Database connection errors
- Router redirect messages

### **3.3 Test Signup First**

1. Create a new account using the signup form
2. Check if you're redirected to the home page
3. If signup works, try logging out and logging back in

## **Step 4: Common Issues and Solutions**

### **Issue 1: "User not found" error**

**Cause**: User profile doesn't exist in the `users` table
**Solution**: 
1. Check if the user was created in Supabase Auth
2. Check if the user profile was created in the `users` table
3. Manually create the profile if missing:

```sql
INSERT INTO users (id, email, name, role, created_at)
VALUES ('USER_ID_FROM_AUTH', 'user@example.com', 'User Name', 'job_seeker', NOW());
```

### **Issue 2: "Invalid credentials" error**

**Cause**: Wrong email/password or user doesn't exist
**Solution**:
1. Verify the email and password are correct
2. Check if the user exists in Supabase Auth
3. Try resetting the password

### **Issue 3: App stays on login page**

**Cause**: Router not detecting authentication state
**Solution**:
1. Check console for router redirect messages
2. Verify AuthProvider is properly updating
3. Check if `notifyListeners()` is being called

### **Issue 4: Database connection errors**

**Cause**: Wrong Supabase credentials or network issues
**Solution**:
1. Verify Supabase URL and Anon Key in `lib/utils/supabase_config.dart`
2. Check internet connection
3. Verify Supabase project is active

## **Step 5: Manual Testing**

### **5.1 Test Database Connection**

Add this to your app temporarily to test the connection:

```dart
// In any screen, add this button
ElevatedButton(
  onPressed: () async {
    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select()
          .limit(1);
      print('Database connection successful: $response');
    } catch (e) {
      print('Database connection failed: $e');
    }
  },
  child: Text('Test Database'),
)
```

### **5.2 Test Authentication**

Add this to test authentication:

```dart
ElevatedButton(
  onPressed: () async {
    try {
      final user = SupabaseConfig.client.auth.currentUser;
      print('Current user: ${user?.email}');
    } catch (e) {
      print('Auth error: $e');
    }
  },
  child: Text('Test Auth'),
)
```

## **Step 6: Debug Information**

### **6.1 Check Current User**

In the browser console, you can check:
```javascript
// Check if user is authenticated
console.log('Current user:', supabase.auth.user());

// Check user profile
supabase.from('users').select().then(console.log);
```

### **6.2 Check Router State**

The app will log router redirect information to help debug navigation issues.

## **Step 7: Reset and Start Fresh**

If nothing works:

1. **Clear browser data** (cookies, local storage)
2. **Delete all users** from Supabase Auth
3. **Drop and recreate tables**:
   ```sql
   DROP TABLE IF EXISTS applications;
   DROP TABLE IF EXISTS jobs;
   DROP TABLE IF EXISTS users;
   ```
4. **Run the schema file again**
5. **Create a new test account**

## **Step 8: Contact Support**

If you're still having issues:

1. **Check the console output** and share any error messages
2. **Verify your Supabase project** is active and has the correct settings
3. **Test with a simple email/password** (e.g., test@test.com / password123)

---

## **✅ Quick Checklist**

- [ ] Database schema is set up
- [ ] Email confirmation is disabled
- [ ] Site URL and redirect URLs are configured
- [ ] Supabase credentials are correct
- [ ] User exists in both Auth and users table
- [ ] No console errors
- [ ] Router is redirecting properly

Follow these steps and the login should work correctly!
