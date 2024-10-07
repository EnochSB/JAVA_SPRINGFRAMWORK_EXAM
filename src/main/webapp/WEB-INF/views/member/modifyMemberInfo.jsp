<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<link rel="stylesheet" href="/resources/CSS/board.css">
<style>
.imageZone {
	border: 2px solid #92AAB0;
	width: 80%;
	height: auto;
	color: #92AAB0;
	text-align: center;
	vertical-align: middle;
	margin: auto;
	padding: 10px 10px;
	font-size: 200%;
}
.addrSearch {
	width: 80%;
	border: none;
	border-bottom: 2px solid #adadad;
	margin: 5px;
	padding: 10px 10px;
	outline: none;
	color: #636e72;
	font-size: 16px;
	height: 25px;
	background: none;
}
</style>
<script>
	let userid = '${userid}';
	if(userid == ''){
		document.location = '/member/login';
	}
</script>
</head>
<body>
<div>
	<img src="/resources/images/logo.jpg" class="topBanner">
</div>
<div class="main">
	<h1>회원 정보 수정</h1><br>
	<div class="WriteForm">
		<form name="RegistryForm" id="RegistryForm" method="POST">
		<br><br>
			<input type="file" name="fileUpload" id="imageFile" style="display:none">
			<span>이미지 수정을 원하시면 화면을 클릭해 주세요</span>
			<div class="imageZone" id="imageZone"><img id='uploadImg' src="/profile/${member.stored_filename}" style='width:90%; height:auto;'></div>
			<input type="text" class="input_field" id="userid" name="userid" value="${member.userid}" readonly><br>
			<input type="text" class="input_field" id="username" name="username" value="${member.username}" readonly><br>
			<div style="width:90%; text-align:left; position:relative; left:35px;
				border-bottom:2px solid #adadad; margint:5px; padding: 5px;">
				성별 :
				<label><input type="radio" name="gender" value="남성" ${member.gender eq '남성'?"checked":""}>남성</label>
				<label><input type="radio" name="gender" value="여성" ${member.gender eq '여성'?"checked":""}>여성</label><br>
				취미 :
				<label><input type="checkbox" id="all" name="all" onclick="selectAll(this)">전체 선택</label>
				<label><input type="checkbox" name="hobby" value="음악감상" <c:if test="${fn:contains(member.hobby, '음악감상')}">checked</c:if>>음악감상</label>
				<label><input type="checkbox" name="hobby" value="영화감상" <c:if test="${fn:contains(member.hobby, '영화감상')}">checked</c:if>>영화감상</label>
				<label><input type="checkbox" name="hobby" value="스포츠" <c:if test="${fn:contains(member.hobby, '스포츠')}">checked</c:if>>스포츠</label><br>
				직업 :
				<select name="job">
					<option value="00" disabled selected>-- 아래의 내용 중에서 선택 --</option>
					<option value="회사원" ${member.job eq '회사원'?"checked selected":""}>회사원</option>
					<option value="공무원" ${member.job eq '공무원'?"checked selected":""}>공무원</option>
					<option value="자영업" ${member.job eq '자영업'?"checked selected":""}>자영업</option>
					<option value="학생" ${member.job eq '학생'?"checked selected":""}>학생</option>
					<option value="무직" ${member.job eq '무직'?"checked selected":""}>무직</option>
				</select>
				<br>
			</div>
			<input type="text" id="addrSearch" name="addrSearch" class="addrSearch" placeholder="주소를 검색합니다.">
			<input type="button" id="btn_addrSearch" class="btn_addrSearch" value="주소검색" onclick="searchAddr()">
			<input type="text" id="zipcode" name="zipcode" class="input_field" value="${member.zipcode}" readonly>
			<input type="text" id="addr1" name="addr1" class="input_field" value="${member.address}" readonly>
			<input type="text" id="addr2" name="addr2" class="input_field" placeholder="상세주소를 입력하세요.">
			<input type="hidden" id="address" name="address">
			<input type="text" id="telno" name="telno" class="input_field" value="${member.telno}">
			<input type="text" id="email" name="email" class="input_field" value="${member.email}">
			<input type="hidden" name="org_filename" value="${member.org_filename}">
			<input type="hidden" name="stored_filename" value="${member.stored_filename}">
			<input type="hidden" name="filesize" value="${member.filesize}">
			<br>
			<textarea class="input_content" id="description" name="description" cols="100" rows="500">${member.description}</textarea><br>
			<input type="button" id="btnModify" class="btn_modify" value="수정">
			<input type="button" id="btnCancel" class="btn_cancel" value="취소" onclick="history.back()">
			<input type="hidden" name="kind" value="U">
			<br><br>
		</form>
	</div>
