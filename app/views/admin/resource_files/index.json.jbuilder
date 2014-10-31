json.array!(@resource_files) do |resource_file|
  json.name @resource_file.resource_file
  json.size @resource_file.resource_file.size
  json.url  @resource_file.resource_file.url
  json.delete_url admin_lesson_path(@resource_file.lesson_id)
  json.delete_type "DELETE"
  json.extract! @resource_file, :created_at, :updated_at
end
