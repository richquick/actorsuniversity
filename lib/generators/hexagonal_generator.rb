class HexagonalGenerator < Rails::Generators::NamedBase
  desc "Create hexagonal module for Rails ports and adapters pattern"
  def create_hexagonal_file
    create_file "lib/hexagon.rb", <<-FILE
module Hexagonal
  attr_reader :framework, :dao

  def initialize framework, dao
    @framework, @dao = framework, dao
  end
end
    FILE
  end
 
  desc "Create dao"
  def create_dao_file
    create_file "app/models/dao/#{plural_name.singularize}.rb", <<-FILE
module Dao
  class #{class_name}
    def create attributes
      ::#{class_name}.create attributes
    end

    def new
      ::#{class_name}.new
    end

    def all
      ::#{class_name}.all
    end

    def find id
      ::#{class_name}.find id
    end

    def update id, attributes
      find(id).tap do |g|
        g.update_attributes attributes
      end
    end

    def destroy id
      ::#{class_name}.destroy(id)
    end
  end
end
    FILE
  end
 
  def create_service_spec
    create_file "spec/services/#{file_name}_administration_spec.rb", <<-FILE
#Uncomment and use a separate faster spec helper  
#require 'fast_spec_helper' # i.e. don't load framework
#require './app/services/#{plural_name.singularize}_administration'
#or use zeus https://github.com/burke/zeus and have the framework pre-loaded:
require 'spec_helper' 

