# frozen_string_literal: true

class AddReferences < ActiveRecord::Migration[6.0]
  def change
    add_reference :questions, :user, foreign_key: { to_table: :users }
    add_reference :answers, :user, foreign_key: { to_table: :users }
  end
end
