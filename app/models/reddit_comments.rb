class RedditComments
  def self.latest
    q = '%22amazon.com%22'

    after = 12.hours.ago.to_i
    after = Comment.order('created_utc DESC').first.created_utc.to_i if Comment.first

    limit = 500

    url = "https://api.pushshift.io/reddit/search/comment?q=#{q}&after=#{after}&limit=#{limit}"
    uri = URI(url)
    response = Net::HTTP.get(uri)

    data = JSON.parse(response)['data']
  end

  def self.attributes
    ["author",
    "author_flair_css_class",
    "author_flair_text",
    "body",
    "body_html",
    "created_utc",
    "comment_id",
    "link_author",
    "link_created_utc",
    "link_domain",
    "link_id",
    "link_num_comments",
    "link_over_18",
    "link_permalink",
    "link_title",
    "parent_id",
    "stickied",
    "subreddit",
    "subreddit_id",
    "url"]
  end
end
