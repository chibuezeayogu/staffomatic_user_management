class UsersController < ApplicationController
  include JSONAPI::Errors
  include JSONAPI::Deserialization

  before_action :set_user, only: %i[show update]
  before_action :check_user, only: :update
  before_action :set_paper_trail_whodunnit, only: :update

  def index
    if filter_params.present?
      render jsonapi: User.apply_filters(filter_params)
    else
      render jsonapi: User.all
    end
  end

  def show
    render jsonapi: @found_user, status: :ok
  end

  def update
    if @found_user.update(users_params)
      render jsonapi: @found_user, status: :ok
    else
      render jsonapi_errors: @found_user.errors, status: :unprocessable_entity
    end
  end

  private

  def users_params
    params.require(:user).permit(:archived, :deleted)
  end

  def filter_params
    params.permit(:archived, :deleted)
  end

  def set_user
    @found_user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message }, status: :not_found
  end

  def check_user
    if @found_user.id == current_user.id
      render json: {
        message: 'You cannot archive/unarchive/delete your account'
      }, status: :forbidden
    end
  end
end
