module MercuryHelper

  def mercury_edit_path(path = nil)
    "/editor/#{path.nil? ? request.path.gsub(/^\/\/?(editor)?/, '') : path}"
  end

end
