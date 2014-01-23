class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
  field :intro, type: String
  field :homepage,type: String
  field :master, type: String
  field :logo, type: Hash
end
