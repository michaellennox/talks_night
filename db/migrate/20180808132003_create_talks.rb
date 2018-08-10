# frozen_string_literal: true

class CreateTalks < ActiveRecord::Migration[5.2]
  def change
    create_table :talks do |t|
      t.string :title, null: false
      t.text :description
      t.references :speaker, foreign_key: { on_delete: :restrict, to_table: :users }, index: true, null: false

      t.timestamps
    end
  end
end
