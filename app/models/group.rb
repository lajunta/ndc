class Group
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :type, type: String
  field :intro, type: String
  field :homepage,type: String
  field :admin, type: String
  field :logo, type: Hash

  index({name: 1})
  index({type: 1})
  index({admin: 1})
  index({created_at: 1})
end
