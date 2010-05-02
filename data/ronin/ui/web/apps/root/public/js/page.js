var Ronin = {	
	setupAjaxCallbacks: function($) {
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

	setupFlash: function($) {
	},

	setupMainMenu: function($) {
	}
}

jQuery(document).ready(function($) {
	Ronin.setupAjaxCallbacks($);
	Ronin.setupFlash($);
	Ronin.setupMainMenu($);
});
