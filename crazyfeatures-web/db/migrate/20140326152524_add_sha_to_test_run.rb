class AddShaToTestRun < ActiveRecord::Migration
  def change
    add_column :test_runs, :sha, :string
  end
end
