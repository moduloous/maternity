# Windows Setup Guide

## **🔧 Fix Windows Developer Mode Issue**

The error "Building with plugins requires symlink support" means Windows needs Developer Mode enabled.

## **Step 1: Enable Developer Mode**

1. **Press `Windows + I`** to open Settings
2. **Click on "Privacy & Security"**
3. **Scroll down and click "For developers"**
4. **Turn ON "Developer Mode"**
5. **Restart your computer**

## **Step 2: Alternative - Run in Web Mode**

If you don't want to enable Developer Mode, you can run the app in web mode:

```bash
flutter run -d chrome --web-port=3000
```

## **Step 3: Test the App**

After enabling Developer Mode or using web mode:

1. **Run the app**: `flutter run`
2. **Try creating an account** with:
   - Name: "Test User"
   - Email: "test@example.com"
   - Password: "password123"
   - Role: "Job Seeker"

## **Step 4: Check Console Logs**

The app should now work without errors. You should see:
- ✅ Account creation successful
- ✅ Navigation to home page
- ✅ Login functionality working

## **If Still Having Issues:**

1. **Clear Flutter cache**: `flutter clean && flutter pub get`
2. **Restart VS Code/IDE**
3. **Try web mode**: `flutter run -d chrome`

The app should work perfectly once Developer Mode is enabled!
