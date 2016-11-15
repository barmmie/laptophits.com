Amazon::Ecs.configure do |options|
  options[:AWS_access_key_id] = ENV['AMAZON_ACCESS_KEY']
  options[:AWS_secret_key] = ENV['AMAZON_SECRET_KEY']
  options[:associate_tag] = ENV['AMAZON_ASSOC_TAG']
end

Amazon::Ecs::debug = false
