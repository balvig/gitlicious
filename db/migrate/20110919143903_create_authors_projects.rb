class CreateAuthorsProjects < ActiveRecord::Migration
  def self.up
    create_table :authors_projects, :force => true, :id => false do |t|
      t.integer :author_id, :project_id
    end
  end

  def self.down
    drop_table :authors_projects
  end
end