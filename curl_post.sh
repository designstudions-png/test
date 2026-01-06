# Регистрация
# curl -X POST http://localhost:3000/api/v1/auth/register \
#   -H "Content-Type: application/json" \
#   -d '{"user":{"email":"test@test.com","password":"123456","password_confirmation":"123456"}}'

# Создание поста (с полученным токеном)
# curl -X POST http://localhost:3000/api/v1/posts \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer NZHjZqDyMnTL7r2wEfS8FVLw" \
#   -d '{"post":{"title":"Test","body":"Content"}}'


curl -X POST http://localhost:3000/api/v1/posts \
  -H "Authorization: Bearer NZHjZqDyMnTL7r2wEfS8FVLw" \
  -F "post[title]=Заголовок с картинкой" \
  -F "post[body]=Текст поста с прикрепленным файлом" \
  -F "images[]=@./image.png"
