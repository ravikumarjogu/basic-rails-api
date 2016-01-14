module Api
  module V1
    class Api::V1::UsersController < ApplicationController
       include ActionController::HttpAuthentication::Basic::ControllerMethods
       include ActionController::HttpAuthentication::Token::ControllerMethods

       include ActionController::MimeResponds
      # http_basic_authenticate_with name:"jrk", password: "password"
      # before_filter :authenticate_user
      # before_filter :restrict_access
      # before_filter :auth_api_key_secret
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

        def auth_api_key_secret
          access_token=request.env['HTTP_API_KEY']
          access_secret=request.headers['HTTP_API_SECRET']
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: access_token, access_secret: access_secret)
          end
        end

      end
  end
end