class CrSchedule
  include Mongoid::Document
  include Mongoid::Timestamps
  field :semester, type: String
  field :croom, type: String
  field :content, type: String
  field :used, type: Boolean
end
