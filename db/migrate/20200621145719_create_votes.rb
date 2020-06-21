# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true
      t.references :user
      t.integer :vote, default: 0
      t.timestamps
    end
  end
end
