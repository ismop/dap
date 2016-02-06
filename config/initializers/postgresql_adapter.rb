class ActiveRecord::ConnectionAdapters::PostGISAdapter::MainAdapter
  def supports_insert_with_returning?
    false
  end
end