// Navigation
// behavior for navigation selection
 Event.addBehavior({
      ".topic-item a:click" : function(event) { 
					this.up(1).addClassName('selected');
					this.up(1).siblings().invoke('removeClassName','selected');
			},
 });