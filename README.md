# redmine_azure_ad

This plugin allows one to use Azure AD OpenID Connect authentication with Redmine.

## Installation

* Clone the plugin to Redmine's 'plugins/' directory,
* install the dependencies:
  ```
  bundle add omniauth
  bundle install
  bundle add omniauth-azure-activedirectory
  bundle install
  ```

## Configuration

The plugin looks for the following environment variables:

* `AAD_CLIENT_ID` - *Application ID* (Azure -> Azure Active Directory -> App registrations)
* `AAD_TENANT` - *Directory ID* (Azure -> Azure Active Directory -> Properties)

Please also ensure that *Reply URL* in *App registrations* is set to:
`https://<host>:<port>/auth/azureactivedirectory/callback`

# Usage

Click on the "Sign in with Azure AD" on the login page.

Note that this plugin ignores *Self-registration* option, i.e. an account will
be created and automatically activated even with Self-registration disabled.
