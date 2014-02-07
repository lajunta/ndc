class Course
  include Mongoid::Document
  field :name, type: String
  field :code, type: String
  field :intro, type: String
  field :logo, type: Hash

  index({name: 1})
end
