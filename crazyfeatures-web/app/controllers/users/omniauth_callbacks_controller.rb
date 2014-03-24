class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  require 'uuidtools'

  def github
    @user = find_for_oauth("Github", env['omniauth.auth'], current_user)
    if @user
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: :github
      session['devise.github_data'] = env['omniauth.auth']
      sign_in_and_redirect @user, event: :authentication
    end
  end

  private

  def find_for_oauth(provider, access_token, resource=nil)
    user, email, name, uid, auth_attr = nil, nil, nil, {}
    case provider
    when "Github"
      uid = access_token['uid']
      token = access_token['credentials']['token']
      name = access_token['extra']['raw_info']['name']
      email = access_token['extra']['raw_info']['email']
      link = access_token['extra']['raw_info']['html_url']
      auth_attr = {
        :uid => uid,
        :token => token,
        :secret => nil,
        :name => name,
        :link => link
      }
    else
      raise 'Provider #{provider} not handled'
    end
    if resource.nil?
      if email
        user = find_for_oauth_by_email(email, resource)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource)
        if user.nil?
          user = find_for_oauth_by_name(name, resource)
        end
      end
    else
      user = resource
    end

    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(:provider => provider)
      user.authorizations << auth
    end
    auth.update_attributes auth_attr

    # Save all reposiroties
    user.github_user.rels[:repos].get.data.each do |repo|
      # TODO remove temporary filter...
      next unless repo.name.split("/").last == "Hook-Test"

      Repository.create(
        name: repo.name,
        github_id: repo.id,
        user: user
      )
    end

    return user
  end

  def find_for_oauth_by_email(email, resource=nil)
    if user = User.find_by_email(email)
      user
    else
      user = User.new(:email => email, :password => Devise.friendly_token[0,20])
      user.save
    end
    return user
  end

  def find_for_oauth_by_name(name, resource=nil)
    if user = User.find_by_name(name)
      user
    else
      user = User.new(:name => name, :password => Devise.friendly_token[0,20], :email => "#{UUIDTools::UUID.random_create}@host")
      user.save false
    end
    return user
  end
end
