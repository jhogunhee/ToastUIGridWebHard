<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>웹하드 과제</title>
	<link rel="stylesheet" href="/node_modules/tui-time-picker/dist/tui-time-picker.css">
    <link rel="stylesheet" href="/node_modules/tui-date-picker/dist/tui-date-picker.css">
    <link rel="stylesheet" href="/node_modules/tui-grid/dist/tui-grid.css">
    <link rel="stylesheet" href="/node_modules/bootstrap/dist/css/bootstrap.min.css">
    
    <script src="/node_modules/jquery/dist/jquery.js"></script>
    <script src="/node_modules/bootstrap/dist/js/bootstrap.js"></script>
    <script src="/node_modules/tui-code-snippet/dist/tui-code-snippet.js"></script>
    <script src="/node_modules/tui-time-picker/dist/tui-time-picker.min.js"></script>
    <script src="/node_modules/tui-date-picker/dist/tui-date-picker.min.js"></script>
    <script src="/node_modules/tui-grid/dist/tui-grid.js"></script>
</head>
<style>
.upload_modal-body {
	border: 2px dotted #3292A2;
	width: 90%;
	height: 50px;
	color: #92AAB0;
	text-align: center;
	font-size: 24px;
	padding-top: 12px;
	margin-top: 10px;
}

.modal-dialog_upload.modal-80size {
	width: 80%;
	height: 50%;

	 margin: 0;
	padding: 0; 
}

.modal-80size {
	height: auto;
	min-height: 50%;
}
</style>
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
		
		var param = "";
		grid.on('dblclick', function(e) {
	        console.log('modifyDate dblclick!', e);
	        var date        = grid.getRow(e.rowKey).modifyDate;
	        var folderName  = grid.getRow(e.rowKey).fileName;

	        // 폴더를 클릭하였을떄 
	        if(date == null || date == '') {
	            if(folderName == '..') {
	  				param = param.substring(0, param.lastIndexOf("/", param.length - 2));
	  			} else {
	  				// 상위 폴더를 클릭하였을떄
					param += folderName + "/";
	  			}
	        	$.ajax({
	        		url : "/getFileList?param=" + param,
	    			method : "get",
	    			dataType : "JSON",
	    			
	    			error : function() {alert("똑바로 안 했!!!")},
	    			success : function(result) {
	    				grid.resetData(result);
	    			}		
	        	});
	        } else {
	        	// 파일을 클릭하였을떄
	        	location.href = "getFileDownload?FILE_NAME=" + grid.getRow(e.rowKey).fileName;   
	        }
	    });
		
		// 파일업로드
		var obj = $("#dropzone");
		
		obj.on('dragenter', function (e) {
			e.stopPropagation(); // 상위 노드로 가는 이벤트를 멈춘다.
			e.preventDefault(); // 현재 객체에 있는 실행요소를 멈춘다.
			
			$(this).css('border', '2px solid #5272A0');
		});
		
		obj.on('dragleave', function (e) {
			e.stopPropagation(); // 상위 노드로 가는 이벤트를 멈춘다.
			e.preventDefault(); // 현재 객체에 있는 실행요소를 멈춘다.
			
			$(this).css('border', '2px dotted #8296C2');
		});
		
		obj.on('dragover', function (e) {
			e.stopPropagation(); // 상위 노드로 가는 이벤트를 멈춘다.
			e.preventDefault(); // 현재 객체에 있는 실행요소를 멈춘다.
		});
		
		obj.on('drop', function (e) {
			e.preventDefault();
			e.stopPropagation(); // 상위 노드로 가는 이벤트를 멈춘다.
			$(this).css('border', '2px dotted #8296C2');
			
			var files = e.originalEvent.dataTransfer.files;
			
			if(files.length < 1) {
				return;
			}
			
			if(confirm(files.length + "개의 파일을 업로드 하시겠습니까?")) {
				var data = new FormData();
				for(var i = 0; i < files.length; i++) {
					data.append('files', files[i]);
				}
				
				var url = "/upload";
				
				$.ajax({
					url         : url,
					method      : 'POST',
					data        : data,
					
					// 일반적으로 서버에 전달되는 데이터는 query string 이라는 형태로 전달된다
					// 파일 전송의 경우 이를 하면 안된다.
					processData : false, 
					// contentType 은 default 값이 "application/x-www-form-urlencoded; charset=UTF-8" 인데, "multipart/form-data" 로 전송이 되게 false 로 넣어준다
					// false 말고 "multipart/form-data"를 넣으면 제대로 동작하지 않는다.
					contentType : false,
					success : function(res) {
						alert("업로드가 완료되었습니다.");
						$("#my80sizeModal").modal("hide");
						location.reload(true);
					},
					error : function(res) {
						alert("업로드 중에 에러가 발생했습니다. 파일은 10M를 넘을 수 없습니다.")
						console.log(res);
					}
				});
			}
		})
		
		$('#mkDirText').on('click', function() {
		   var mkDirText = param + $("#message-text").val();
		   $.ajax({
				url         : "mkDirFolder",
				method      : "GET",
				data        : {
					"mkDirText" : mkDirText 
				},
				success : function() {
					alert("성공적으로 폴더 생성되었습니다.")
					
					/* location.reload(true); */
				}
		   });
		});
	}
	
	
</script>
<body>
	<div class="container">
		<!-- Large modal -->
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#my80sizeModal">File Upload</button>
		<button type="button" class="btn btn-primary" data-toggle="modal" id="mkFolder"
		data-target="#exampleModal" data-whatever="@mdo">폴더 생성</button>

		<div id="grid"></div>
	</div>

	<!-- 80% size Modal -->
	<div class="modal fade" id="my80sizeModal" tabindex="-1" role="dialog" data-backdrop="static"
		aria-labelledby="my80sizeModalLabel">
		<div class="modal-dialog_upload modal-80size" role="document">
			<div class="modal-content modal-80size">
				<div class="modal-header">
					<h4 class="modal-title" id="myModalLabel">업로드 할 파일을 넣어주세요</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="upload_modal-body" id="dropzone"> </div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title" id="exampleModalLabel">생성할 폴더를 적어주세요</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					
				</div>
				<div class="modal-body">
					<form>
						<div class="form-group">
							<textarea class="form-control" id="message-text"></textarea>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="mkDirText">Send message</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
