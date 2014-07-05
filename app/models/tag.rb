class Tag < ActiveRecord::Base

  def self.top_ten
    Tag.all.order(:votes).limit(10).reverse_order
  end

  def self.hashtag(tag_params)
    content = tag_params[:content]
    existing = Tag.find_by content: content

    if existing.present?
      existing.votes += 1
      existing
    else
      tag = Tag.new(tag_params)
      tag.votes = 1
      tag
    end
  end
end
