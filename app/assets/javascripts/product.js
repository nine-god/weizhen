function sync_product_profile(ueditor_container_id){
	// console.log(ueditor_container_id)
	var ue = UE.getEditor(ueditor_container_id);
	$('textarea[name="product[profile]"]').html(ue.getContent());
};
