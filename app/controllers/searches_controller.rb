class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]

    @records =
      if @model == "user"
        User.search_for(@content, @method).order(created_at: :desc)
      else
        Post.search_for(@content, @method).includes(:user).order(created_at: :desc)
      end
  end
end
