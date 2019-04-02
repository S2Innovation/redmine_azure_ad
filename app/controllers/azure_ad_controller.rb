class AzureAdController < AccountController

  protect_from_forgery except: :callback

  def callback

    auth = request.env['omniauth.auth']
    identity_url = OpenIdAuthentication.normalize_identifier(auth[:uid])

    if false
      # Enable this path if you enabled account creation/activation.
      @auth = auth
      open_id_authenticate(identity_url)
    else
      onthefly_automatic_user_creation(identity_url, auth)
    end

  end

  # Overwrites AccountController method to perform user account creation
  # and bypasses OpenIdAuthentication.authenticate_with_open_id
  def authenticate_with_open_id(identifier, options, &block)
    registration = Hash.new
    registration['nickname'] = @auth[:info][:email]
    registration['email'] = @auth[:info][:email]
    registration['fullname'] = "#{@auth[:info][:first_name]} #{@auth[:info][:last_name]}"

    yield  Result[:successful], identifier, registration
  end

  def onthefly_automatic_user_creation(identity_url, auth)
    user = User.find_or_initialize_by_identity_url(identity_url)
    if user.new_record?
      handle_new_user(user, auth)
    else
      handle_existing_user(user)
    end
  end

  def handle_new_user(user, auth)
    user.login = auth[:info][:email]
    user.mail = auth[:info][:email]
    user.firstname = auth[:info][:first_name]
    user.lastname = auth[:info][:last_name]
    user.random_password
    user.register

    register_automatically(user) do
      onthefly_creation_failed(user)
    end
  end

  def handle_existing_user(user)
    if user.active?
      successful_authentication(user)
    else
      handle_inactive_user(user)
    end
  end

end
