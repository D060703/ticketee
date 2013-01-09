class Api::V1::BaseController < ActionController::Base
  before_filter :authenticate_user
  before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :find_project, :only => [:show, :update, :delete]
  before_filter :check_rate_limit
  
  respond_to :json, :xml
  
  private 
  
  def authenticate_user
    @current_user = User.find_by_authentication_token(params[:token])
    unless @current_user
      respond_with{{:error => "Token is invalid."}}
    end
  end
  
  def authorize_admin!
    if !@current_user.admin?
      if !@current_user.admin?
        error = { :error => "You must be an admin to do that punk."}
        warden.custom_failure!
        render params[:format].to_sym => error, :status => 401
      end
    end
  end
  
  def check_rate_limit
    @current_user.increment!(:request_count)
  end
  
  def current_user
    @current_user
  end

end
