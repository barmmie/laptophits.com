class SpecificationFeed < ActiveRecord::Base
  belongs_to :product

  validates :source, uniqueness: { scope: :product }
end
