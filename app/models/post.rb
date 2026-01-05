class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many_attached :images
end
