# 🚀 API Quick Start Guide

Быстрое руководство по использованию Rails Blog API

## 📦 Установка и запуск

```bash
# 1. Установите зависимости
bundle install

# 2. Настройте базу данных
rails db:migrate

# 3. Запустите сервер
rails server
```

Сервер запустится на: **http://localhost:3000**

---

## 🔥 Быстрый тест

### 1. Регистрация пользователя

```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'
```

**Ответ:**
```json
{
  "message": "User successfully registered",
  "api_token": "abc123xyz..."
}
```

💡 **Сохраните `api_token` - он понадобится для дальнейших запросов!**

---

### 2. Создание поста

Замените `YOUR_TOKEN` на токен из предыдущего шага:

```bash
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "post": {
      "title": "Hello World",
      "body": "My first post via API!"
    }
  }'
```

---

### 3. Получение списка постов

```bash
curl http://localhost:3000/api/v1/posts
```

---

## 🎯 Основные эндпоинты

### Аутентификация
```
POST   /api/v1/auth/register    # Регистрация
POST   /api/v1/auth/login        # Вход
GET    /api/v1/auth/me           # Текущий пользователь
POST   /api/v1/auth/logout       # Выход
```

### Посты
```
GET    /api/v1/posts             # Список постов
GET    /api/v1/posts/:id         # Один пост
POST   /api/v1/posts             # Создать (требует токен)
PATCH  /api/v1/posts/:id         # Обновить (требует токен)
DELETE /api/v1/posts/:id         # Удалить (требует токен)
```

---

## 🔐 Аутентификация

Для защищенных эндпоинтов добавьте заголовок:

```
Authorization: Bearer YOUR_API_TOKEN
```

---

## 📊 Пагинация и поиск

```bash
# Пагинация
curl "http://localhost:3000/api/v1/posts?page=1&per_page=10"

# Поиск
curl "http://localhost:3000/api/v1/posts?query=rails"

# Фильтр по пользователю
curl "http://localhost:3000/api/v1/posts?user_id=1"
```

---

## 🐛 Примеры с JavaScript

```javascript
// Регистрация
const register = async () => {
  const response = await fetch('http://localhost:3000/api/v1/auth/register', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      user: {
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    })
  });
  const data = await response.json();
  return data.api_token;
};

// Создание поста
const createPost = async (token) => {
  const response = await fetch('http://localhost:3000/api/v1/posts', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      post: {
        title: 'My Post',
        body: 'Post content'
      }
    })
  });
  return await response.json();
};

// Использование
const token = await register();
const post = await createPost(token);
console.log(post);
```

---

## 🐍 Примеры с Python

```python
import requests

BASE_URL = 'http://localhost:3000/api/v1'

# Регистрация
response = requests.post(f'{BASE_URL}/auth/register', json={
    'user': {
        'email': 'test@example.com',
        'password': 'password123',
        'password_confirmation': 'password123'
    }
})
token = response.json()['api_token']

# Создание поста
headers = {'Authorization': f'Bearer {token}'}
response = requests.post(f'{BASE_URL}/posts', 
    headers=headers,
    json={'post': {'title': 'My Post', 'body': 'Content'}}
)
print(response.json())
```

---

## ✅ Коды ответов

| Код | Значение |
|-----|----------|
| 200 | OK - Успешный запрос |
| 201 | Created - Ресурс создан |
| 401 | Unauthorized - Нет токена или он неверный |
| 403 | Forbidden - Недостаточно прав |
| 404 | Not Found - Ресурс не найден |
| 422 | Unprocessable Entity - Ошибка валидации |

---

## 🧪 Тестовый скрипт

Запустите готовый тестовый скрипт:

```bash
chmod +x api_examples.sh
./api_examples.sh
```

---

## 📚 Дополнительная документация

- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Полная документация
- **[API_SETUP.md](API_SETUP.md)** - Подробная инструкция по настройке
- **[postman_collection.json](postman_collection.json)** - Коллекция для Postman

---

## 🛠️ Инструменты для тестирования

### Postman
1. Импортируйте `postman_collection.json`
2. Запустите "Register User"
3. Токен сохранится автоматически

### cURL (встроен в терминал)
```bash
curl http://localhost:3000/api/v1/posts
```

### HTTPie (более удобный)
```bash
# Установка
pip install httpie

# Использование
http POST localhost:3000/api/v1/auth/register \
  user:='{"email":"test@test.com","password":"123456","password_confirmation":"123456"}'
```

---

## ❓ Частые вопросы

**Q: Где взять API токен?**  
A: Получите его при регистрации (`/api/v1/auth/register`) или входе (`/api/v1/auth/login`)

**Q: Токен перестал работать?**  
A: Токен инвалидируется при выходе. Войдите снова для получения нового.

**Q: Как загрузить изображение?**  
A: Используйте multipart/form-data с полем `images[]`

**Q: Сколько постов можно получить за раз?**  
A: Максимум 100 постов на странице (параметр `per_page`)

---

## 🚨 Решение проблем

### Ошибка: "Missing authentication token"
Добавьте заголовок: `Authorization: Bearer YOUR_TOKEN`

### Ошибка: "Invalid authentication token"
Токен истек или неверен. Войдите снова.

### Ошибка: "Couldn't find Post with 'id'=X"
Пост с таким ID не существует. Проверьте ID.

---

## 📞 Нужна помощь?

1. Проверьте логи: `tail -f log/development.log`
2. Откройте Rails консоль: `rails console`
3. Посмотрите все маршруты: `rails routes | grep api`

---

**Готово! Теперь вы можете создавать посты через API! 🎉**