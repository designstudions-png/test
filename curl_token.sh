curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'

# {"message":"User successfully registered","user":{"id":4,"email":"test@example.com","role":"user","created_at":"2026-01-06T15:05:03.715Z"},"api_token":"NZHjZqDyMnTL7r2wEfS8FVLw"}