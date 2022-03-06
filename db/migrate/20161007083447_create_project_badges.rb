# frozen_string_literal: true

class CreateProjectBadges < ActiveRecord::Migration[4.2]
  def change
    create_table :project_badges do |t|
      t.references :repository, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.string :url
      t.string :type
      t.boolean :deleted, default: false
      t.timestamps null: false
    end
  end
end
