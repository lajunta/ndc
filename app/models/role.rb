class Role
  include Mongoid::Document
  
  field :name, type: String
  field :members, type: Array
  index({name: 1})
  def members_list=(arg)
    self.members = arg.split(',').map { |v| v.strip }
  end

  def members_list
    self.members.join(",") if self.members
  end
end
