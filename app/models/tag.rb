class Tag < ActiveRecord::Base

  has_many :parent_mappings, class_name: "Mapping", foreign_key: :child_id
  has_many :child_mappings, class_name: "Mapping", foreign_key: :parent_id

  attr_accessor :parent_content

  after_initialize :set_votes
  after_save :persist_parent

  validates :content, uniqueness: true, format: { with: %r{\A[A-z0-9]+\z}, message: "must be alphanumeric" }

  def self.top_ten
    Tag.all.order(votes: :desc).limit(10)
  end

  def self.hashtag(content)
    Tag.where(content: content).first_or_initialize.tap do |tag|
      tag.votes += 1
    end
  end

  def top_ten
    child_mappings.includes(:child).order(votes: :desc).limit(10).map(&:child)
  end

  def parent_content=(content)
    @parent_content = content
  end

  private

  def set_votes
    self.votes ||= 0
  end

  def persist_parent
    unless parent_content.blank?
      parent = Tag.where(content: parent_content).first_or_create!
      mapping = parent_mappings.where(parent_id: parent.id).first_or_create do |mapping|
        mapping.votes ||= 0
        mapping.votes += 1
      end
    end
  end

  validates :content, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: '' }
  before_create :hashify


  private 
  def hashify
    self.content = content.downcase
  end


end
