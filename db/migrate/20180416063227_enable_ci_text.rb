# frozen_string_literal: true

class EnableCiText < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
  end
end
