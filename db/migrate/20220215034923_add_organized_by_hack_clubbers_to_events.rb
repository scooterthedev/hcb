# frozen_string_literal: true

class AddOrganizedByHackClubbersToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :organized_by_hack_clubbers, :boolean
  end

end
