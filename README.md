# 📝 Rails Blog с API

Полнофункциональное веб-приложение на Ruby on Rails с RESTful API для управления постами и комментариями.

Создан при помощи Gemini 3 Flash

## ✨ Возможности

### Web-интерфейс
- ✅ Регистрация и аутентификация пользователей
- ✅ Создание, редактирование и удаление постов
- ✅ Комментарии к постам
- ✅ Загрузка изображений к постам
- ✅ Поиск по постам и комментариям
- ✅ Система ролей (user/admin)

### API
- ✅ RESTful API (JSON)
- ✅ Token-based аутентификация
- ✅ CRUD операции для постов
- ✅ Пагинация и фильтрация
- ✅ Поиск по постам
- ✅ Поддержка изображений
- ✅ Обработка ошибок

## 🚀 Быстрый старт

### Требования

- Ruby 3.3.0+
- Rails 8.1.1+
- SQLite3
- Bundler

### Установка

1. Клонируйте репозиторий и перейдите в директорию проекта

2. Установите зависимости:
```bash
bundle install
```

3. Создайте и настройте базу данных:
```bash
rails db:create
rails db:migrate
rails db:seed  # Опционально: загрузить тестовые данные
```

4. Запустите сервер:
```bash
rails server
```

5. Откройте браузер: http://localhost:3000

## 🔌 API Endpoints

### Аутентификация

```
POST   /api/v1/auth/register    # Регистрация
POST   /api/v1/auth/login        # Вход
POST   /api/v1/auth/logout       # Выход
GET    /api/v1/auth/me           # Текущий пользователь
```

### Посты

```
GET    /api/v1/posts             # Список постов
GET    /api/v1/posts/:id         # Получить пост
POST   /api/v1/posts             # Создать пост (требуется аутентификация)
PATCH  /api/v1/posts/:id         # Обновить пост (требуется аутентификация)
DELETE /api/v1/posts/:id         # Удалить пост (требуется аутентификация)
```

## 📖 Документация

- **[API_DOCUMENTATION.md](API_DOCUMENTATION.md)** - Полная документация API с примерами
- **[API_SETUP.md](API_SETUP.md)** - Инструкции по настройке и запуску

## 🔐 Использование API

### Пример: Регистрация и создание поста

```bash
# 1. Регистрация
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "user@example.com",
      "password": "password123",
      "password_confirmation": "password123"
    }
  }'

# 2. Создание поста (используйте полученный api_token)
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -d '{
    "post": {
      "title": "My First Post",
      "body": "This is my first post via API"
    }
  }'

# 3. Получение списка постов
curl http://localhost:3000/api/v1/posts
```

### Пример: JavaScript

```javascript
// Регистрация
const response = await fetch('http://localhost:3000/api/v1/auth/register', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    user: {
      email: 'user@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }
  })
});

const { api_token } = await response.json();

// Создание поста
await fetch('http://localhost:3000/api/v1/posts', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${api_token}`
  },
  body: JSON.stringify({
    post: {
      title: 'My Post',
      body: 'Post content'
    }
  })
});
```

## 🛠️ Технологии

- **Backend:** Ruby on Rails 8.1.1
- **Database:** SQLite3
- **Authentication:** bcrypt, has_secure_password
- **API:** ActionController::API
- **File Storage:** Active Storage
- **Frontend:** Turbo, Stimulus
- **Styling:** CSS

## 📁 Структура проекта

```
rap1/
├── app/
│   ├── controllers/
│   │   ├── api/v1/              # API контроллеры
│   │   │   ├── base_controller.rb
│   │   │   ├── auth_controller.rb
│   │   │   └── posts_controller.rb
│   │   ├── posts_controller.rb  # Web контроллер
│   │   └── ...
│   ├── models/
│   │   ├── user.rb
│   │   ├── post.rb
│   │   └── comment.rb
│   └── views/
├── config/
│   ├── routes.rb                # Маршруты
│   └── database.yml
├── db/
│   ├── migrate/                 # Миграции
│   └── schema.rb
├── API_DOCUMENTATION.md         # Документация API
├── API_SETUP.md                 # Инструкции по настройке
└── README.md                    # Этот файл
```

## 🔧 Полезные команды

```bash
# Rails консоль
rails console

# Просмотр маршрутов
rails routes

# Просмотр API маршрутов
rails routes | grep api

# Запуск тестов
rails test

# Проверка стиля кода
rubocop

# Сброс базы данных
rails db:reset
```

## 🧪 Тестирование API

### С помощью curl

```bash
# Регистрация
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"test@test.com","password":"123456","password_confirmation":"123456"}}'

# Получение постов
curl http://localhost:3000/api/v1/posts

# Получение постов с пагинацией
curl "http://localhost:3000/api/v1/posts?page=1&per_page=10"

# Поиск постов
curl "http://localhost:3000/api/v1/posts?query=ruby"
```

### С помощью Postman/Insomnia

1. Импортируйте коллекцию с эндпоинтами из `API_DOCUMENTATION.md`
2. Зарегистрируйтесь через `/api/v1/auth/register`
3. Скопируйте полученный `api_token`
4. Добавьте заголовок `Authorization: Bearer <api_token>` для защищенных эндпоинтов

## 🚨 Решение проблем

### Проблемы с миграциями

```bash
rails db:migrate:status          # Проверить статус миграций
rails db:rollback                # Откатить последнюю миграцию
rails db:migrate                 # Применить миграции
```

### Проблемы с зависимостями

```bash
bundle install                   # Установить зависимости
bundle update                    # Обновить зависимости
```

### Сброс базы данных

```bash
rails db:drop db:create db:migrate db:seed
```

## 📝 API Особенности

- **Аутентификация:** Token-based через заголовок `Authorization: Bearer <token>`
- **Формат данных:** JSON
- **Пагинация:** Параметры `page` и `per_page`
- **Поиск:** Параметр `query`
- **Фильтрация:** Параметр `user_id`
- **Коды ответов:** Стандартные HTTP коды (200, 201, 401, 403, 404, 422)

## 🔒 Безопасность

- Пароли хешируются с помощью bcrypt
- API токены уникальны для каждого пользователя
- CSRF защита для web-форм
- Валидация входящих данных
- Авторизация на уровне контроллеров

## 📄 Лицензия

MIT License

## 🤝 Вклад

Contributions, issues и feature requests приветствуются!

## 📧 Контакты

Если у вас есть вопросы или предложения, создайте issue в репозитории.

---

**Создано с ❤️ используя Ruby on Rails**