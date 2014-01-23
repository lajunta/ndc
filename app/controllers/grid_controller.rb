class GridController < ApplicationController

  def download
    gid=BSON::ObjectId.from_string(params[:id])
    file=grid.get(gid)
    send_data file.read,:filename=>file.filename,:type=>file.content_type
  end

  def see
    gid=BSON::ObjectId.from_string(params[:id])
    file=grid.get(gid)
    send_data file.data,:filename=>file.filename,:type=>file.content_type,\
      :disposition => "inline"
  end
end
