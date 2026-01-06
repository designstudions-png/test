class User < ApplicationRecord
  has_secure_password
  has_secure_token :api_token

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  enum :role, { user: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Регенерация API токена
  def regenerate_api_token
    regenerate_api_token!
  end

  # Метод для поиска пользователя по API токену
  def self.find_by_api_token(token)
    find_by(api_token: token)
  end
end
