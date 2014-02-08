# -*- encoding : utf-8 -*-
class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  field :submitter, type: String
  field :attachs, type: Array
  field :hub_id, type: BSON::ObjectId
  field :desc, type: String
  belongs_to :hub
end
