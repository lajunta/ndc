class Jiaoan
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :bh, type: String
  field :content, type: String
  field :author, type: String
  field :attachs, type: Array
  field :medias, type: Array
  belongs_to :jiaoan_album
end
