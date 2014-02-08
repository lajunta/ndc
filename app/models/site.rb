# -*- encoding : utf-8 -*-
class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :uploader, type: String
  field :path, type: String
  field :original_path, type: String
  field :type, type: String

  index({name: 1})
  index({uploader: 1})
  index({type: 1})
end
