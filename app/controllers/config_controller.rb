require 'date'
class ConfigController < ApplicationController
  before_action :authenticate_user!
  DATATYPES = [:boolean,:date,:datetime,:float,:integer,:string,:text,:time]
  
  def system!(*args)
    system(*args) || abort("\n== Command #{args} failed ==")
  end

  def index
    fields          = {}
    @data_types     = DATATYPES
    db_tables       = ActiveRecord::Base.connection.tables
    metadata_tables = ['schema_migrations','ar_internal_metadata','users']
    @tables         =  db_tables - metadata_tables
    ActiveRecord::Base.connection.columns('projects').each do |c| 
      fields["#{c.name}"] =  c.type
    end
    @fields         = fields
  end

  def create
    puts "\n== Adding Property #{params[:property]} into #{params[:table].titleize} Table as #{params[:data_type]} datatype ==".green
    system! "rails generate migration Add_#{DateTime.now.to_time.to_i}_FieldsTo#{params[:table].titleize} #{params[:property]}:#{params[:data_type]}"
    puts "\n== Migrating database for #{current_user.subdomain} tenant==".red
    system! "DB=#{current_user.subdomain} bin/rails db:migrate"
    puts "\n== Migration executed successfully==".yellow
    redirect_to config_index_url(subdomain: current_user.subdomain), notice: "property added successfully"
  end

end 