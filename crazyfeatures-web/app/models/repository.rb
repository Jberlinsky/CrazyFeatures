class Repository < ActiveRecord::Base
  belongs_to :user
  has_many :test_runs

  before_create :assign_ssh_key, :create_deploy_key!, :create_deploy_hook!

  def assign_ssh_key
    key = SSHKey.generate(type: 'RSA', bits: 2048)
    self.ssh_key = key.ssh_public_key
    self.private_key = key.private_key
    self.public_key = key.public_key
  end

  def create_deploy_key!
    github_user.add_deploy_key(self.name, 'Crazy Features CI', self.ssh_key)
  rescue
    # This particular key is taken
    self.assign_ssh_key
    self.create_deploy_key!
  end

  def create_deploy_hook!
    github_user.create_hook(self.name, 'web', {
      url: ENV['APPLICATION_URL'] + '/github/payload',
      insecure_ssl: '1'
    }, {
      events: [:push],
      active: true
    })
  rescue
    # The hook already exists
    true
  end

  def to_s
    name
  end

  private

  def github_user
    user.github_client.user
  end
end
