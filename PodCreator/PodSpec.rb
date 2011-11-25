#
#  PodSpec.rb
#  PodCreator
#

class PodSpec
  attr_accessor :repoButton
  attr_accessor :repoTagCombo
  attr_accessor :platformButton
  attr_accessor :objectController

  def create(sender)
    objectController.commitEditing
    content = objectController.content

    panel = NSSavePanel.savePanel
    panel.setAllowedFileTypes(["podspec"])
    panel.setExtensionHidden(false)
    result = panel.runModalForDirectory(NSHomeDirectory(),
                                        file:"")
    if(result == NSOKButton)
      path = panel.filename
      File.open(path, "w") {|f|
        @io = f
        f.puts "Pod::Spec.new do |s|"

        content.keys.each do |k|
          case k

          when "author_name"
            if content['author_mail'] && content['author_mail'].length > 0
              str = "{ #{make_hash_str2(content[k], content['author_mail'])} }"
            else
              str = "'#{content[k]}'"
            end
            out_spec("author", str)

          when "repo_url"
            type = repoButton.titleOfSelectedItem
            str  = "{ #{make_hash_str(type, content[k])}"
            i = repoTagCombo.indexOfSelectedItem
            str += ", #{make_hash_str(repoTagCombo.itemObjectValueAtIndex(i), content['repo_tag'])}" if i >= 0
            str += " }"
            out_spec("source", str)

          when "dep_framework"
            out_specs("framework", "frameworks", content[k])

          when "dep_library"
            out_specs("library", "libraries", content[k])

          when "source_files"
            out_specs("source_files", "source_files", content[k])
          
          when "requires_arc"
            out_spec(k, content[k].to_s)

          when "author_mail", "repo_tag"
            # ignore

          else
            out_spec(k, "'#{content[k]}'")
          end
        end

        plat = PodUtil::getSelectedPlatform(platformButton.titleOfSelectedItem)
        out_spec("platform", plat) if plat

        f.puts "end"
      }

      system "open -a TextEdit '#{path}'"
    end
  end

  #----------------------------------------
  def make_hash_str(key, value)
    ":#{key} => '#{value}'"
  end

  def make_hash_str2(key, value)
    "'#{key}' => '#{value}'"
  end

  def out_specs(key_s, key_m, data)
    ary = data.split(',')
    if ary.size > 1
      data = ary.map{ |x| "'#{x.strip}'" }.join(', ')
      out_spec(key_m, data)
    else
      out_spec(key_s, "'#{data.strip}'")
    end
  end

  def out_spec(key, data)
    @io.puts "  s.#{key} = #{data}"
  end
end
