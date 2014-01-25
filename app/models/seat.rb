class Seat
  include Mongoid::Document
  field :semester, type: String
  field :tname, type: String
  field :banji, type: String
  field :croom, type: String
  field :course_name, type: String
  field :arrangement, type: String
end
