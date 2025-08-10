# Maternity Jobs App - Setup Guide

This guide will help you set up and run the Maternity Jobs Flutter app with Supabase backend.

## Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code with Flutter extensions
- Supabase account (free tier available)

## Step 1: Clone and Setup Project

```bash
# Clone the repository (if using git)
git clone <repository-url>
cd flutter_application

# Install dependencies
flutter pub get
```

## Step 2: Supabase Setup

### 2.1 Create Supabase Project
1. Go to [supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - Name: `maternity-jobs-app`
   - Database Password: (create a strong password)
   - Region: Choose closest to you
5. Click "Create new project"
6. Wait for project to be ready (2-3 minutes)

### 2.2 Get Project Credentials
1. Go to Settings → API
2. Copy the following:
   - Project URL
   - Anon public key

### 2.3 Setup Database Schema
1. Go to SQL Editor in your Supabase dashboard
2. Copy and paste the entire content from `supabase_schema.sql`
3. Click "Run" to execute the SQL
4. Verify tables are created in Table Editor

### 2.4 Setup Storage
1. Go to Storage in Supabase dashboard
2. Click "Create a new bucket"
3. Name: `documents`
4. Set to "Public bucket"
5. Click "Create bucket"
6. Inside the bucket, create a folder called `resumes`

### 2.5 Configure Authentication
1. Go to Authentication → Settings
2. Configure email templates (optional)
3. Set redirect URLs if needed

## Step 3: Configure App

### 3.1 Update Supabase Credentials
Edit `lib/utils/supabase_config.dart`:
```dart
static const String supabaseUrl = 'YOUR_PROJECT_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

### 3.2 Add Fonts (Optional)
1. Download Poppins font from [Google Fonts](https://fonts.google.com/specimen/Poppins)
2. Extract and place these files in `assets/fonts/`:
   - `Poppins-Regular.ttf`
   - `Poppins-Medium.ttf`
   - `Poppins-SemiBold.ttf`
   - `Poppins-Bold.ttf`

## Step 4: Run the App

```bash
# Check if everything is set up correctly
flutter doctor

# Run the app
flutter run
```

## Step 5: Test the App

### 5.1 Test Authentication
1. Open the app
2. Create a new account (both job seeker and employer roles)
3. Test login/logout functionality
4. Test password reset

### 5.2 Test Job Features
1. Login as an employer
2. Post a new job
3. Login as a job seeker
4. Browse jobs and apply filters
5. Save jobs and view saved jobs
6. Submit job applications

## Troubleshooting

### Common Issues:

#### 1. Supabase Connection Error
- Verify URL and anon key are correct
- Check if Supabase project is active
- Ensure RLS policies are set up correctly

#### 2. Font Loading Error
- App will work without Poppins fonts (uses system default)
- Verify font file names match exactly
- Check font files are in correct directory

#### 3. Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### 4. Permission Issues (Android)
- Add camera and storage permissions to `android/app/src/main/AndroidManifest.xml`
- For file picker functionality

## Sample Data

The SQL schema includes sample data:
- Employer: `employer@example.com` / `password123`
- Job Seeker: `jobseeker@example.com` / `password123`
- Sample jobs with maternity-friendly flags

## Production Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Security Notes

- Never commit real Supabase credentials to version control
- Use environment variables for production
- Regularly rotate API keys
- Monitor Supabase usage and costs

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review Supabase documentation
3. Check Flutter documentation
4. Open an issue in the project repository

## Next Steps

After successful setup:
1. Customize the UI theme in `lib/utils/theme.dart`
2. Add more features like push notifications
3. Implement advanced search filters
4. Add analytics and monitoring
5. Set up CI/CD pipeline
