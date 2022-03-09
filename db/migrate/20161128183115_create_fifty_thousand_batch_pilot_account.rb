# frozen_string_literal: true

class CreateFiftyThousandBatchPilotAccount < ActiveRecord::Migration[4.2]
  def change
    create_table :fifty_thousand_batch_pilot_accounts do |t|
      t.integer :account_id, null: false
      t.timestamps
    end
  end
end
