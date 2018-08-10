# frozen_string_literal: true

class CreateTalkSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :talk_suggestions do |t|
      t.references :talk, foreign_key: { on_delete: :restrict }, index: true, null: false
      t.references :group, foreign_key: { on_delete: :restrict }, index: true, null: false
      t.text :speaker_contact, null: false

      t.timestamps
    end
  end
end
