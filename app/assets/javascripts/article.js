function sync_article_text(ueditor_container_id){
	var ue = UE.getEditor(ueditor_container_id);
	$('textarea[name="article[text]"]').html(ue.getContent());
};
