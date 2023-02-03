module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers

    def index
      @users = User.all

      response = {
        users: @users.map do |user|
          {
            id: user.id,
            name: user.name,
            email: user.email,
          }
        end
      }

      render json: response.to_json
    end

    def show
      @user = User.find(params[:id])

      puts params[:id]

      scores = Score.where(user_id: @user.id).order(played_at: :desc, id: :desc)

      serialized_scores = scores.map do |score|
        {
          id: score.id,
          user_id: score.user_id,
          user_name: @user.name,
          total_score: score.total_score,
          played_at: score.played_at,
        }
      end

      response = {
        scores: serialized_scores,
      }

      render json: response.to_json
    end

    def login
      user = User.find_by('lower(email) = ?', params[:email])

      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end
  end
end
