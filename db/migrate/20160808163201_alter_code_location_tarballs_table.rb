# frozen_string_literal: true

class AlterCodeLocationTarballsTable < ActiveRecord::Migration[4.2]
  def change
    add_column :code_location_tarballs, :type, :text
    rename_column :code_location_tarballs, :commit_sha1, :reference
  end
end
