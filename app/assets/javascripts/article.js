function sync_article_text(){
	var ue = UE.getEditor('ueditor_container');
	$('textarea[name="article[text]"]').html(ue.getContent());
};
