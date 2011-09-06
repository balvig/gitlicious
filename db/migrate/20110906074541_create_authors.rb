class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name
      t.string :email
      t.timestamps
    end
    add_column :commits, :author_id, :integer
  end

  def self.down
    remove_column :commits, :author_id
    drop_table :authors
  end
end