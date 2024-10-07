<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>30일 이후 패스워드 변경</title>
<link rel="stylesheet" type="text/css" href="/resources/CSS/board.css">
</head>
<body>
<div>
	<img src="/resources/images/logo.jpg" class="topBanner">
</div>

<div class="main">
	<div class="ModifyForm">
		<h1>30일 이후 패스워드 변경</h1>
		<form name="modifyForm" id="modifyForm" method="POST">
			<input type="password" id="old_password" name="old_password"
					class="input_field" placeholder="기존 패스워드를 입력 하세요.">
			<p id="msg" style="color:red;text-align:center;"></p>
			<input type="password" id="new_password" name="new_password"
					class="input_field" placeholder="새로운 패스워드를 입력 하세요.">
			<p style="color:red;text-align:center;">※ 8~20자 이내의 영문자, 숫자, 특수문자 조합으로 패스워드를 만들어 주세요.</p>
			<input type="password" id="new_password1" name="new_password1"
					class="input_field" placeholder="새로운 패스워드를 한번 더 입력 하세요.">
			<input type="button" class="btn_write" value="패스워드 변경" onclick="modifyMemberPassword()">
			<input type="button" class="btn_cancel" value="다음에 변경하기" onclick="nextTime()">
		</form>
	</div>
</div>
<script>
const nextTime = () => {
	
	const today = new Date();
	const addedDate = new Date();
	addedDate.setDate(today.getDate() + ${addedDate});
	
	alert(addedDate.getFullYear() + "년 " + addedDate.getMonth()
			+ "월 " + addedDate.getDate() + "일 이후에 재공지 됩니다.");
	
	document.location="/member/nextTime";
}

const modifyMemberPassword = async () => {
	if(old_password.value == '') {
		alert('기존 패스워드를 입력 하세요.');
		old_password.focus();
		return false;
	}
	
	const Pass = new_password.value;
	const Pass1 = new_password1.value;

	if(Pass == ''){
		alert('신규 패스워드를 입력하세요.');
		new_password.focus();
		return false;
	}

	if(Pass1 == ''){
		alert('신규 패스워드 확인을 입력하세요.');
		new_password1.focus();
		return false;
	}

	if(Pass != Pass1){
		alert('암호가 일치하지 않습니다.');
		new_password1.focus();
		return false;
	}

	// 암호 유효성 검사
	// 자바스크립트 정규식(Regular Expression)
	let num = Pass.search(/[0-9]/g); // 0-9까지의 숫자가 들어있는지 검색. 검색 결과가 없으면 -1을 리턴
	let eng = Pass.search(/[a-z]/ig); // i: 알파벳 대소문자 구분없이.
	let spe = Pass.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);	// 특수문자 포함 여부 검색

	if(Pass.length < 8 || Pass.length > 20){
		alert('암호는 8자리 이상 20자리 이하로 입력해 주세요.');
		password.focus();
		return false;
	} else if(Pass.search(/\s/) != -1) {
		alert('암호는 공백 없이 입력해 주세요.');
		password.focus();
		return false;
	} else if(num < 0 || eng < 0 || spe < 0){
		alert('암호는 영문, 숫자, 특수문자를 혼합하여 입력해 주세요.');
		password.focus();
		return false;
	}
	
	let formData = new FormData();
	formData.append("old_password", old_password.value);
	formData.append("new_password", new_password.value);
	
	await fetch('/member/modifyMemberPassword', {
		method: 'POST',
		body: formData,
	}).then((response) => response.json()
	).then((data) => {
		if(data.message == 'good'){
			alert('패스워드가 변경되었습니다.');
			logout();
		} else if(data.message == 'PASSWORD_NOT_FOUND'){
			msg.innerHTML = '기존 암호가 일치하지 않습니다.'
		} else {
			alert('시스템 장애로 패스워드 변경이 실패했습니다.');
		}
	}).catch((error) => {
		console.log("error=" + error);
	});
}

const logout = () => {
	let authkey = getCookie('authkey');
	let userid = getCookie('userid');
	let password = getCookie('password');
	console.log(authkey);
	console.log(userid);
	console.log(password);
	
	// 쿠키 삭제
	if(authkey !== undefined){
		document.cookie = "authekey=" + authkey + ';path=/;max-age=0';	
	}
	if(userid !== undefined){
		document.cookie = "userid=" + userid + ';path=/;max-age=0';	
	}
	if(password !== undefined){
		document.cookie = "password=" + password + ';path=/;max-age=0';	
	}
	document.location = '/member/login';
}
</script>
</body>
</html>