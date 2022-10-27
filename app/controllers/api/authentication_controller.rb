# frozen_string_literal: true

module Api
  class AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login
    # after_action :set_version_header

    
  

    # POST /auth/login
    def login
      @user = User.find_by_email(params[:email])
      if @user&.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        cookies.signed[:jwt] = {value: token, httponly: true, expires: 1.hour.from_now}
        render json: { token:, exp: time.strftime('%m-%d-%Y %H:%M'),
                       username: @user.username }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private

    def login_params
      params.permit(:email, :password)
    end

    # protected
    #   def set_version_header
    #       response.headers['Access-Control-Allow-Origin'] = true
    #   end
  end
end
