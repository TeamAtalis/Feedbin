class TagsController < ApplicationController
  before_action :user_owns_tag, only: [:show]

  def index
    @user = current_user
    @tags = @user.feed_tags.pluck(:name)

    @tags = @tags.find_all { |tag| tag.downcase.include?(params[:query].downcase) }.first(3)
    respond_to do |format|
      format.json { render json: {suggestions: @tags.map { |tag| {value: tag, data: tag} }}.to_json }
    end
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def show
    @user = current_user

    @tag = Tag.find(params[:id])
    @feed_ids = Tagging.where(tag_id: @tag, user_id: @user).pluck(:feed_id)

    feeds_response

    @collection_title = @tag.name

    respond_to do |format|
      format.js { render partial: "shared/entries" }
    end
  end

  # OLD FEATURE
  # def update
  #   @new_tag = nil

  #   user = current_user

  #   tag = Tag.find(params[:id])
  #   @new_tag = Tag.rename(user, tag, params[:tag][:name])

  #   if @new_tag
  #     visibility = user.tag_visibility[tag.id.to_s] || false
  #     user.update_tag_visibility(@new_tag.id.to_s, visibility)
  #   end

  #   get_feeds_list
  # end

  # NEW FEATURE
  def update
    @new_tag = nil

    user = current_user
    tag = Tag.find(params[:id])

    @updated_tag = Tag.rename_tag(user, tag, params[:tag][:name])
    
    if @updated_tag
      visibility = user.tag_visibility[tag.id.to_s] || false
      user.update_tag_visibility(@updated_tag.id.to_s, visibility)
    end

    get_feeds_list
  end

  def destroy
    @user = current_user
    tag = Tag.find(params[:id])

    Tag.destroy(@user, tag)
    # if Tag.destroy(@user, tag)
    #   flash[:notice] = "Tag deleted successfully"
    # else
    #   flash[:alert] = "Tag could not be deleted"
    # end

    get_feeds_list

    respond_to do |format|
      format.js
    end
  end

  private

  def user_owns_tag
    @user = current_user
    tags = Tagging.where(user_id: @user, tag_id: params[:id].to_i)
    if tags.count.zero?
      render_404
    end
  end
end
