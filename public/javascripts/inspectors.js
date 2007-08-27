/*
Original "col3" Border values
border-left: 250px #e5f4d7 solid;
border-right: 320px #fff solid;
*/
 
/* init ui variables */
var ui={}; 
ui.left= true; 
ui.right= true; 
 
/* hide left column */

function toggleLeft() {
  Element.toggle("col1");
  
  if (ui.left) {
    $("col3").setStyle( { borderLeft: "5px"	} );     
    $("toleft").src  = "/images/16addleft.png";
    ui.left = false;
  } else {
    $("col3").setStyle( { borderLeft: "252px #444 solid" } ); 
    $("toleft").src  = "/images/16toleft.png";
    ui.left = true; 
  }
}

/* hide right column */

function toggleRight() {
  Element.toggle("col2");
  Element.toggle("tabs");
  
  if (ui.right) {
    $("col3").setStyle( { borderRight: "5px" } );  
    $("tabs").setStyle( { visible: "hidden" } );
    $("toright").src  = "/images/16addright.png";
    ui.right = false;
  } else {
    $("col3").setStyle( { borderRight: "300px #fff solid" } );     
    $("tabs").visible = true;   
    $("toright").src  = "/images/16toright.png";
    ui.right = true; 
  }
}