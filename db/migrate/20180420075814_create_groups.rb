# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.references :owner, foreign_key: { on_delete: :restrict, to_table: :users }, index: true, null: false
      t.string :name, index: { unique: true }, null: false
      t.text :description, null: false
      t.string :url_slug, index: { unique: true }, null: false

      t.timestamps
    end
  end
end
