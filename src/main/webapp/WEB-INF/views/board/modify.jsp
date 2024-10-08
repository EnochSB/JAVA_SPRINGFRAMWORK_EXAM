<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 수정</title>
<link rel="stylesheet" href="/resources/CSS/board.css">
<style>
.fileUploadForm {
	margin: 5px;
	padding: 5px 5px 2px 30px;
	text-align: left;
	width:93%;
}

.filename {
	display: inline-block;
	vertical-align: top;
	width: 50%;
}

.filesize {
	display: inline-block;
	vertical-align: top;
	color: #30693D;
	width: 30%;
	margin-left: 10px;
	margin-right: 5px;
}

.fileZone {
	border: solid #adadad;
	background-color: #a0a0a0;
	width: 97%;
	height: 80px;
	color: white;
	text-align: center;
	vertical-align: middle;
	padding: 5px;
	font-size: 120%;
	display: block;
}

.fileUploadList {
	border: solid #adadad;
	width: 97%;
	height: auto;
	padding: 5px;
	font-size: 120%;
	display: block;
}

.statusbar {
	border-bottom: 1px solid #92AAB0;
	min-height: 25px;
	width: 96%;
	padding: 10px 10px 0px 10px;
	vertical-align: top;
}

.statusbar:nth-child(odd) {
	background: #EBEFF0;
}
</style>
<script>
	window.onload = () => {
		
		const fileZone = document.querySelector('#fileZone');
		const inputFile = document.querySelector('#inputFile')
		
		// fileZone을 클릭하면 발생하는 이벤트 처리
		fileZone.addEventListener('click', (e) => {
			inputFile.click(e);
		});
		
		// 파일탐색창을 열어 선택한 파일 정보를 files에 할당
		inputFile.addEventListener('change', (e) => {
			const files = e.target.files;	// 파일들 정보 유사 배열
			fileCheck(files);
		});
		
		/*
		마우스 이벤트 종류
		1. dragstart: 사용자가 객체를 드래그하려고 시작할때 발생.
		2. drag: 대상 객체를 드래그 하면서 마우스를 움직일 때 발생.
		3. dragenter: 마우스가 대상 영역의 위로 처음 진입할 때 발생.
		4. dragover: 드래그 하면서 마우스가 대상 영역 위에 자리 잡고 있을 때 발생.
		5. drop: 드래그가 끝나서 드래그하면 객체를 놓은 장소에서 발생.
		6. dragleave: 드래그가 끝나서 마우스가 대상 객체의 위에서 벗어날 때 발생.
		7. dragend: 드래그한 대상 영역을 벗어날 때 발생.
		*/
		
		// fileZone으로 dragenter 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('dragenter', (e) => {
			
			// e.preventdefault(): 웹브라우저의 고유 동작을 중단. 이미지 드랍 시 웹브라우저가 자동으로 이미지를 여는 것 중단.
			// e.stopPropagation(): 상위 엘리멘트들로의 이벤트 전파를 중단.
			e.stopPropagation();
			e.preventDefault();
			fileZone.style.border = '2px solid #0B85A1';
			
		});
		
		// fileZone으로 dragover 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('dragover', (e) => {
			
			e.stopPropagation();
			e.preventDefault();
			
		});
		
		// fileZone으로 drop 이벤트 발생 시 처리하는 이벤트 핸들러
		fileZone.addEventListener('drop', (e) => {
			
			e.stopPropagation();
			e.preventDefault();
			fileZone.style.border = '2px solid #adadad';
			// 본 이벤트는 <input type=file>로 파일을 선택해서 받는게 아니라
			// 드래그앤 드랍 같이 다른 이벤트 형식을 통해 file을 받는 형태
			// 이런 경우는 e.dataTransfer.files에 선택한 파일 + 파일 정보가 들어가 있음
			const files = e.dataTransfer.files;
			fileCheck(files);
			
		});
	}
	
	var uploadCountLimit = 5; // 업로드 가능한 파일 갯수
	var fileCount = 0; // 현재 선택된 파일 갯수
	var fileNum = 0; // 첨부 파일 개개의 고유 번호
	var content_files = []; // 첨부 파일을 저장할 배열 선언
	var rowCount = 0;
	
	const fileCheck = (files) => {
		
		let filesArr = Object.values(files); // 유사 배열 배열로 변환
		
		// 파일 갯수 확인 및 제한
		if(fileCount + filesArr.length > uploadCountLimit) {
			alert('파일은 최대 ' + uploadCountLimit + '개까지 첨부할 수 있습니다.');
		} else {
			fileCount = fileCount + filesArr.length;
		}
		
		filesArr.forEach((file) => {	// filesArr.forEach 시작
			
			/*
			FileReader 객체: 웹 어플리케이션이 비동기적으로 웹 브라우저에서 파일을 읽을 때 사용.
							<input type="file">태그를 이용해 사용자가 선택한 파일들의 결과로 반환된 FileList객체(자바스크립트 내장 객체)나
							드래그 앤드 드랍(Drag & Drop) 이벤트로 반환된 dataTransfer 객체로부터 데이터를 얻는다.
			*/
			var reader = new FileReader();
							
			// 파일 읽기
			reader.readAsDataURL(file);
			
			// reader.readAsDataURL(file) 실행으로 파일 읽기 성공적으로 수행되고 난 후
			// reader.onload 이벤트 핸들러를 통해 reader.onload 이벤트 핸들러 내 콜백함수 비동기적으로 실행.
			reader.onload = (e) => {
				
				content_files.push(file);
				
				// 1개의 파일 사이즈를 체크해서 1GB가 넘는 파일은 업로드 제한
				if(file.size > 1073741824) {
					alert("파일 사이즈는 1GB를 초과할 수 없습니다.");
					return;
				}
				
				rowCount ++;
				var row = "odd";
				if(rowCount %2 == 0) {
					row = "even";
				}
				
				// 동적으로 자바스크립트를 실행하는 과정에서 HTML 태그를 생성
				let statusbar = document.createElement('div');	//<div></div>
				statusbar.setAttribute('class', 'statusbar '+ row);//<div class='statusbar odd'></div>
				statusbar.setAttribute('id', 'file'+ fileNum); //<div class='statusbarodd' id='file0'></div>
				
				// statusbar내의 파일명
				let filename = "<div class='filename'>" + file.name + "</div>";
				
				// statusbar내의 파일 사이즈
				let sizeStr = "";
				let sizeKB = file.size/1024;
				let sizeMB;
				
				// 파일 사이즈에 따른 단위 변화
				if(parseInt(sizeKB) > 1024){
					sizeMB = sizeKB/1024;
					sizeStr = sizeMB.toFixed(2) + "MB";	// toFixed(2): 소수점 2자리까지 표시
				} else {
					sizeStr = sizeKB.toFixed(2) + "KB";
				}
				let size = "<div class='filesize'>" + sizeStr + "</div>";
				
				// statusbar 내의 삭제 버튼
				let btn_delete = "<div style='display:inline-block;width:15%;cursor:pointer;vertical-align:top'>"
							+ "<input type='button' value='삭제' onclick=fileDelete('file" + fileNum + "')></div>";
							
				// 파일명, 파일 사이즈, 삭제버튼 태그를 <div class='statusbar even' id='file0'></div>에 넣기
				statusbar.innerHTML = filename + size + btn_delete;
				
				/*
				<div class='statusbar even' id='file0'>...</div>를
				<div class='fileUploadList' id='fileUploadList'></div>의 하위 태그로 설정
				*/
				fileUploadList.appendChild(statusbar);
				
				fileNum ++; // 파일 고유 번호 증가
			};//reader.onload 종료
			
		});// filesArr.forEach 종료
		
		inputFile.value = '';	// <input type="file"> 태그의 초기화 => 읽어들인 파일은 이미 filesArr, content_files에 입력되었기 때문에 초기화
	}
	
	const fileDelete = (fileNum) => {
		
		var no = fileNum.replace(/[^0-9]/g,"");	// file0 => 'file'은 삭제 0만 남음
		content_files[no].is_delete = true; // 배열 요소의 값이 삭제 되었는지 판단.
		document.querySelector('#file' + no).remove();// id='file0'
		fileCount --;
	}
	
	const modifyForm = async () => {
		
		// 유효성 검사
		if(title.value == ''){
			alert('제목을 입력하세요.');
			title.focus();
			return false;
		}
		
		if(content.value == ''){
			alert('내용을 입력하세요.');
			content.focus();
			return false;
		}
		
		let formData = new FormData(ModifyForm);
		for(let i=0; i<content_files.length; i++){
			if(!content_files[i].is_delete)
				formData.append("sendToFileList", content_files[i]);
		}
		
		console.log(formData);
		
		await fetch('/board/write', {
			
			method: 'POST',
			body: formData
			
		}).then((response) => response.json()
		).then((data) => {
			
			if(data.message == 'good'){
				alert('게시물이 수정되었습니다.\n게시물 상세 보기 화면으로 이동합니다.');
				document.location='/board/view?seqno=${view.seqno}&page=${page}&keyword=${keyword}';
			}
			
		}).catch((error) => {
			alert('시스템 장애로 게시물 등록이 실패했습니다.');
			console.log((error)=> console.log('error=' + error));
		});
	}
