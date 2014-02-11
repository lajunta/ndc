# -*- encoding : utf-8 -*-
class CrSchedule
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name
  field :semester, type: String
  field :croom, type: String
  field :content, type: String
  field :used, type: Boolean

  index({semester: 1})
  index({croom: 1})
end
