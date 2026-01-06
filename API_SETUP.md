# Инструкция по запуску API

## 📋 Требования

Перед началом работы убедитесь, что у вас установлены:

- Ruby 3.3.0 или выше
- Rails 8.1.1 или выше
- SQLite3
- Bundler

## 🚀 Быстрый старт

### 1. Установка зависимостей

```bash
bundle install
```

Если возникают проблемы с bundler, установите его:

```bash
gem install bundler
bundle install
```

### 2. Настройка базы данных

Создайте базу данных:

```bash
rails db:create
```

### 3. Запуск миграций

Примените все миграции к базе данных:

```bash
rails db:migrate
```

Эта команда:
- Создаст таблицы для постов, комментариев и пользователей
- Настроит Active Storage для загрузки изображений
- Добавит поле `api_token` к таблице пользователей

### 4. (Опционально) Загрузка тестовых данных

Если вы хотите создать тестовые данные:

```bash
rails db:seed
```

### 5. Запуск сервера

Запустите Rails сервер:

```bash
rails server
```

или сокращенно:

```bash
rails s
```

Сервер запустится на `http://localhost:3000`

## ✅ Проверка работы API

### Тест 1: Проверка здоровья сервера

```bash
curl http://localhost:3000/up
```

Должен вернуть статус 200.

### Тест 2: Регистрация пользователя

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

Успешный ответ вернет JSON с `api_token`.

### Тест 3: Создание поста

```bash
# Замените YOUR_API_TOKEN на токен из предыдущего шага
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -d '{
    "post": {
      "title": "Test Post",
      "body": "This is my first test post"
    }
  }'
```

### Тест 4: Получение списка постов

```bash
curl http://localhost:3000/api/v1/posts
```

## 🔧 Полезные команды

### Rails консоль

Откройте Rails консоль для интерактивной работы:

```bash
rails console
```

или сокращенно:

```bash
rails c
```

Примеры команд в консоли:

```ruby
# Создать пользователя
user = User.create(email: "admin@example.com", password: "password123", password_confirmation: "password123", role: :admin)

# Показать API токен пользователя
user.api_token

# Создать пост
post = user.posts.create(title: "Test", body: "Content")

# Посмотреть все посты
Post.all

# Посмотреть всех пользователей
User.all
```

### Сброс базы данных

Если нужно сбросить базу данных:

```bash
rails db:drop db:create db:migrate
```

### Откат миграции

Откатить последнюю миграцию:

```bash
rails db:rollback
```

Откатить несколько миграций:

```bash
rails db:rollback STEP=3
```

### Просмотр маршрутов

Посмотреть все доступные маршруты:

```bash
rails routes
```

Фильтровать по API маршрутам:

```bash
rails routes | grep api
```

## 🛠️ Решение проблем

### Проблема: "Could not find gem"

**Решение:**
```bash
bundle install
```

### Проблема: "Database does not exist"

**Решение:**
```bash
rails db:create
rails db:migrate
```

### Проблема: "PG::ConnectionBad" или проблемы с PostgreSQL

Проект использует SQLite3 по умолчанию. Проверьте `config/database.yml`.

### Проблема: Порт 3000 уже занят

**Решение:** Запустите сервер на другом порту:
```bash
rails server -p 3001
```

### Проблема: "Migrations are pending"

**Решение:**
```bash
rails db:migrate
```

### Проблема: CSRF токен

Если получаете ошибки CSRF при использовании API - это нормально. API контроллеры наследуются от `ActionController::API`, который не требует CSRF токены.

## 📝 Структура API

```
/api/v1
├── /auth
│   ├── POST   /register    # Регистрация
│   ├── POST   /login        # Вход
│   ├── POST   /logout       # Выход
│   └── GET    /me           # Текущий пользователь
└── /posts
    ├── GET    /             # Список постов
    ├── GET    /:id          # Один пост
    ├── POST   /             # Создать пост
    ├── PATCH  /:id          # Обновить пост
    └── DELETE /:id          # Удалить пост
```

## 🔐 Безопасность

### Production настройки

Перед деплоем в production:

1. Измените `secret_key_base` в `config/credentials.yml.enc`
2. Настройте HTTPS
3. Настройте CORS если API будет использоваться из браузера
4. Добавьте rate limiting
5. Используйте environment variables для чувствительных данных

### Настройка CORS (если нужно)

Добавьте в Gemfile:

```ruby
gem 'rack-cors'
```

Затем в `config/application.rb`:

```ruby
config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # В production укажите конкретные домены
    resource '/api/*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
```

## 📚 Дополнительная информация

- Полная документация API: `API_DOCUMENTATION.md`
- Официальная документация Rails: https://guides.rubyonrails.org/
- API тестирование: Используйте Postman, Insomnia или аналогичные инструменты

## 🐛 Отладка

### Включить подробные логи

В `config/environments/development.rb` убедитесь что:

```ruby
config.log_level = :debug
```

### Просмотр логов в реальном времени

```bash
tail -f log/development.log
```

## 📞 Поддержка

Если возникли проблемы:
1. Проверьте логи в `log/development.log`
2. Используйте `rails console` для отладки
3. Проверьте документацию в `API_DOCUMENTATION.md`

---

**Готово!** Теперь ваше API готово к работе. 🎉