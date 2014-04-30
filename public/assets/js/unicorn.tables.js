/**
 * Unicorn Admin Template
 * Version 2.0.1
 * Diablo9983 -> diablo9983@gmail.com
**/

$(document).ready(function(){
	
	$('.data-table').dataTable({
		"bJQueryUI": true,
		"sPaginationType": "full_numbers",
		"sDom": '<""l>t<"F"fp>',
		"oLanguage": {
              "oPaginate": {
                "sFirst": "首页",
                "sLast": "末页",
                "sNext": "下一页",
                "sPrevious": "上一页"
              },
              "sSearch":"查询",
              "sLengthMenu": "每页显示 _MENU_ 条数据"
            }
	});
	
	var checkboxClass = 'icheckbox_flat-blue';
	var radioClass = 'iradio_flat-blue';
	$('input[type=checkbox],input[type=radio]').iCheck({
    	checkboxClass: checkboxClass,
    	radioClass: radioClass
	});
	
	$('select').select2();
	

	$("span.icon input:checkbox, th input:checkbox").on('ifChecked || ifUnchecked',function() {
		var checkedStatus = this.checked;
		var checkbox = $(this).parents('.widget-box').find('tr td:first-child input:checkbox');		
		checkbox.each(function() {
			this.checked = checkedStatus;
			if (checkedStatus == this.checked) {
				$(this).closest('.' + checkboxClass).removeClass('checked');
			}
			if (this.checked) {
				$(this).closest('.' + checkboxClass).addClass('checked');
			}
		});
	});	
});
