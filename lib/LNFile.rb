class LNFile
  attr_accessor :name, :size, :type, :download_link, :original_path, :origin, :mime_type
  def initialize name, size, type, mime_type, original_path=nil, origin=nil, download_link=nil
    @name = name
    @size = size
    @type = type
    @mime_type = mime_type
    @download_link = download_link
    @origin = origin
    @original_path = original_path
  end
end
