# Disable Email Verification in Supabase

This guide will help you disable email verification in your Supabase project so users can sign up and immediately access the app.

## **Step 1: Configure Supabase Authentication Settings**

### **1.1 Disable Email Confirmation**

1. Go to your Supabase dashboard: https://supabase.com/dashboard/project/tdarvqbnuoloxndknqqq
2. Navigate to **Authentication** → **CONFIGURATION**
3. Click on **"General user signup"**
4. Find the **"Enable email confirmations"** option
5. **Toggle it OFF** to disable email verification
6. Click **"Save"**

### **1.2 Alternative: Disable via SQL**

You can also disable email verification by running this SQL in your Supabase SQL editor:

```sql
-- Disable email confirmation requirement
UPDATE auth.config 
SET enable_signup = true,
    enable_email_confirmations = false;
```

## **Step 2: Test the Changes**

1. **Run your app**: `flutter run`
2. **Create a new account** using the signup form
3. **Verify** that you can immediately log in without email verification

## **Step 3: Update User Management (Optional)**

If you want to manually confirm existing users who haven't verified their email:

```sql
-- Confirm all existing users (run in Supabase SQL editor)
UPDATE auth.users 
SET email_confirmed_at = NOW() 
WHERE email_confirmed_at IS NULL;
```

## **Security Considerations**

⚠️ **Important**: Disabling email verification means:
- Users can sign up with any email address
- No verification that the email is real/accessible
- Potential for spam accounts

### **Alternative Security Measures:**

1. **Rate Limiting**: Limit signup attempts per IP
2. **CAPTCHA**: Add CAPTCHA to signup forms
3. **Phone Verification**: Use SMS verification instead
4. **Admin Approval**: Require admin approval for new accounts

## **Production Recommendations**

For production apps, consider:
- **Keeping email verification enabled** for security
- **Using social login** (Google, GitHub, etc.) as an alternative
- **Implementing additional verification methods**

---

## **✅ Email Verification is Now Disabled!**

Users can now sign up and immediately access your Maternity Jobs app without needing to verify their email address.
