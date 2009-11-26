wut = {}
wut.init = function() {
	$('.showAbstract').click(wut.show_details);
	$('.abstract').click(wut.hide_details)
};
wut.show_details = function() {
	$(this).parent('div').find('.abstract').show();
};
wut.hide_details = function() {
	$('.abstract').hide();
}
$(wut.init)