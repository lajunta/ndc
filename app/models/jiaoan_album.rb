class JiaoanAlbum
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :creator, type: String
  field :cooperators, type: String
  field :logo, type: Hash
  has_many :jiaoans, dependent: :restrict, autosave: true

end
