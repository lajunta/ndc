class GridController < ApplicationController

  def download(gid=params[:id])
    #gid=BSON::ObjectId.from_string(params[:id])
    file=grid.get(gid)
    send_data file.data,:filename=>file.filename,:type=>file.content_type

  end

  def see(gid=params[:id])
    #gid=BSON::ObjectId.from_string(params[:id])
    file=grid.get(gid)
    send_data file.data,:filename=>"aa",:type=>file.content_type,\
      :disposition => "inline"
  end
end
