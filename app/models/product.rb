class Product < ActiveRecord::Base
  has_many :mentions
  has_many :comments, through: :mentions
end
