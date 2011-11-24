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
end

class PodList < NSWindowController
  attr_accessor :delegate
  attr_accessor :tableView
  attr_accessor :arrayController

  def init
    @platform = ""
    @pods = Spec::list

    super
    self.initWithWindowNibName("PodList")
  end

  def awakeFromNib
    tableView.setTarget(self)
    tableView.setDoubleAction("selectPods:")

    center = NSNotificationCenter.defaultCenter
    center.addObserver(self,
                       selector:"prepareList:",
                       name:"NSWindowWillBeginSheetNotification",
                       object:nil)
  end

  #----------------------------------------
  def prepareList(sender)
    obj = arrayController.arrangedObjects
    arrayController.removeObjects(obj)

    @pods.each do |pod|
      if pod['platform'].size == 0 || pod['platform'] == @platform
        arrayController.addObject(pod)
      end
    end
  end

  def selectPods(sender)
    obj = arrayController.selectedObjects.first
    if obj
      delegate.addPod(obj)
      self.window.orderOut(self)
    end
  end

  #----------------------------------------
  def setPlatform(platform)
    @platform = platform
  end

end

