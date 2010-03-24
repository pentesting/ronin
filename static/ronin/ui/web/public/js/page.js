var Ronin = {	
	setupAjaxCallbacks: function($){
		$('body').ajaxStart(function () {
			// ...
		});

		$('body').ajaxStop(function () {
			// ...
		});

		$('body').ajaxError(function (event, xhr, ajaxOptions, thrownError) {
			console.log("XHR Response: " + JSON.stringify(xhr));
		});

	},

	setupFlash: function($){
		$("p.flash-notice, p.flash-error").click(function() {
		   $(this).slideUp();
		 });

	 	$("p.flash-notice").delay(3000).slideUp();
	},

	setupMainMenu: function($){
		$("#sub-apps-menu > div.bottom").click(function() {
		$("#sub-apps-menu > ul").slideToggle("fast");
	 });

	 $("#sub-apps-menu > ul").click(function() {
	   $(this).slideUp("fast");
	 });	
	}
}

jQuery(document).ready(function($) {
	
	Ronin.setupAjaxCallbacks($);
	Ronin.setupFlash($);
	Ronin.setupMainMenu($);
	
});
