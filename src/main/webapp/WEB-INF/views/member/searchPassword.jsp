<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>임시 패스워드 발급</title>
<link rel="stylesheet" type="text/css" href="/resources/CSS/board.css">
<script>
const searchPassword = async () => {
	if(userid.value == '') {
		alert('아이디를 입력 하세요.');
		userid.focus();
		return false;
	}
	
	if(telno.value == '') {
		alert('전화번호를 입력 하세요.');
		telno.focus();
		return false;
	}

	let formData = new FormData();
	formData.append("userid", userid.value);
	formData.append("telno", telno.value);
	
	await fetch("/member/searchPassword", {
		method: 'POST',
		body: formData
	}).then((response) => response.json()
	).then((data) => {
		if(data.message == 'good'){
			alert('임시 비밀번호:'+ data.tempPW);
		} else if(data.message == 'ID_NOT_FOUND'){
			alert('해당 아이디를 가진 사용자가 존재하지 않습니다.');
		} else if(data.message == 'TELNO_NOT_FOUND'){
			alert('해당 전화번호를 가진 사용자가 존재하지 않습니다.');
		} else {
			alert('시스템 장애로 임시 패스워드 발급이 실패했습니다.');
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
		<h1>임시 패스워드 발급</h1>
		<form name="modifyForm" id="modifyForm" method="POST">
			<input type="text" id="userid" name="userid"
					class="input_field" placeholder="여기에 아이디를 입력해 주세요.">
			<p id="msg" style="color:red;text-align:center;"></p>
			<input type="text" id="telno" name="telno"
					class="input_field" placeholder="여기에 전화번호를 입력해 주세요.">
			<p id="msg1" style="color:red;text-align:center;"></p>
			<input type="button" class="btn_write" value="임시 패스워드 발급" onclick="searchPassword()">
			<input type="button" class="btn_cancel" value="취소" onclick="history.back()">
		</form>
	</div>
</div>
</body>
</html>