</div>
<br><br>
<script>
window.onload = () => {
	
	//var imgCheck = "N";
	var imgZone = document.querySelector('#imageZone');
	var fileEvent = document.querySelector('#imageFile');
	var btnRegister = document.querySelector('#btnRegister');
	
	// imgZone 영역 클릭 시 fileEvent 처리.
	imgZone.addEventListener('click', (e)=> {
		fileEvent.click(e);	// 사용자가 만든 UI를 통해 <input type="file">을 클릭하는 것과같은 효과
	});
	
	fileEvent.addEventListener('change', (e)=> {	// 파일을 선택해서 파일을 가져오기
		const files = e.target.files;	// 선택한 파일 정보가 e.target.files(배열)에 저장
		showImage(files);	// 읽어 온 파일을 인자로 받아서 이미지 미리보기를 실행
	});
	
	const showImage = (files) => {
		imgZone.innerHTML = '';
		const imgFile = files[0];
		//if(imgFile.size > 1024*1024){alert("1MB 이하 파일만 올려 주세요"); return false;}
		if(imgFile.type.indexOf("image") < 0){
			alert("이미지 파일만 올려 주세요");
			imgZone.innerHTML = '클릭 후 탐색창에서 사진을 <br>선택해 주세요.';
			return false;
		}
		
		const reader = new FileReader();
		reader.onload = function(event){	// 파일을 읽고 나서 할 일을 기술
			imgZone.innerHTML = "<img src=" + event.target.result + " id='uploadImg' style='width:90%; height:auto;'>";
		};
		
		reader.readAsDataURL(imgFile); // 실제로 파일을 읽는 부분
		console.log(event.target.result);
		// imgCheck = "Y";
	};
	
	btnModify.addEventListener('click', async () => {
		// 유효성 검사
		/*
		if(imgCheck == 'N'){
			alert('프로필 이미지를 등록하세요.');
			return false;
		}
		*/
		
		const gender = document.querySelectorAll('input[name=gender]:checked');
		const hobby = document.querySelectorAll('input[name=hobby]:checked');
		const job = document.querySelector('select[name=job] option:checked');
		
		if(gender.length == 0){
			alert('성별을 선택해 주세요.');
			document.querySelector('input[name=gender]').focus();
			return false;
		}
		
		if(hobby.length == 0){
			alert('취미를 선택해 주세요.');
			document.querySelector('input[name=hobby]').focus();
			return false;
		}
		
		if(job.value == '00'){
			alert('직업을 선택해 주세요.');
			document.querySelector('select[name=job]').focus();
			return false;
		}
		
		if(zipcode.value == ''){
			alert('우편번호를 입력하세요.');
			zipcode.focus();
			return false;
		}
		/*
		if(addr2.value == ''){
			alert('상세주소를 입력하세요.');
			addr2.focus();
			return false;
		}
		*/
		
		address.value = addr1.value + " " + addr2.value;
		
		if(telno.value == '') {
			alert('전화번호를 입력하세요.');
			telno.focus();
			return false;
		}
		
		const beforeTelno = telno.value;
		const afterTelno = beforeTelno.replace(/\-/ig,"").replace(/\ /ig,"").trim();
		telno.value = afterTelno;
		
		if(email.value == ''){
			alert('이메일을 입력하세요.');
			email.focus();
			return false;
		}
		
		if(description.value == ''){
			alert('자기소개를 입력하세요.');
			description.focus();
			return false;
		}
		
		// 비동기 방식으로 Form 데이터를 서버로 전송해서(요청해서) 처리한 후 그 결과를 다시 응답 받아 어떤 행위를 실행
		
		let formData = new FormData(RegistryForm);
		
		await fetch('/member/signup', {
			method: 'POST',
			body: formData,
		}).then((response) => response.json())
		  .then((data) => {
			  if(data.status == 'good'){
				  alert("회원 정보가 수정되었습니다.");
				  document.location.href = '/member/viewMemberInfo';
			  } else {
				  alert('서버 장애로 회원 정보 수정에 실패 했습니다.');
			  }
		  });
	});
}


// 전체 선택 했을 때 체크된 항목 중 하나 이상을 체크 해체하면 전체 선택 체크도 해제시키기 적용 필요(과제)
const selectAll = (checkElement) => {
	const checkboxes = document.getElementsByName('hobby');	// 전체 체크박스를 유사 배열로 입력 받음
	checkboxes.forEach((checkbox) => {
		// 전체선택 체크 박스를 클릭 시 모든 체크박스가 전체선택과 동기화
		checkbox.checked = checkElement.checked;
	})
}

const searchAddr = () => {
	// 무결성 체크
	if(addrSearch.value == ''){
		alert('검색할 주소를 입력하세요.');
		addrSearch.focus();
		return false;
	}
	
	window.open(
			"/member/searchAddress?page=1&addrSearch=" + addrSearch.value,
			"주소검색",
			"width=900, height=540, top=50, left=50");
}
</script>
</body>
</html>