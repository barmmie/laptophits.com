namespace :db do
  desc "Clean comments without products"
  task clean_comments: :environment do
    Comment.includes(:mentions).where('mentions IS NULL').references(:mentions).destroy_all
  end
end
