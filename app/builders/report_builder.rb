class ReportBuilder
  def initialize(report, page, per_page)
    @main_type=report.main_type
    @parent_type=report.parent_type
    @type_fields=report.main_type_array
    @parent_type_fields=report.parent_type_array
    @filter={}
    @per_page = per_page
    @main_offset = (page - 1) * per_page
    @search = EsQuery.new
  end

  def selected_fields
    @selected_fields ||= build_selected_fields
  end

  def result_docs
    @result_docs ||= Hash.new{|hash, key| hash[key] = Hash.new}
  end

  def parent_doc
    @parent_doc ||= Hash.new
  end

  def build_main_data
    find_selected_docs(:main).limit(@per_page).skip(@main_offset).map do |doc|
      doc_id=doc['_id']
      sort_order <<  doc_id unless sort_value[:main].blank?
      parent_doc[doc_id]= doc['_parent_coll']['id'] if has_parent_type?
      doc_fields[:main].each do |field|
        result_docs[doc_id][field]=doc[field]
      end
    end
    parent_doc && parent_doc.values.uniq 
  end

  def build_parent_data(doc_ids)
    query= { '_id' => {'$in' => doc_ids} }

    find_selected_docs(:parent, search: query).map do |doc|
      doc_id=doc['_id']
      
      result_docs.keys.each do |main_id|
        next unless doc_id == parent_doc[main_id]
        sort_order <<  main_id unless sort_value[:parent].blank?
        doc_fields[:parent].each do |field|
          result_docs[main_id][ rename_field(field) ] = doc[field]
        end
      end
    end
  end

  def get_parent_ids(limit, offset)
    find_docs(:parent).select('_id' => 1).limit(limit).skip(offset).map do |doc|
      doc['_id']
    end
  end

  def sort_order
    @sort_order ||= Array.new
  end

  def data
    # if has_parent_type?
    #   parent_count=find_docs(:parent).count
    #   0.step(parent_count, @per_page) do |parent_offset|
    #     parent_ids  = get_parent_ids(@per_page, parent_offset)
    #     update_main_search_parent_ids(parent_ids)
       
    #     # Rails.logger.debug "#{search_criterias[:main].inspect}"
    #     res_parent_ids = build_main_data
    #     build_parent_data(res_parent_ids)
    #   end

    # else
      build_main_data
    # end

    build_rows
  end

  def build_rows
   # if sort_value.blank?
      sort_order = result_docs.keys
    #end
    sort_order.map do |id|
      result_docs[id].values.map {|e| e ? e : ""}
    end
  end

  def update_main_search_parent_ids(parent_ids)
    search_criterias[:main]['_parent_coll.id'] = {'$in' => parent_ids }
  end
  
  def find_docs(coll, search: nil, sort: nil)
    search ||= search_criterias[coll]
    sort ||= sort_value[coll]
    type[coll].find(search).sort(sort)
  end

  def find_selected_docs(coll, search: nil, sort: nil)
    find_docs(coll, search: search, sort: sort).select(selected_fields[coll])
  end

  def total_records
    find_docs(:main).count
  end 

  
  def total_display_records
    find_docs(:main).limit(@per_page).skip(@main_offset).count(true)
  end
  
  def columns
    doc_fields[:main] + doc_fields[:parent]
  end

  def column_maps
    @column_maps ||= build_column_maps
  end

  def build_column_maps
    column_maps = []
    doc_fields[:main].each do |value|
      column_maps <<  { value => :main } 
    end

    doc_fields[:parent].each do |value|
      column_maps <<  { value => :parent } 
    end
    column_maps
  end

  def set_sort(indice, direction)
    coll = column_maps[indice].values.first
    sort_value[coll][columns[indice]] = direction
  end

  def set_search(search)
    search.select do |key, value|
      next if value.blank?
      indice=key.to_i
      coll = column_maps[indice].values.first
      search_criterias[coll][columns[indice]]=/#{value}/
    end
  end



  #private

  def search_criterias
    @search_criterias ||= Hash.new{|hash, key| hash[key] = Hash.new}
  end

  def sort_value
    @sort_value ||=  Hash.new{|hash, key| hash[key] = Hash.new}
  end

  def session
    @session ||= build_session
  end

  def build_session
    session = Moped::Session.new([ "127.0.0.1:27017" ])
    session.use "omnidb"
    session
  end

  def type
    @type ||= build_type
    
  end

  def build_type
    coll=Hash.new
    coll[:main]=session[@main_type]
    coll[:parent]=session[@parent_type]
    coll
  end

  def has_parent_type?
    if @parent_type
      true
    else
      false
    end
  end

  def doc_fields
    @doc_fields ||= build_doc_fields
  end

  def build_doc_fields
    fields=Hash.new
    fields[:main]=@type_fields
    fields[:parent]= @parent_type_fields || Array.new
    fields
  end


  def rename_field(field)
    renamed_fields[field] || field
  end

  def renamed_fields
    @renamed_fields ||= build_renamed_fields
  end

  def build_renamed_fields
    renamed_fields=Hash.new
    common_fields= doc_fields[:main] & doc_fields[:parent]

    common_fields.each { |field| renamed_fields[field]="#{@parent_type}_#{field}"} 
    renamed_fields
  end

  def build_selected_fields
    fields=Hash.new{|hash, key| hash[key] = Hash.new}
    if has_parent_type?
      @parent_type_fields.map {|value| fields[:parent][value] = 1}
    end

    @type_fields.map {|value| fields[:main][value] = 1}
    fields
  end
end