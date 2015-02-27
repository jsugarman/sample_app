function updateCountdown() {
    // 140 is the max message length
    var MAX_CHARACTERS = 140;
    var remaining = MAX_CHARACTERS - $('#micropost_content').val().length;
    var $countdown = $('.countdown');
    $countdown.text(remaining + ' characters remaining');

    var text_color = 'grey';
    if (remaining < 21 ) { text_color = 'orange'};
    if (remaining < 11 ) { text_color = 'red'};
    $countdown.css ( { color: text_color} ) ;
}

$(document).ready(function() {	
	updateCountdown();
	$MicropostContent = $('#micropost_content');
	$MicropostContent.keydown(updateCountdown);
	$MicropostContent.keyup(updateCountdown);
	$MicropostContent.change(updateCountdown);
});


