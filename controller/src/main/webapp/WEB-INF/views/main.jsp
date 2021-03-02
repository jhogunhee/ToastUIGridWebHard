<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
	<link rel="stylesheet" href="/node_modules/tui-time-picker/dist/tui-time-picker.css">
    <link rel="stylesheet" href="/node_modules/tui-date-picker/dist/tui-date-picker.css">
    <link rel="stylesheet" href="/node_modules/tui-grid/dist/tui-grid.css">
    <link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.min.css">
    <script src="/node_modules/jquery/dist/jquery.js"></script>
    <script src="/node_modules/tui-code-snippet/dist/tui-code-snippet.js"></script>
    <script src="/node_modules/tui-time-picker/dist/tui-time-picker.min.js"></script>
    <script src="/node_modules/tui-date-picker/dist/tui-date-picker.min.js"></script>
    <script src="/node_modules/tui-grid/dist/tui-grid.js"></script>
</head>
<script>
	var grid;
	window.onload = function() {
		grid = new tui.Grid({
		      el: document.getElementById('grid'),
		      scrollX: false,
		      scrollY: false,
		      columns: [
		        {
		          header: '파일명',
		          name: 'fileName'
		        },
		        {
		          header: '수정일자',
		          name: 'modifyDate',
			      width: 200,
			      align: 'center'
		        },
		        {
			      header: '유형',
			      name: 'type',
			      width: 150,
			      align: 'center'
			    },
		        {
		          header: '파일크기',
		          name: 'capacity',
			      width: 150,
				  align: 'right'
		        }	        
		      ]
		});
		tui.Grid.applyTheme('striped'); 
		
		$.ajax({
			url : "/getFileList",
			method : "get",
			dataType : "JSON",
			data : {},
			error : function() {alert("똑바로 안 했!!!")},
			success : function(result) {
				grid.resetData(result);
			}
		});  
		
		grid.on('dblclick', function(e) {
	        console.log('modifyDate dblclick!', e);
	        var date = grid.getRow(e.rowKey).modifyDate;
	        if(date == null)
	        	alert('디렉토리입니다.');
	        else {
	        	location.href = "getFileDownload?FILE_NAME=" + grid.getRow(e.rowKey).fileName;   
	        }
	    });
	}
</script>
<body>
	<div id="grid"></div>
</body>
</html>
