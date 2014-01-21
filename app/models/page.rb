class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :body, type: String
  field :author, type: String
  field :tags, type: String
end
