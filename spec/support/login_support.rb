module LoginSupport
  # feature spec
  def log_in_as(user)
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
  end

  # request spec
  def is_log_in(user, password: 'password', remember_me: '0')
    post login_path, params: { session: { email:       user.email,
                                          password:    password,
                                          remember_me: remember_me } }
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

end

RSpec.configure do |config|
  config.include LoginSupport
end
