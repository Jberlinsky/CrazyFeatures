seed_users = []
seed_repositories = []
seed_authorizations = []
seed_test_runs = []

USERS ||= [
  {
    email: 'jason@jasonberlinsky.com',
    password: 'foobarbaz',
    password_confirmation: 'foobarbaz',
    name: 'Jason Berlinsky'
  }
]

USERS.each do |user_params|
  begin
    seed_users << User.create!(user_params)
  rescue
    seed_users << User.find_by_email(user_params[:email])
  end
end

AUTHORIZATIONS ||= [
  {
    provider: 'Github',
    uid: '16839',
    user_id: seed_users.first.id,
    token: 'c8860619a533d6b6d3b652befd1351f9bd486770',
    secret: nil,
    name: 'Jason Berlinsky',
    link: 'https://github.com/Jberlinsky'
  }

]

AUTHORIZATIONS.each do |authorization_params|
  seed_authorizations << Authorization.where(authorization_params).first_or_create!
end

REPOSITORIES ||= [
  {
    name: 'Seeded Repository',
    github_id: 'github_repo',
    user_id: seed_users.first.id
  }
]

REPOSITORIES.each do |repository_params|
  seed_repositories << Repository.where(repository_params).first_or_create!
end

TEST_RUNS ||= [
  {
    repository_id: seed_repositories.first.id,
    result: "Test result data",
    sha: 'abc123',
    exit_code: 0
  },
  {
    repository_id: seed_repositories.first.id,
    result: "Test failure",
    sha: 'def98',
    exit_code: 1
  }
]

TEST_RUNS.each do |test_run_params|
  seed_test_runs << TestRun.where(test_run_params).first_or_create!
end
