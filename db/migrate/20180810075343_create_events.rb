# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :group, foreign_key: { on_delete: :restrict }, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :description
      t.string :title, null: false

      t.timestamps
    end
  end
end
