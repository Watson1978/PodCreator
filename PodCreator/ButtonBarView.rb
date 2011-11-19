#
#  ButtonBar.rb
#  CodeSnippet
#

class ButtonBarView < NSView

  def initWithFrame(frame)
    if super
      top = NSColor.colorWithCalibratedWhite(250.0/255.0, alpha:1.0)
      bottom = NSColor.colorWithCalibratedWhite(250.0/255.0, alpha:1.0)
      @gradient1 = NSGradient.alloc.initWithStartingColor(top, endingColor:bottom)

      top = NSColor.colorWithCalibratedWhite(230.0/255.0, alpha:1.0)
      bottom = NSColor.colorWithCalibratedWhite(230.0/255.0, alpha:1.0)
      @gradient2 = NSGradient.alloc.initWithStartingColor(top, endingColor:bottom)
      
      @resizeHandleColor = NSColor.colorWithCalibratedWhite(50.0/ 255.0, alpha:0.598)
    end
    return self
  end

  def drawRect(rect)
    # draw gradient
    gradientRect = NSMakeRect(rect.origin.x, rect.size.height/2, rect.size.width, rect.size.height);
    @gradient1.drawInRect(gradientRect, angle:270)

    gradientRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    @gradient2.drawInRect(gradientRect, angle:270)

    NSColor.grayColor.set
    # draw bottom-edge line
    from = NSMakePoint(0, 0)
    to   = NSMakePoint(rect.size.width, 0)    
    NSBezierPath.strokeLineFromPoint(from, toPoint:to)  

    # draw top-edge line
    from = NSMakePoint(0, rect.size.height)
    to   = NSMakePoint(rect.size.width, rect.size.height)    
    NSBezierPath.strokeLineFromPoint(from, toPoint:to)  

    # draw left-edge line
    from = NSMakePoint(0, 0)
    to   = NSMakePoint(0, rect.size.height)    
    NSBezierPath.strokeLineFromPoint(from, toPoint:to)  

    # draw right-edge line
    from = NSMakePoint(rect.size.width, 0)
    to   = NSMakePoint(rect.size.width, rect.size.height)    
    NSBezierPath.strokeLineFromPoint(from, toPoint:to)  
  
  end
end

