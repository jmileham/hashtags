class TagsController < ApplicationController

  def index
    @tags = Tag.top_ten
    @tag = Tag.new
  end

  def create
    parent = Tag
    parent = parent.where(content: tag_params[:parent_content]) unless tag_params[:parent_content].blank?
    @tags = parent.top_ten
    @tag = Tag.new(tag_params)
    if @tag.save
      url_parts = [@tag.parent_content, @tag.content].reject(&:blank?)
      redirect_to "/" + url_parts.join("/")
    else
      render 'index'
    end
  end

  def show
    parent = Tag.hashtag(params[:parent_content])
    if parent.save
      @tags = parent.top_ten
      @tag = Tag.new
      @tag.parent_content = parent.content
      render 'index'
    else
      render status: :not_found
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:content, :parent_content)
  end
end
