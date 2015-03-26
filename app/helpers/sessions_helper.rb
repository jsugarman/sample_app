module SessionsHelper

  def sign_in(user)
    remember_token = User.new_token
    if params[:remember_me]
      cookies.permanent[:remember_token] = remember_token
    else
      cookies[:remember_token] = remember_token
    end
    user.update_attribute(:remember_digest, User.digest(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end
  
  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_digest = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_digest: remember_digest)
    # @current_user ||= User.find_by_remember_token(cookies[:remember_token]) # from tutorial
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    current_user.update_attribute(:remember_digest,
                                  User.digest(User.new_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

end
