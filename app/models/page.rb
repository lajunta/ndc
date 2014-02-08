# -*- encoding : utf-8 -*-
class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :body, type: String
  field :author, type: String
  field :name, type: String
  field :tags, type: String

  index({title: 1})
  index({author: 1})
  index({tags: 1})
  index({name: 1})
end
