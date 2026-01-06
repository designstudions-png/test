require "open-uri"

# Clean up existing data
puts "Cleaning up database..."
Comment.destroy_all
Post.destroy_all
User.destroy_all

puts "Creating admin user..."
admin = User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  role: :admin
)

puts "Creating sample posts and comments..."

sample_posts = [
  {
    title: "Путешествие в горы",
    body: "Сегодня мы отправились в незабываемое путешествие к вершинам. Воздух здесь невероятно чистый, а виды захватывают дух. Мы прошли более 15 километров по пересеченной местности, но усталость была приятной. Горы всегда напоминают нам о том, насколько величественна природа и как важно беречь её первозданную красоту.",
    image_url: "https://picsum.photos/seed/mountain/1000/750"
  },
  {
    title: "Секреты идеального кофе",
    body: "Многие спрашивают, в чем секрет по-настоящему вкусного утреннего напитка. Все начинается с выбора зерен и правильной степени помола. Не менее важна температура воды — она не должна быть кипящей. Попробуйте добавить щепотку соли для раскрытия аромата или немного корицы для пряного послевкусия. Экспериментируйте, и вы найдете свой идеальный рецепт!",
    image_url: "https://picsum.photos/seed/coffee/1000/750"
  },
  {
    title: "Тренды веб-разработки 2024",
    body: "Мир технологий меняется стремительно. В этом году мы видим еще больший упор на производительность, использование ИИ в инструментах разработки и развитие серверных компонентов. Rails 8 продолжает радовать новыми возможностями, делая процесс создания приложений еще быстрее и приятнее. Оставайтесь на волне инноваций!",
    image_url: "https://picsum.photos/seed/code/1000/750"
  },
  {
    title: "Минимализм в интерьере",
    body: "Меньше значит больше. Это золотое правило минимализма помогает создать пространство, в котором легко дышать и мыслить. Избавьтесь от лишнего декора, отдайте предпочтение натуральным материалам и спокойным тонам. Ваш дом — это ваша крепость и место для восстановления сил, а не склад ненужных вещей.",
    image_url: "https://picsum.photos/seed/interior/1000/750"
  }
]

sample_comments = [
  "Отличный пост! Очень познавательно.",
  "Согласен с автором на все сто процентов.",
  "Интересно, не знал об этом раньше. Спасибо!",
  "Фотографии просто космос!",
  "Жду продолжения темы!",
  "А что вы думаете по поводу альтернативного мнения?",
  "Просто и понятно, класс.",
  "Спасибо за советы, обязательно попробую."
]

sample_posts.each do |post_data|
  post = Post.create!(
    title: post_data[:title],
    body: post_data[:body],
    user: admin
  )

  # Attach image via Active Storage
  begin
    image_file = URI.open(post_data[:image_url])
    post.images.attach(
      io: image_file,
      filename: "#{post.title.parameterize}.jpg",
      content_type: "image/jpeg"
    )
  rescue => e
    puts "Could not attach image for '#{post.title}': #{e.message}"
  end

  # Create random comments
  rand(3..6).times do
    post.comments.create!(
      body: sample_comments.sample,
      user: admin
    )
  end
end

puts "Success! Created #{Post.count} posts and #{Comment.count} comments."
