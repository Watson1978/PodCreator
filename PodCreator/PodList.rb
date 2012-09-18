#
#  PodList.rb
#  PodCreator
#

class PodList < NSWindowController
  attr_accessor :delegate
  attr_accessor :tableView
  attr_accessor :arrayController

  def init
    @platform = ""
    @pods = PodUtil::list

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
      begin
        if pod['platform'] == @platform || pod['platform'].empty?
          arrayController.addObject(pod)
        end
      rescue
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

