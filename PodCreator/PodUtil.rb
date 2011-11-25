#
#  PodUtil.rb
#  PodCreator
#

module PodUtil
  module_function
  def list
    result = []

    pods = Pod::Source::search_by_name("", false)
    pods.each do |pod|
      h = {}
      ['name', 'homepage', 'version', 'license', 'platform'].each do |item|
        h[item] = eval("pod.specification.#{item}") || ""
      end

      h['description'] = pod.specification.summary || ""

      ary = []
      authors = pod.specification.authors
      authors.keys.each do |k|
        author  = k
        author += " <#{authors[k]}>" if authors[k]
        ary << author
      end
      h['authors'] = ary.join(', ')

      result << h
    end
    result
  end

  #----------------------------------------
  PLATFORM = {'iOS' => ":ios", 'Mac' => ":osx" }
  def getSelectedPlatform(str)
    PLATFORM[str]
  end
end
