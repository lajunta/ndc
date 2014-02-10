# -*- encoding : utf-8 -*-
unless User.where(:login=>"root").first
  user=User.new(login: 'root',realname: 'root',
                password: 'root',password_confirmation: 'root')
  user.save!
end
unless Group.where(:name=>"全体").first
  group=Group.new(name: "全体")
  group.save!
end
