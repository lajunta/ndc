class Course
  include Mongoid::Document
  field :name, type: String
  field :code, type: String
  field :intro, type: String
end
