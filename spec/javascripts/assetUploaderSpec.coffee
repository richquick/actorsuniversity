#=require 'assetUploader'
describe AssetUploader, ->
  beforeEach ->
    jasmine.Ajax.useMock()
    spec.loadFixture('file_upload')

    @assetUploader = new AssetUploader


  it "sends AJAX requests", ->
    @assetUploader.setup()

    @request = mostRecentAjaxRequest()
    expect(@request).not.toBeNull()
    expect(@request.url).toMatch(/admin\/resource_file_from\/.+/)


