#
#  PodList.rb
#  PodCreator
#

module Spec
  ITEMS = ['name', 'homepage', 'description', 'version', 'authors', 'license']

  module_function
  def list
    result = []

    pods = Pod::Source::search_by_name("", false)
    pods.each do |pod|
      h = {}
      ITEMS.each do |item|
        h[item] = eval("pod.specification.#{item}") || ""
      end

      authors = []
      h['authors'].keys.each do |k|
        author  = k
        author += " <#{h['authors'][k]}>" if h['authors'][k]
        authors << author
      end
      h['authors'] = authors.join(', ')

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

