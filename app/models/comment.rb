class Comment < ActiveRecord::Base
  has_many :mentions
  has_many :products, through: :mentions
end
