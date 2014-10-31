file = @resource_file.resource_file
json.filename file.filename
json.size file.size
json.url file.url

if file.size > 0
  #TECHDEBT handle different filetypes nicely too
  json.thumbnail_url file.url(:preview) || asset_url("_framework/chassis/icons/black/glyphicons_036_file.png")
end

if @result_file.try :lesson_id
  json.delete_url admin_lesson_path(@resource_file.lesson_id)
end

json.delete_type "DELETE"
json.extract! @resource_file, :created_at, :updated_at
