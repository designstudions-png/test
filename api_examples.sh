#!/bin/bash

# ============================================
# API Examples для Rails Blog
# ============================================
#
# Этот скрипт содержит примеры запросов к API
# Перед использованием убедитесь, что сервер запущен:
# rails server
#
# Использование:
# chmod +x api_examples.sh
# ./api_examples.sh
# ============================================

BASE_URL="http://localhost:3000/api/v1"
API_TOKEN=""

echo "======================================"
echo "  Rails Blog API - Примеры запросов"
echo "======================================"
echo ""

# ============================================
# 1. РЕГИСТРАЦИЯ ПОЛЬЗОВАТЕЛЯ
# ============================================
echo "1️⃣  Регистрация нового пользователя..."
echo "---"

REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "testuser@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }')

echo "$REGISTER_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$REGISTER_RESPONSE"
echo ""

# Извлекаем API токен из ответа
API_TOKEN=$(echo "$REGISTER_RESPONSE" | grep -o '"api_token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$API_TOKEN" ]; then
  echo "⚠️  Не удалось получить API токен. Возможно пользователь уже существует."
  echo "Попытка входа..."
  echo ""

  # ============================================
  # 2. ВХОД В СИСТЕМУ
  # ============================================
  echo "2️⃣  Вход в систему..."
  echo "---"

  LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
    -H "Content-Type: application/json" \
    -d '{
      "email": "testuser@example.com",
      "password": "password123"
    }')

  echo "$LOGIN_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$LOGIN_RESPONSE"
  echo ""

  API_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"api_token":"[^"]*"' | cut -d'"' -f4)
else
  echo "✅ Регистрация успешна!"
  echo ""
fi

if [ -z "$API_TOKEN" ]; then
  echo "❌ Ошибка: Не удалось получить API токен. Проверьте сервер."
  exit 1
fi

echo "🔑 API Token: $API_TOKEN"
echo ""
sleep 1

# ============================================
# 3. ПОЛУЧЕНИЕ ИНФОРМАЦИИ О ТЕКУЩЕМ ПОЛЬЗОВАТЕЛЕ
# ============================================
echo "3️⃣  Получение информации о текущем пользователе..."
echo "---"

curl -s -X GET $BASE_URL/auth/me \
  -H "Authorization: Bearer $API_TOKEN" \
  | python3 -m json.tool 2>/dev/null || curl -s -X GET $BASE_URL/auth/me -H "Authorization: Bearer $API_TOKEN"

echo ""
echo ""
sleep 1

# ============================================
# 4. СОЗДАНИЕ ПОСТА
# ============================================
echo "4️⃣  Создание нового поста..."
echo "---"

CREATE_POST_RESPONSE=$(curl -s -X POST $BASE_URL/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{
    "post": {
      "title": "Мой первый пост через API",
      "body": "Это содержимое моего первого поста, созданного через RESTful API. Ruby on Rails - отличный фреймворк!"
    }
  }')

echo "$CREATE_POST_RESPONSE" | python3 -m json.tool 2>/dev/null || echo "$CREATE_POST_RESPONSE"
echo ""

# Извлекаем ID созданного поста
POST_ID=$(echo "$CREATE_POST_RESPONSE" | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)
echo "✅ Пост создан с ID: $POST_ID"
echo ""
sleep 1

# ============================================
# 5. ПОЛУЧЕНИЕ СПИСКА ВСЕХ ПОСТОВ
# ============================================
echo "5️⃣  Получение списка всех постов..."
echo "---"

curl -s -X GET "$BASE_URL/posts" \
  | python3 -m json.tool 2>/dev/null || curl -s -X GET "$BASE_URL/posts"

echo ""
echo ""
sleep 1

# ============================================
# 6. ПОЛУЧЕНИЕ СПИСКА ПОСТОВ С ПАГИНАЦИЕЙ
# ============================================
echo "6️⃣  Получение списка постов (страница 1, по 5 постов)..."
echo "---"

curl -s -X GET "$BASE_URL/posts?page=1&per_page=5" \
  | python3 -m json.tool 2>/dev/null || curl -s -X GET "$BASE_URL/posts?page=1&per_page=5"

echo ""
echo ""
sleep 1

# ============================================
# 7. ПОИСК ПОСТОВ
# ============================================
echo "7️⃣  Поиск постов по ключевому слову 'API'..."
echo "---"

curl -s -X GET "$BASE_URL/posts?query=API" \
  | python3 -m json.tool 2>/dev/null || curl -s -X GET "$BASE_URL/posts?query=API"

echo ""
echo ""
sleep 1

# ============================================
# 8. ПОЛУЧЕНИЕ КОНКРЕТНОГО ПОСТА
# ============================================
if [ ! -z "$POST_ID" ]; then
  echo "8️⃣  Получение поста с ID: $POST_ID..."
  echo "---"

  curl -s -X GET "$BASE_URL/posts/$POST_ID" \
    | python3 -m json.tool 2>/dev/null || curl -s -X GET "$BASE_URL/posts/$POST_ID"

  echo ""
  echo ""
  sleep 1
fi

# ============================================
# 9. ОБНОВЛЕНИЕ ПОСТА
# ============================================
if [ ! -z "$POST_ID" ]; then
  echo "9️⃣  Обновление поста с ID: $POST_ID..."
  echo "---"

  curl -s -X PATCH "$BASE_URL/posts/$POST_ID" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" \
    -d '{
      "post": {
        "title": "Обновленный заголовок поста",
        "body": "Это обновленное содержимое поста. Теперь пост содержит новую информацию!"
      }
    }' \
    | python3 -m json.tool 2>/dev/null || curl -s -X PATCH "$BASE_URL/posts/$POST_ID" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" \
    -d '{"post":{"title":"Обновленный заголовок поста","body":"Это обновленное содержимое поста. Теперь пост содержит новую информацию!"}}'

  echo ""
  echo ""
  sleep 1
