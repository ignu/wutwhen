wut = {}
wut.init = function() {
	$('.session').click(wut.show_details);
	$('.abstract').live("click", wut.hide_details);
	$('.session:even').addClass("dark");
};
wut.show_details = function() {
	$(this).find('.abstract').show();
};
wut.hide_details = function() {
	$('.abstract').hide();
}
$(wut.init)