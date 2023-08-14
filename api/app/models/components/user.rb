require "haikunator"
module Components
  class User < ApplicationRecord
    # TODO: use prefix for table name instead
    self.table_name = "components_users"
    include ActiveModel::Validations

    validates_presence_of :friendly_name, :id

    def self.a_friendly_name
      Haikunator.haikunate
    end
  end
end
