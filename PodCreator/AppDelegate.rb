#
#  AppDelegate.rb
#  PodCreator
#

class AppDelegate

  def applicationDidFinishLaunching(a_notification)
  end

  def windowWillClose(a_notification)
    NSApp.terminate(self)
  end
end

