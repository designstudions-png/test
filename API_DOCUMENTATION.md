# API Документация

## Обзор

RESTful API для управления постами в Rails приложении. API использует JSON для обмена данными и token-based аутентификацию.

## Базовый URL

```
http://localhost:3000/api/v1
```

## Аутентификация

Для доступа к защищенным эндпоинтам необходимо включить API токен в заголовок запроса:

```
Authorization: Bearer YOUR_API_TOKEN
```

API токен выдается при регистрации или входе в систему.

---

## Эндпоинты

### Аутентификация

#### 1. Регистрация пользователя

Создает нового пользователя и возвращает API токен.

**Endpoint:** `POST /api/v1/auth/register`

**Требуется аутентификация:** Нет

**Body:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

**Успешный ответ (201):**
```json
{
  "message": "User successfully registered",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "role": "user",
    "created_at": "2026-01-06T14:45:43.000Z"
  },
  "api_token": "your_api_token_here"
}
```

**Ошибка (422):**
```json
{
  "error": "Registration failed",
  "messages": [
    "Email has already been taken"
  ]
}
```

---

#### 2. Вход в систему

Аутентифицирует пользователя и возвращает API токен.

**Endpoint:** `POST /api/v1/auth/login`

**Требуется аутентификация:** Нет

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Успешный ответ (200):**
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "role": "user",
    "created_at": "2026-01-06T14:45:43.000Z"
  },
  "api_token": "your_api_token_here"
}
```

**Ошибка (401):**
```json
{
  "error": "Invalid email or password"
}
```

---

#### 3. Выход из системы

Инвалидирует текущий API токен (генерирует новый).

**Endpoint:** `POST /api/v1/auth/logout`

**Требуется аутентификация:** Да

**Успешный ответ (200):**
```json
{
  "message": "Logout successful"
}
```

---

#### 4. Получить информацию о текущем пользователе

Возвращает информацию о текущем аутентифицированном пользователе.

**Endpoint:** `GET /api/v1/auth/me`

**Требуется аутентификация:** Да

**Успешный ответ (200):**
```json
{
  "id": 1,
  "email": "user@example.com",
  "role": "user",
  "created_at": "2026-01-06T14:45:43.000Z"
}
```

---

### Посты

#### 5. Получить список постов

Возвращает список всех постов с поддержкой пагинации, фильтрации и поиска.

**Endpoint:** `GET /api/v1/posts`

**Требуется аутентификация:** Нет

**Query параметры:**
- `page` (integer, optional) - Номер страницы (по умолчанию: 1)
- `per_page` (integer, optional) - Количество постов на странице (по умолчанию: 20, максимум: 100)
- `query` (string, optional) - Поисковый запрос по заголовку и содержимому
- `user_id` (integer, optional) - Фильтр по ID пользователя

**Примеры запросов:**
```
GET /api/v1/posts
GET /api/v1/posts?page=2&per_page=10
GET /api/v1/posts?query=rails
GET /api/v1/posts?user_id=1
```

**Успешный ответ (200):**
```json
{
  "posts": [
    {
      "id": 1,
      "title": "My First Post",
      "body": "This is the content of my post",
      "created_at": "2026-01-06T14:45:43.000Z",
      "updated_at": "2026-01-06T14:45:43.000Z",
      "user": {
        "id": 1,
        "email": "user@example.com"
      },
      "images": []
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 42
  }
}
```

---

#### 6. Получить один пост

Возвращает детальную информацию о посте, включая комментарии.

**Endpoint:** `GET /api/v1/posts/:id`

**Требуется аутентификация:** Нет

**Успешный ответ (200):**
```json
{
  "id": 1,
  "title": "My First Post",
  "body": "This is the content of my post",
  "created_at": "2026-01-06T14:45:43.000Z",
  "updated_at": "2026-01-06T14:45:43.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  },
  "images": [
    {
      "id": 1,
      "url": "http://localhost:3000/rails/active_storage/blobs/redirect/...",
      "filename": "image.jpg",
      "content_type": "image/jpeg"
    }
  ],
  "comments": [
    {
      "id": 1,
      "body": "Great post!",
      "created_at": "2026-01-06T15:00:00.000Z",
      "user": {
        "id": 2,
        "email": "commenter@example.com"
      }
    }
  ]
}
```

**Ошибка (404):**
```json
{
  "error": "Record not found",
  "message": "Couldn't find Post with 'id'=999"
}
```

---

#### 7. Создать пост

Создает новый пост от имени аутентифицированного пользователя.

**Endpoint:** `POST /api/v1/posts`

**Требуется аутентификация:** Да

**Body (JSON):**
```json
{
  "post": {
    "title": "My New Post",
    "body": "This is the content of my new post"
  }
}
```

**Body (Multipart/Form-data - для загрузки изображений):**
- `post[title]`: "My New Post"
- `post[body]`: "Content with image"
- `images[]`: (File)

**Успешный ответ (201):**
```json
{
  "id": 2,
  "title": "My New Post",
  "body": "This is the content of my new post",
  "created_at": "2026-01-06T16:00:00.000Z",
  "updated_at": "2026-01-06T16:00:00.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  },
  "images": [
    {
      "id": 1,
      "url": "http://localhost:3000/rails/active_storage/blobs/redirect/...",
      "filename": "image.jpg",
      "content_type": "image/jpeg"
    }
  ]
}
```

**Ошибка (422):**
```json
{
  "error": "Failed to create post",
  "messages": [
    "Title can't be blank"
  ]
}
```

**Ошибка (401):**
```json
{
  "error": "Missing authentication token"
}
```

---

#### 8. Обновить пост

Обновляет существующий пост. Только автор поста может его обновить.

**Endpoint:** `PATCH /api/v1/posts/:id` или `PUT /api/v1/posts/:id`

**Требуется аутентификация:** Да

**Body:**
```json
{
  "post": {
    "title": "Updated Title",
    "body": "Updated content"
  }
}
```

**Успешный ответ (200):**
```json
{
  "id": 1,
  "title": "Updated Title",
  "body": "Updated content",
  "created_at": "2026-01-06T14:45:43.000Z",
  "updated_at": "2026-01-06T16:30:00.000Z",
  "user": {
    "id": 1,
    "email": "user@example.com"
  },
  "images": []
}
```

**Ошибка (403):**
```json
{
  "error": "You are not authorized to perform this action"
}
```

---

#### 9. Удалить пост

Удаляет пост. Только автор поста может его удалить.

**Endpoint:** `DELETE /api/v1/posts/:id`

**Требуется аутентификация:** Да

**Успешный ответ (200):**
```json
{
  "message": "Post was successfully deleted"
}
```

**Ошибка (403):**
```json
{
  "error": "You are not authorized to perform this action"
}
```

---

## Коды ответов

- `200 OK` - Успешный запрос
- `201 Created` - Ресурс успешно создан
- `400 Bad Request` - Отсутствуют обязательные параметры
- `401 Unauthorized` - Отсутствует или неверный токен аутентификации
- `403 Forbidden` - Недостаточно прав для выполнения действия
- `404 Not Found` - Ресурс не найден
- `422 Unprocessable Entity` - Ошибка валидации данных
- `500 Internal Server Error` - Внутренняя ошибка сервера

---

## Примеры использования

### cURL

#### Регистрация и создание поста

```bash
# 1. Регистрация
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "test@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'

# Сохраните полученный api_token

# 2. Создание поста (JSON)
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -d '{
    "post": {
      "title": "My Test Post",
      "body": "This is a test post created via API"
    }
  }'

