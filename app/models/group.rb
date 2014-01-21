class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
end
