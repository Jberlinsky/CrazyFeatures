class RepositoriesController < ApplicationController
  before_filter :ensure_user_authenticated!

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])
    @test_runs = @repository.test_runs.order(:created_at)
  end

  def edit
  end
end