fi

# ============================================
# 10. СОЗДАНИЕ ВТОРОГО ПОСТА
# ============================================
echo "🔟 Создание второго поста..."
echo "---"

curl -s -X POST $BASE_URL/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{
    "post": {
      "title": "Второй пост про Ruby on Rails",
      "body": "Ruby on Rails позволяет быстро создавать веб-приложения с помощью соглашений над конфигурацией."
    }
  }' \
  | python3 -m json.tool 2>/dev/null || curl -s -X POST $BASE_URL/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"post":{"title":"Второй пост про Ruby on Rails","body":"Ruby on Rails позволяет быстро создавать веб-приложения с помощью соглашений над конфигурацией."}}'

echo ""
echo ""
sleep 1

# ============================================
# 11. УДАЛЕНИЕ ПОСТА
# ============================================
if [ ! -z "$POST_ID" ]; then
  echo "1️⃣1️⃣  Удаление поста с ID: $POST_ID..."
  echo "---"
  echo "⚠️  Пост будет удален через 3 секунды..."
  sleep 3

  curl -s -X DELETE "$BASE_URL/posts/$POST_ID" \
    -H "Authorization: Bearer $API_TOKEN" \
    | python3 -m json.tool 2>/dev/null || curl -s -X DELETE "$BASE_URL/posts/$POST_ID" -H "Authorization: Bearer $API_TOKEN"

  echo ""
  echo "✅ Пост удален"
  echo ""
fi

# ============================================
# 12. ВЫХОД ИЗ СИСТЕМЫ
# ============================================
echo "1️⃣2️⃣  Выход из системы (инвалидация токена)..."
echo "---"

curl -s -X POST $BASE_URL/auth/logout \
  -H "Authorization: Bearer $API_TOKEN" \
  | python3 -m json.tool 2>/dev/null || curl -s -X POST $BASE_URL/auth/logout -H "Authorization: Bearer $API_TOKEN"

echo ""
echo ""

# ============================================
# 13. ПОПЫТКА СОЗДАТЬ ПОСТ С НЕДЕЙСТВИТЕЛЬНЫМ ТОКЕНОМ
# ============================================
echo "1️⃣3️⃣  Попытка создать пост с недействительным токеном (должна вернуть ошибку)..."
echo "---"

curl -s -X POST $BASE_URL/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{
    "post": {
      "title": "Этот пост не должен быть создан",
      "body": "Токен был инвалидирован"
    }
  }' \
  | python3 -m json.tool 2>/dev/null || curl -s -X POST $BASE_URL/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"post":{"title":"Этот пост не должен быть создан","body":"Токен был инвалидирован"}}'

echo ""
echo ""

# ============================================
# ЗАВЕРШЕНИЕ
# ============================================
echo "======================================"
echo "✅ Все тесты завершены!"
echo "======================================"
echo ""
echo "📚 Для получения дополнительной информации см.:"
echo "   - API_DOCUMENTATION.md"
echo "   - API_SETUP.md"
echo ""
echo "💡 Полезные команды:"
echo "   rails console    # Открыть Rails консоль"
echo "   rails routes     # Посмотреть все маршруты"
echo "   rails routes | grep api  # Только API маршруты"
echo ""
