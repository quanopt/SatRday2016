setTimeout(function(){
  var plane = $(".irs-slider")
               .css("background", "rgba(0,0,0,0)")
               .css("border", "0px")
               .css('box-shadow', '0px 0px 0px #FFF')
               .prepend('<img class="planeSlider" src="plane.gif" />');
  var plane = $(".planeSlider");
  plane.css("width", "500%");
  plane.css("position", "relative");
  plane.css("left", "-" + (plane.width()/2) + "px");
  plane.css("top", "-17px");
}, 3000);
