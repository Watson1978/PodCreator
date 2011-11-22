#
#  PodList.rb
#  PodCreator
#

module Spec
  module_function
  def list
    result = []

    pods = Pod::Source::search_by_name("", false)
    pods.each do |pod|
      h = {}
      ['name', 'homepage', 'version', 'license'].each do |item|
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
end

class PodList < NSWindowController
  attr_accessor :delegate
  attr_accessor :tableView
  attr_accessor :arrayController

  def init
    @pods = Spec::list

    super
    self.initWithWindowNibName("PodList")
  end

  def awakeFromNib
    tableView.setTarget(self)
    tableView.setDoubleAction("selectPods:")
    @pods.each do |pod|
      arrayController.addObject(pod)
    end
  end

  #----------------------------------------
  def selectPods(sender)
    obj = arrayController.selectedObjects.first
    delegate.addPod(obj)
    self.window.orderOut(self)
  end

end

