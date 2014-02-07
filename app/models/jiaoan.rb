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

  index({name: 1})
  index({bh: 1})
  index({author: 1})
  index({created_at: 1})
end
