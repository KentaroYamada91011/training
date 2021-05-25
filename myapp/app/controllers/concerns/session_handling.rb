module SessionHandling
  def login(user)
    reset_session
    session[:user_id] = user.id
  end
end
