class TagsController < ApplicationController
  def index
    @tags = Tag.top_ten
    @tag = Tag.new
  end

  def create
    @tags = Tag.top_ten
    @tag = Tag.hashtag(tag_params)

    if @tag.save
      flash.delete(:error)
      redirect_to tags_path
    else
      flash[:error] = "Illegal hash!!"
      render 'index'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:content)
  end

end