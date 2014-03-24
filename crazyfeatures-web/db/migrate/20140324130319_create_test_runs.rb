class CreateTestRuns < ActiveRecord::Migration
  def change
    create_table :test_runs do |t|
      t.integer :repository_id
      t.string :result
      t.integer :exit_code

      t.timestamps
    end
  end
end
