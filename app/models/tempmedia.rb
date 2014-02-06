class Tempmedia
  include Mongoid::Document
  include Mongoid::Timestamps

  field :login, type: String
  field :medias,type: Array

	def self.saveattach(filename,tmpfile,content_type)
		tt=tmpfile.open
		fileinfo={}
		file_id=Grid.put(tt,:filename=>filename,:content_type=>content_type) 
		thefile=Grid.get(file_id)
		fileinfo["grid_id"]=file_id
		fileinfo["content_type"]=thefile.content_type
		filesize=thefile.file_length/1024
		fileinfo["file_size"]=("%.1f"%filesize)+"kb"
		fileinfo["filename"]=thefile.filename
		return fileinfo
	end	
end