</script>
</head>
<body>
<script>
	let userid = '${userid}';
	if(userid == ''){
		document.location = '/member/login';
	}
</script>

<div>
	<img class="topBanner" src="/resources/images/logo.jpg" title="서울기술교육센터">
</div>

<div class="main">
	<h1>게시물 수정</h1>
	<br>
	<div class="WriteForm">
		<form id="ModifyForm" method="POST">
			<input type="text" class="input_field" value="작성자: ${username}" disabled>
			<input type="hidden" name="writer" value="${view.writer}">
			<input type="hidden" name="userid" value="${view.userid}">
			<input type="hidden" name="seqno" value="${view.seqno}">
			<input type="hidden" name="page" value="${page}">
			<input type="hidden" name="keyword" value="${keyword}">
			<input type="hidden" name="kind" value="U">
			<input type="text" name="title" class="input_field" id="title" value="${view.title}" placeholder="여기에 제목을 입력하세요.">
			<textarea class="content" id="content" rows="500" cols="100" name="content" placeholder="여기에 내용을 입력하세요">${view.content}</textarea>
			<c:if test="${not empty fileListView}">
				<div id="fileList">
					<p style="text-align:left;">
						<c:forEach items="${fileListView}" var="file">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;삭제 : <input type="checkbox" name="deleteFileList" value="${file.fileseqno}">
							${file.org_filename}&nbsp;(${file.filesize} Byte)<br>
						</c:forEach>
					</p>
				</div>
			</c:if>
			<div class="fileUploadForm">
				<input type="file" id="inputFile" name="uploadFile" style="display:none;" multiple>
				<div class="fileZone" id="fileZone">파일 첨부를 하기 위해서는 클릭하거나 여기로 파일을 드래그 하세요.<br>첨부파일은 최대 5개까지 등록이 가능합니다.</div>
				<div class="fileUploadList" id="fileUploadList"></div>
			</div>
			<input type="button" class="btn_write" value="수정" onclick="modifyForm()">
			<input type="button" class="btn_cancel" value="취소" onclick="history.back()">
		</form>
	</div>
</div>
</body>
</html>