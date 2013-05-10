jQuery(function($){

	$('body').scrollspy({
		target: '.navbar',
		offset: 70
	});

	$("a[href^='#']", '.navbar li').click(function(event){
		event.preventDefault();
		var full_url = this.href,
		parts = full_url.split("#"),
		trgt = parts[1];
		var target_offset = $("#"+trgt).offset();
		var target_top = target_offset.top - 70;
		$('html, body').animate({
			scrollTop: target_top
		}, 1000, 'easeOutQuad');
	});

	var $top = $('.navbar .top').eq(0),
	$navbar_top = $('.navbar-fixed-top').eq(0),
	navbar_shaded = false;

	$(window).scroll(function(test){
		if($(window).scrollTop() > 1) {
			if(navbar_shaded) {
				return
			}
			navbar_shaded = true;
			$navbar_top.addClass('shade');
			$top.fadeIn();
		} else {
			if(!navbar_shaded) {
				return
			}
			navbar_shaded = false;
			$top.fadeOut();
			$navbar_top.removeClass('shade');
		}
	})
});
