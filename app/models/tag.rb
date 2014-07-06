class Tag < ActiveRecord::Base

  def self.top_ten
    Tag.all.order(:votes).limit(10).reverse_order
  end

  def self.hashtag(tag_params)
    content = tag_params[:content]
    existing = Tag.find_by content: content.downcase

    if existing.present?
      existing.votes += 1
      existing
    else
      tag = Tag.new(tag_params)
      tag.votes = 1
      tag
    end
  end

  validates :content, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: '' }
  before_create :hashify


  private 
  def hashify
    self.content = content.downcase
  end


end
