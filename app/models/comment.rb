class Comment < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :products, through: :mentions
end
