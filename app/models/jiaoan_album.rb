# -*- encoding : utf-8 -*-
class JiaoanAlbum
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :creator, type: String
  field :cooperators, type: String
  field :logo, type: Hash
  has_many :jiaoans, dependent: :restrict, autosave: true

  index({name: 1})
  index({creator: 1})
  index({created_at: 1})
end
