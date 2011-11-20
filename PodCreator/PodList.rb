#
#  PodList.rb
#  PodCreator
#

class PodList < NSWindowController
  attr_accessor :delegate
  attr_accessor :tableView

  def init
    @pods ||= Pod::Source::search_by_name("", true)

    super
    self.initWithWindowNibName("PodList")
  end

  def awakeFromNib
    tableView.setTarget(self)
    tableView.setDoubleAction("selectPods:")
  end

  #----------------------------------------
  def numberOfRowsInTableView(aTableView)
    return 0 if @pods.nil?
    return @pods.size
  end

  def tableView(aTableView,
                objectValueForTableColumn:aTableColumn,
                row:rowIndex)
    case aTableColumn.identifier
    when 'name'
      @pods[rowIndex].name
    when 'version'
      @pods[rowIndex].versions.reverse.join(", ")
    when 'description'
      @pods[rowIndex].specification.summary
    end
  end

  #----------------------------------------
  def selectPods(sender)
    index = tableView.selectedRow

    if index >= 0
      delegate.addPod(@pods[index])
      self.window.orderOut(self)
    end
  end

end

