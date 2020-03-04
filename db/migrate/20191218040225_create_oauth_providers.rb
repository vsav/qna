# frozen_string_literal: true

class CreateOauthProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_providers do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :oauth_providers, %i[provider uid], unique: true
  end
end
