require 'omniauth'

Redmine::Plugin.register :redmine_azure_ad do
  name 'Redmine Azure AD plugin'
  author 'Michal Liszcz'
  description 'Redmine authentication with Azure AD'
  version '0.0.1'
  url 'https://github.com/s2innovation/redmine_azure_ad'
  author_url 'http://example.com/about'
  menu :account_menu,
    :azure_ad,
    '/auth/azureactivedirectory',
    {
      :caption => 'Sign in with Azure AD',
      :if => Proc.new { || User.current.anonymous?  }
    }
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :azure_activedirectory, ENV['AAD_CLIENT_ID'], ENV['AAD_TENANT']
end
