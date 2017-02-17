namespace :comments do
  desc "Import product mentions from Reddit comments"
  task import: :environment do

    data = RedditComments.latest
    
    puts "Processing #{data.length} comments"

    data.each { |comment| Comment.create_from_reddit(comment) }
  end
end
