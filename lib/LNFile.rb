class LNFile
  attr_accessor :name, :size, :type, :download_link, :original_path, :origin
  def initialize name, size, type, original_path=nil, origin=nil, download_link=nil
    @name = name
    @size = size
    @type = type
    @download_link = download_link
    @origin = origin
    @original_path = original_path
  end
end
