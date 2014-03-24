class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :github_id
      t.text :ssh_key
      t.text :private_key
      t.text :public_key

      t.timestamps
    end
  end
end
