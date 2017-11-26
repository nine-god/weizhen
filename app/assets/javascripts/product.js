function sync_product_profile(){
	var ue = UE.getEditor('ueditor_container');
	$('textarea[name="product[profile]"]').html(ue.getContent());
};
