# -*- encoding : utf-8 -*-
class Seat
  include Mongoid::Document
  include Mongoid::Timestamps
  field :semester, type: String
  field :tname, type: String
  field :banji, type: String
  field :croom, type: String
  field :course_name, type: String
  field :arrangement, type: String

  index({semester: 1})
  index({tname: 1})
  index({banji: 1})
  index({croom: 1})
  index({course_name: 1})
  index({created_at: 1})
end
