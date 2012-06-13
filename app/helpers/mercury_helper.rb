module MercuryHelper

  def mercury_edit_path(path = nil)
    mercury_engine.mercury_editor_path(path.nil? ? request.path.gsub(/^\/\/?(editor)?/, '') : path)
  end

end
