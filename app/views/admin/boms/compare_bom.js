$('#bom_parts').html('<%= escape_javascript render(:partial => "column", :collection => @columns) %>');
$('#paginator').html('<%= escape_javascript(paginate(@columns, :remote => true).to_s) %>');
$('#download_links').html('<%= [I18n.t('active_admin.download'), (link_to "CSV", {:format => :csv, :target_bom => @target_bom})].flatten.join("&nbsp;").html_safe %>');