class Product < ActiveRecord::Base
  has_many :mentions, dependent: :destroy
  has_many :comments, through: :mentions

  def update_spec
    update_attributes( Specification.new(title: title, amazon_api_data: amazon_api_data).extract )
  end

  def to_param
    "#{id} #{title}".parameterize
  end
end
