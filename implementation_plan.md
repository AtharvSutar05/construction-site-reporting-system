# Auth Feature Improvement Plan

Based on a review of the current authentication implementation in your Flutter app, I have identified several architectural, security, and user experience improvements.

## User Review Required

Please review the proposed changes below. Let me know if you would like me to proceed with implementing them or if you have any additional requirements (like adding a specific Dependency Injection package such as `get_it` instead of simple constructor injection).

## Open Questions

1. **Dependency Injection**: Currently, dependencies are instantiated directly within classes (e.g., `final AuthRepository _authRepository = AuthRepository();` inside `AuthBloc`). I plan to use **Constructor Injection** for better testability. Are you open to using a DI container like `get_it`, or should we stick to simple constructor injection?
2. **Global 401 Handling**: When an API returns a 401 Unauthorized, how would you like the app to react globally? I propose adding an `onUnauthorized` callback to `ApiClient` to trigger a logout event automatically.

## Proposed Changes

### 1. Fix Security Flaw: Clearing Tokens on Logout
Currently, when a user logs out, the backend endpoint is called, but the local token is never deleted from `SecureStorageService` for mobile devices.

#### [MODIFY] `lib/features/auth/data/repositories/auth_repository.dart`
- Update the `logOut` method to call `await _secureStorageService.deleteAccessToken()` after successfully calling the API service.

### 2. Dependency Injection Refactoring
Hardcoded instantiations make the code difficult to test (mocking is impossible) and tightly couple the layers.

#### [MODIFY] `lib/features/auth/presentation/bloc/auth_bloc.dart`
- Inject `AuthRepository` and `SecureStorageService` via the constructor.

#### [MODIFY] `lib/features/auth/data/repositories/auth_repository.dart`
- Inject `AuthApiService` and `SecureStorageService` via the constructor.

#### [MODIFY] `lib/core/network/api_client.dart`
- Inject `SecureStorageService` via the constructor rather than instantiating it directly.

### 3. Improve BLoC Error Handling
In `auth_bloc.dart`, the `_onAuthCheckRequested` method blindly catches all exceptions and logs the user out (`emit(AuthUnauthenticated())`). 

#### [MODIFY] `lib/features/auth/presentation/bloc/auth_bloc.dart`
- Distinguish between a `401 Unauthorized` (which should trigger a logout) and a generic network error (which should maintain the session and perhaps show an offline state).

### 4. Global API 401 Handling
The `ApiClient` throws an `ApiException(401)` but does not proactively trigger an app-wide logout.

#### [MODIFY] `lib/core/network/api_client.dart`
- Add an optional `VoidCallback? onUnauthorized` callback that gets triggered when a 401 is encountered, allowing the app to log the user out seamlessly across any API call.

## Verification Plan

### Automated Tests
- No automated tests will be written during this refactor unless requested.

### Manual Verification
- **Login/Logout**: I will ask you to verify that logging in still navigates to the dashboard, and logging out properly clears the token (requiring a fresh login next time).
- **Session Check**: Verify that restarting the app maintains the session if the token is valid, and doesn't wipe the session if there's a simple network failure.
