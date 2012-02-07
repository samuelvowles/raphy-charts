# @import effects.coffee 

class Tooltip
  constructor: (@r, target, text, hover_enabled = true) ->
    size = 30
    width = 50
    height = 25 
    offset = 10
    rounding = 5

    text = Math.round(text*100)/100 if typeof text == "number"
      

    box = target.getBBox()
    x = box.x
    y = box.y
    box_width = box.width
    box_height = box.height
    box_midpoint = (x + box_width/2)

    @popup = @r.set()
    
    @popup.push @r.rect(
      box_midpoint - width/2,
      y - (height + offset),
      width,
      height,
      rounding
    )

    @popup.push @r.triangle(
      box_midpoint,
      y - offset + 4,
      4 
    ).rotate(180)

    @popup.attr({
      "fill" : "rgba(0,0,0,.4)"
      "fill-opacity": 0 
      "stroke" : "transparent"
      "stroke-width" : 0
    })

    @text = @r.text(box_midpoint, y - (height/2 + offset), text)
    @text.attr({ 
      "fill"        : "#fff"
      "font-size"   : 14 
      "text-anchor" : "middle" 
      "width"       : width
      "height"      : height 
      "fill-opacity": 0
      "font-weight" : "bold"
    })

    @popup.toFront()
    @text.toFront()

    if hover_enabled == true
      target.mouseover () => @show()
      target.mouseout  () => @hide()

  animate_opacity: (element, value, time = 200) ->
    element.animate({
      "fill-opacity" : value
    }, time, () =>
      if value == 0
        @text.toBack()
        @popup.toBack()
    )

  hide: () ->
    @animate_opacity(@popup, 0)
    @animate_opacity(@text, 0)

  show: () ->
    @popup.toFront()
    @text.toFront()
    @animate_opacity(@popup, 0.8)
    @animate_opacity(@text, 1)



exports.Tooltip = Tooltip
