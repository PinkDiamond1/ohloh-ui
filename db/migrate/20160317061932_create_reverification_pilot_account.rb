# frozen_string_literal: true

class CreateReverificationPilotAccount < ActiveRecord::Migration[4.2]
  def change
    create_table :reverification_pilot_accounts do |t|
      t.integer :account_id, null: false
      t.timestamps null: false
    end
  end
end
