# frozen_string_literal: true

class RemoveCodelocationStatusDefault < ActiveRecord::Migration[4.2]
  def self.up
    change_column_default :code_locations, :status, 0
  end

  def self.down
    change_column_default :code_locations, :status, 1
  end
end
