class LNFile
  attr_accessor :name, :size, :type, :download_link
  def initialize name, size, type, download_link=nil
    @name = name
    @size = size
    @type = type
    @download_link = download_link
  end
end
