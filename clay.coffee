class GridResizer
  
  constructor: (@container, @minWidth, @padding)->
    @measure()
    @layout()
    @bindOnResize()
    
  measure: =>
    width = @container.outerWidth()
    itemCnt = width / @minWidth
    width -= ( @padding * ( itemCnt + 1 ) ) if @padding
    @colCnt = Math.floor(itemCnt)
    offsetWidth = ( ( width - ( @colCnt * @minWidth ) ) / @colCnt )
    @itemWidth = offsetWidth + @minWidth
    @grid = []
    $('.item').each (i, item)=>
      height = $(item).height()
      col = i % @colCnt
      row = Math.floor( i / @colCnt )
      @grid.push [] if !@grid[row]
      @grid[row][col] = 
        x: if col == 0 then @padding else @itemWidth + @grid[row][col - 1].x + @padding
        y: if row == 0 then @padding else @grid[row - 1][col].item.height() + @grid[row - 1][col].y + @padding
        item: $(item)
    console.log(@grid) 

  layout: =>
    $('.item').width(@itemWidth)
    for row in @grid
      for obj in row
        obj.item.css
          transform: "translate(#{obj.x}px,#{obj.y}px)"     
  
  bindOnResize: =>
    cb = @debounce =>
      @measure()
      @layout()
    1000
    $( window ).on 'resize', ->
      cb()
      
  debounce: (func, threshold, execAsap) ->
    timeout = null
    (args...) ->
      obj = this
      delayed = ->
        func.apply(obj, args) unless execAsap
        timeout = null
      if timeout
        clearTimeout(timeout)
      else if (execAsap)
        func.apply(obj, args)
      timeout = setTimeout delayed, threshold || 100