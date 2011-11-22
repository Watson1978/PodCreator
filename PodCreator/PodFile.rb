#
#  Podfile.rb
#  PodCreator
#

class PodFile
  attr_accessor :window
  attr_accessor :platformButton
  attr_accessor :bridgeSupportCheckBox
  attr_accessor :tableView
  attr_accessor :arrayController

  PLATFORM = {'iOS' => ":ios", 'Mac' => ":osx" }

  def init
    @podList = PodList.alloc.init
    @podList.delegate = self
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
    index = arrayController.selectionIndexes
    arrayController.removeObjectsAtArrangedObjectIndexes(index)
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
        ary = arrayController.arrangedObjects
        ary.each do |item|
          f.puts "dependency '#{item['name']}'"
        end

        if bridgeSupportCheckBox.state == NSOnState
          f.puts "generate_bridge_support!"
        end
      }

      system "open -a TextEdit '#{path}'"
    end
  end

  #----------------------------------------
  def addPod(pod)
    arrayController.addObject(pod.dup)
  end
end
