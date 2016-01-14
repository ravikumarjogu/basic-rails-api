module Api
  module V1
    class Api::V1::UsersController < ApplicationController
     include ActionController::HttpAuthentication::Basic::ControllerMethods
     include ActionController::HttpAuthentication::Token::ControllerMethods

     include ActionController::MimeResponds
     # http_basic_authenticate_with name:"jrk", password: "password"
      # before_filter :authenticate_user
     # before_action :authenticate_user, only_for: [:index]
      # before_filter :restrict_access

      def index
        @users = User.all 
        respond_to do |format|
          format.json { render json: @users, :only => [:id,:email,:name]}
        end
      end

      private
        def user_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end

        def authenticate_user
            authenticate_or_request_with_http_basic('User') do |email, password|
              User.find_by_email(email).authenticate(password) unless User.find_by_email(email).nil?
            end
        end

        def restrict_access
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: token)
          end

        end

    end
  end
end