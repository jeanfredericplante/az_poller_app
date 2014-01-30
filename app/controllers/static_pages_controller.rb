class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @user = current_user
      @micropost = current_user.microposts.build
      @feed_items = @user.feed.paginate(page: params[:page], per_page: 10)
    end
  end

  def help
  end
end
