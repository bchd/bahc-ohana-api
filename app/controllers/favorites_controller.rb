class FavoritesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json

  def index
    @current_user = current_user if current_user.present?
    @favorites = @current_user.favorites
  end

  def create
    @favorite = Favorite.create(favorite_params)
    if @favorite.save
      render json: @favorite
    else
      render({ errors: @favorite.errors })
    end
  end

  def destroy
    user_favorites = User.find(favorite_params[:user_id]).favorites
    type_favorites = user_favorites.where(resource_type: favorite_params[:resource_type])
    @favorite = type_favorites.find_by(resource_id: favorite_params[:resource_id])
    if @favorite.delete
      render json: @favorite
    else
      render({ errors: @favorite.errors })
    end
  end

  private
  def favorite_params
    params.require(:favorite).permit(:resource_type, :resource_id, :name, :url, :user_id)
  end
end
