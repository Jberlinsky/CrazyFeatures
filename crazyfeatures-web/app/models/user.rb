class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  has_many :authorizations, dependent: :destroy

  def github_client
    Octokit::Client.new(access_token: authorizations.last.token)
  end

  def github_user
    github_client.user
  end
end
