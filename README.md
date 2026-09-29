# EduVerse AI — School Authentication + Student Personalization Flow

This build extends the responsive EduVerse school app with a modular post-signup onboarding flow.

## Flow

Welcome → Onboarding → Login → Signup → OTP Verification → Student Personalization → Ready → Dashboard placeholder

For students, personalization asks:
1. Reuses signup details automatically (no retyping)
2. Class 1–12
3. Stage: Primary 1–5, Middle 6–8, High School 9–10, Intermediate 11–12
4. Subjects tailored to the selected class
5. Career/profession goals
6. Hobbies
7. Daily study hours using a slider
8. Indian school board
9. Personalized setup summary

## OTP development mode
Use `123456` for the signup OTP. Replace `LocalAuthRepository` with a production email/SMS/Supabase/REST repository later.

## Architecture
- AuthService: business/use-case layer
- AuthRepository: backend contract
- LocalAuthRepository: development adapter
- OtpVerificationScreen: verification UI
- StudentOnboardingFlow: student-specific personalization
- StudentCurriculum: class/stage/subject/goal/hobby/board configuration

## Run
```bash
flutter clean
flutter pub get
flutter run
```

All screens use responsive constraints and scrolling rather than fixed screen dimensions.
