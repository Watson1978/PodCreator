#
#  PodList.rb
#  PodCreator
#

class PodList < NSWindowController
  attr_accessor :delegate
  attr_accessor :tableView
  attr_accessor :arrayController

  def init
    @pods = Pod::Source::search_by_name("", true)

    super
    self.initWithWindowNibName("PodList")
  end

  def awakeFromNib
    tableView.setTarget(self)
    tableView.setDoubleAction("selectPods:")
    @pods.each do |pod|
      arrayController.addObject({'name' => pod.name,
                                  'version' => pod.versions.join(", "),
                                  'description' => pod.specification.summary
                                })
    end
  end

  #----------------------------------------
  def selectPods(sender)
    obj = arrayController.selectedObjects.first
    delegate.addPod(obj)
    self.window.orderOut(self)
  end

end

