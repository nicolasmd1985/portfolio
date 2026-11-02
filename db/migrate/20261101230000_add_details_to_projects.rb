class AddDetailsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :url, :string
    add_column :projects, :tags, :string
    add_column :projects, :status, :string, default: "Live"
    add_column :projects, :featured, :boolean, default: true
    add_column :projects, :position, :integer, default: 0
    add_column :projects, :github_url, :string
    add_column :projects, :category, :string
    add_column :projects, :port, :integer
  end
end
