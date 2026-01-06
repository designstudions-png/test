class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user, optional: true
  has_many_attached :images
end
