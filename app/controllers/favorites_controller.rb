class FavoritesController < ApplicationController 
  before_action :set_post 
  
  def create 
    Current.user.favorites.find_or_create_by(post: @post)
    
    redirect_back(
      fallback_location: post_path(@post), 
      status: :see_other 
    ) 
    end 
  
  def destroy 
    favorite = Current.user.favorites.find_by(post: @post) 
    favorite&.destroy 
    
    redirect_back( 
      fallback_location: post_path(@post), 
      status: :see_other 
    ) 
  end 
  
  private 
  
  def set_post 
    @post = Post.find(params[:post_id]) 
  end
end