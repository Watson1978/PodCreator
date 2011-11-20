#
#  AppDelegate.rb
#  PodCreator
#

class AppDelegate
  attr_accessor :window
  attr_accessor :platformButton
  attr_accessor :addButton, :removeButton, :createButton
  attr_accessor :tableView

  PLATFORM = {'iOS' => ":ios", 'Mac' => ":osx" }

  def applicationDidFinishLaunching(a_notification)
    @depend = []
    @podList = PodList.alloc.init
    @podList.delegate = self
  end

  #----------------------------------------
  def numberOfRowsInTableView(aTableView)
    return 0 if @depend.nil?
    return @depend.size
  end

  def tableView(aTableView,
                objectValueForTableColumn:aTableColumn,
                row:rowIndex)
    return @depend[rowIndex]
  end

  def control(control,
              textShouldEndEditing:fieldEditor)
    index = tableView.editedRow
    @depend[index] = fieldEditor.string.dup
  end

  #----------------------------------------
  def showList(sender)
    NSApp.beginSheet(@podList.window,
                     modalForWindow:window,
                     modalDelegate:self,
                     didEndSelector:nil,
                     contextInfo:nil)

    NSApp.endSheet(@podList.window)
  end

  def remove(sender)
    index = tableView.selectedRow

    if index >= 0
      @depend.delete_at(index)
      tableView.reloadData
    end
  end

  def create(sender)
    panel = NSSavePanel.savePanel
    panel.setCanChooseDirectories(true)
    result = panel.runModalForDirectory(NSHomeDirectory(),
                                        file:"Podfile")
    if(result == NSOKButton)
      path = panel.filename
      plat = platformButton.titleOfSelectedItem

      File.open(path, "w") {|f|
        f.puts "platform #{PLATFORM[plat]}"
        @depend.each do |item|
          f.puts "dependency '#{item}'"
        end
      }
      system "open -a TextEdit '#{path}'"
    end
  end

  #----------------------------------------
  def addPod(pod)
    @depend << pod.name.dup
    tableView.reloadData
  end

end