# 2.1 Создание поста с картинкой
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -F "post[title]=My Post with Image" \
  -F "post[body]=This is a post with an image" \
  -F "images[]=@/path/to/your/image.jpg"

# 3. Получение списка постов
curl http://localhost:3000/api/v1/posts

# 4. Получение конкретного поста
curl http://localhost:3000/api/v1/posts/1

# 5. Обновление поста
curl -X PATCH http://localhost:3000/api/v1/posts/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -d '{
    "post": {
      "title": "Updated Title"
    }
  }'

# 6. Удаление поста
curl -X DELETE http://localhost:3000/api/v1/posts/1 \
  -H "Authorization: Bearer YOUR_API_TOKEN"
```

### JavaScript (Fetch API)

```javascript
// Регистрация
const register = async () => {
  const response = await fetch('http://localhost:3000/api/v1/auth/register', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
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
const createPost = async (apiToken) => {
  const response = await fetch('http://localhost:3000/api/v1/posts', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${apiToken}`
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

// Получение списка постов
const getPosts = async () => {
  const response = await fetch('http://localhost:3000/api/v1/posts');
  return await response.json();
};
```

### Python (requests)

```python
import requests

BASE_URL = 'http://localhost:3000/api/v1'

# Регистрация
def register():
    response = requests.post(f'{BASE_URL}/auth/register', json={
        'user': {
            'email': 'test@example.com',
            'password': 'password123',
            'password_confirmation': 'password123'
        }
    })
    return response.json()['api_token']

# Создание поста
def create_post(api_token):
    headers = {'Authorization': f'Bearer {api_token}'}
    response = requests.post(f'{BASE_URL}/posts', 
        headers=headers,
        json={
            'post': {
                'title': 'My Post',
                'body': 'Post content'
            }
        }
    )
    return response.json()

# Получение списка постов
def get_posts():
    response = requests.get(f'{BASE_URL}/posts')
    return response.json()
```

---

## Обработка ошибок

Все ошибки возвращаются в формате JSON с соответствующим HTTP статусом.

### Пример обработки ошибок (JavaScript)

```javascript
const createPost = async (apiToken, postData) => {
  try {
    const response = await fetch('http://localhost:3000/api/v1/posts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiToken}`
      },
      body: JSON.stringify({ post: postData })
    });
    
    const data = await response.json();
    
    if (!response.ok) {
      console.error('Error:', data.error);
      console.error('Messages:', data.messages);
      throw new Error(data.error);
    }
    
    return data;
  } catch (error) {
    console.error('Request failed:', error);
    throw error;
  }
};
```

---

## Заметки

- Все даты возвращаются в формате ISO 8601 UTC
- API токен необходимо хранить в безопасном месте (не в локальном хранилище браузера для продакшена)
- При выходе из системы старый токен инвалидируется и генерируется новый
- Максимальное количество постов на странице ограничено 100
- Поиск выполняется по заголовку и содержимому поста (регистронезависимый)

---

## Безопасность

- Используйте HTTPS в продакшене
- Храните API токены безопасно
- Не передавайте токены в URL параметрах
- Регулярно обновляйте токены
- Используйте сильные пароли

---

## Лицензия

MIT License