describe #{class_name}Administration do
  let(:#{plural_name.singularize})    { double '#{plural_name.singularize}', valid?: validity }
  let(:validity) { true }

  let(:dao) do 
    double 'dao_#{plural_name.singularize}', 
      create_#{plural_name.singularize}:  #{plural_name.singularize},
      update_#{plural_name.singularize}:  #{plural_name.singularize},
      find_#{plural_name.singularize}:    #{plural_name.singularize},
      new_#{plural_name.singularize}:     #{plural_name.singularize},
      destroy_#{plural_name.singularize}: #{plural_name.singularize},
      all_#{plural_name}:                 #{plural_name.singularize}
  end

  let(:framework) do
    double 'framework', 
      create_success: nil,
      create_failure: nil,
      update_success: nil,
      update_failure: nil
  end

  let(:#{plural_name.singularize}_administration) { #{class_name}Administration.new framework, dao }

  let(:#{plural_name.singularize}_attributes) do
    {}
  end

  describe "#all" do
    it "looks up the resource" do
      #{plural_name.singularize}_administration.all

      expect(dao).to have_received(:all_#{plural_name})
    end
  end

  describe "#edit" do
    it "looks up the resource" do
      #{plural_name.singularize}_administration.edit 1

      expect(dao).to have_received(:find_#{plural_name.singularize}).
                    with(1)
    end
  end

  describe "#new_#{plural_name.singularize}" do
    it "looks up the resource" do
      #{plural_name.singularize}_administration.new_#{plural_name.singularize}

      expect(dao).to have_received(:new_#{plural_name.singularize})
    end
  end

  describe "#destroy" do
    it "destroys the resource" do
      #{plural_name.singularize}_administration.destroy 1

      expect(dao).to have_received(:destroy_#{plural_name.singularize}).
        with 1
    end
  end

  describe "#create" do
    it "creates the resource" do
      #{plural_name.singularize}_administration.create #{plural_name.singularize}_attributes

      expect(dao).to have_received(:create_#{plural_name.singularize}).
                    with(#{plural_name.singularize}_attributes)
    end

    context "with valid attributes" do
      let(:validity) { true }

      it "triggers :create_success in the framework" do
        #{plural_name.singularize}_administration.create #{plural_name.singularize}_attributes

        expect(framework).to have_received(:create_success).with #{plural_name.singularize}
      end
    end

    context "with invalid attributes" do
      let(:validity) { false }

      it "triggers :create_failure in the framework" do
        #{plural_name.singularize}_administration.create #{plural_name.singularize}_attributes

        expect(framework).to have_received(:create_failure).with #{plural_name.singularize}
      end
    end
  end

  describe "#update" do
    it "updates the resource" do
      #{plural_name.singularize}_administration.update 1, #{plural_name.singularize}_attributes

      expect(dao).to have_received(:update_#{plural_name.singularize}).
                    with(1, #{plural_name.singularize}_attributes)
    end

    context "with valid attributes" do
      before do
        #{plural_name.singularize}.stub(:valid?).and_return true
      end

      it "triggers :update_success in the framework" do
        #{plural_name.singularize}_administration.update 1, #{plural_name.singularize}_attributes

        expect(framework).to have_received(:update_success).with #{plural_name.singularize}
      end
    end

    context "with invalid attributes" do
      before do
        #{plural_name.singularize}.stub(:valid?).and_return false
      end

      it "triggers :update_failure in the framework" do
        #{plural_name.singularize}_administration.update 1, #{plural_name.singularize}_attributes

        expect(framework).to have_received(:update_failure).with #{plural_name.singularize}
      end
    end
  end
end
    FILE
  end

  def create_service_file
    create_file "app/services/#{file_name}_administration.rb", <<-FILE
class #{class_name}Administration
  include Hexagonal

  def all
    dao.all_#{plural_name}
  end

  def new_#{plural_name.singularize}
    dao.new_#{plural_name.singularize}
  end

  def create #{plural_name.singularize}_attributes
    #{plural_name.singularize} = dao.create_#{plural_name.singularize}(#{plural_name.singularize}_attributes)

    meth = #{plural_name.singularize}.valid? ? :create_success : :create_failure

    framework.send meth, #{plural_name.singularize}
  end

  def edit id
    dao.find_#{plural_name.singularize} id
  end

  def destroy id
    dao.destroy_#{plural_name.singularize} id
  end

  def update id, attributes
    #{plural_name.singularize} = dao.update_#{plural_name.singularize} id, attributes

    meth = #{plural_name.singularize}.valid? ? :update_success : :update_failure
    framework.send meth, #{plural_name.singularize}
  end
end
FILE
  end

  desc "Create scaffold to follow hexagonal Rails ports and adapters pattern"
  def create_controller_file
    create_file "app/controllers/#{plural_name}_controller.rb", <<-FILE
class #{class_name.pluralize}Controller < ApplicationController
  before_action :set_#{plural_name}, only: [:show, :edit, :update, :destroy]
  decorates_assigned :#{plural_name}, :#{plural_name.singularize}

  # GET /#{plural_name}
  # GET /#{plural_name}.json
  def index
    @#{plural_name} = #{plural_name}_administration.all
  end

  # GET /#{plural_name}/1
  # GET /#{plural_name}/1.json
  def show
  end

  # GET /#{plural_name}/new
  def new
    @#{plural_name.singularize} = #{plural_name.singularize}_administration.new_#{plural_name.singularize}
  end

  # GET /#{plural_name}/1/edit
  def edit
  end

  # PATCH/PUT /#{plural_name}/1
  # PATCH/PUT /#{plural_name}/1.json
  def update
    #{plural_name.singularize}_administration.update params[:#{plural_name.singularize}_id], #{plural_name}_params
  end

  # Hexagonal pattern - success callback
  def update_success
    respond_to do |format|
      format.html { redirect_to @#{plural_name.singularize}, notice: '#{class_name} was successfully updated.' }
      format.json { head :no_content }
    end
  end

  # Hexagonal pattern - failure callback
  def update_failure
    respond_to do |format|
      format.html { render action: 'edit' }
      format.json { render json: @#{plural_name.singularize}.errors, status: :unprocessable_entity }
    end
  end

  def create
    #{plural_name}_administration.create #{plural_name}_params
  end

  # Hexagonal pattern - success callback
  def create_success #{plural_name}
    redirect_to admin_#{plural_name}s_path
  end

  # Hexagonal pattern - failure callback
  def create_failure #{plural_name}
    @#{plural_name} = #{plural_name}
    render action: 'new'
  end

  # DELETE /#{plural_name}/1
  # DELETE /#{plural_name}/1.json
  def destroy
    @#{plural_name.singularize}.destroy
    respond_to do |format|
      format.html { redirect_to #{plural_name}_url }
      format.json { head :no_content }
    end
  end

  private

  def #{plural_name}_administration
    @#{plural_name}_administration ||= #{class_name}Administration.new(self, dao)
  end

  def dao
    @dao ||= Dao::#{class_name}.new
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_#{plural_name.singularize}
    @#{plural_name.singularize} = #{plural_name.singularize}_administration.find_#{plural_name.singularize}(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def #{plural_name.singularize}_params
    params.require(:#{plural_name.singularize})
  end
end
    FILE
  end
end
