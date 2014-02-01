class Semester
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::Attributes::Dynamic
  field :full_name, type: String
  field :short_name, type: String
  field :started_on, type: Date
  field :ended_on, type: Date
  validates_presence_of :full_name,:short_name, message: "不能为空"
  validates_uniqueness_of :full_name,:short_name , message: "学期已经存在"
end
