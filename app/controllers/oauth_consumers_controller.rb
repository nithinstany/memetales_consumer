require 'oauth/controllers/consumer_controller'
class OauthConsumersController < ApplicationController
  include Oauth::Controllers::ConsumerController
  
  def index
    @consumer_tokens=ConsumerToken.all :conditions=>{:user_id=>current_user.id}
    @services=OAUTH_CREDENTIALS.keys-@consumer_tokens.collect{|c| c.class.service_name}
  end
  
  def callback
    @request_token_secret=session[params[:oauth_token]]
    if @request_token_secret
        unless current_user
          @user = User.create!
          sign_in :user, @user
        end
        @token = @consumer.create_from_request_token(
          current_user, params[:oauth_token], @request_token_secret, params[:oauth_verifier])
      if @token
        flash[:notice] = "#{params[:id].humanize} was successfully connected to your account"
        go_back
      else
        flash[:error] = "An error happened, please try connecting again"
        redirect_to oauth_consumer_url(params[:id])
      end
    end

  end
  
  protected
  
  # Change this to decide where you want to redirect user to after callback is finished.
  # params[:id] holds the service name so you could use this to redirect to various parts
  # of your application depending on what service you're connecting to.
  def go_back
    redirect_to root_url
  end
  
  def load_consumer
    consumer_key=params[:id].to_sym
    throw RecordNotFound unless OAUTH_CREDENTIALS.include?(consumer_key)
    @consumer="#{consumer_key.to_s.camelcase}Token".constantize
    @token=@consumer.find_by_user_id current_user.id if current_user
  end
  
end
