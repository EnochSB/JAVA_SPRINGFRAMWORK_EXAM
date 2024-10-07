<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<link rel="stylesheet" type="text/css" href="/resources/CSS/board.css">
<script>
const searchID = async () => {
	if(username.value == '') {
		alert('이름을 입력 하세요.');
		username.focus();
		return false;
	}
	
	if(telno.value == '') {
		alert('전화번호를 입력 하세요.');
		telno.focus();
		return false;
	}

	let formData = new FormData();
	formData.append("username", username.value);
	formData.append("telno", telno.value);
	
	await fetch("/member/searchID", {
		method: 'POST',
		body: formData
	}).then((response) => response.json()
	).then((data) => {
		console.log(data);
		if(data.message == 'good'){
			alert('아이디:'+ data.userid);
		} else if(data.message == 'USERNAME_NOT_FOUND'){
			alert('해당 이름을 가진 사용자가 존재하지 않습니다.');
		} else if(data.message == 'TELNO_NOT_FOUND'){
			alert('해당 전화번호를 가진 사용자가 존재하지 않습니다.');
		} else {
			alert('시스템 장애로 아이디 조회를 실패했습니다.');
		}
	}).catch((error) => {
		console.log('error=' + error);
	});
}
</script>
</head>
<body>
<div>
	<img src="/resources/images/logo.jpg" class="topBanner">
</div>

<div class="main">
	<div class="ModifyForm">
		<h1>아이디 찾기</h1>
		<form name="modifyForm" id="modifyForm" method="POST">
			<input type="text" id="username" name="username"
					class="input_field" placeholder="여기에 이름을 입력해 주세요.">
			<p id="msg" style="color:red;text-align:center;"></p>
			<input type="text" id="telno" name="telno"
					class="input_field" placeholder="여기에 전화번호를 입력해 주세요.">
			<p id="msg1" style="color:red;text-align:center;"></p>
			<input type="button" class="btn_write" value="아이디 찾기" onclick="searchID()">
			<input type="button" class="btn_cancel" value="취소" onclick="history.back()">
		</form>
	</div>
</div>
</body>
</html>