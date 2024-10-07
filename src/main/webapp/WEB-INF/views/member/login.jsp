<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
body {font-family: "나눔고딕", "맑은고딕"}
h1 {font-family: "HY견고딕"}
a:link {color: black}
a:visited {color: black}
a:hover {color: blue}
a:active {color: red}
.topBanner {
	margin-top: 10px;
	margin-bottom: 10px;
	max-width: 500px;
	height: auto;
	display: block;
	margin: 0 auto;
}
.login {
	width: 900px;
	height: auto;
	padding: 20px, 20px;
	background-color: #FFFFFF;
	text-align: center;
	border: 5px solid gray;
	border-radius: 30px;
}
.userid, .password {
	width: 80%;
	border: none;
	border-bottom: 2px solid #adadad;
	outline: none;
	color: #636e72;
	font-size: 16px;
	height: 25px;
	background: none;
	margin-top: 20px;
}
.bottomText {
	text-align:center;
	font-size: 20px;
}
.btn_login {
	position: relative;
	left: 40%;
	transform: translateX(-50%);
	margin-bottom:40px;
	width: 80%;
	height: 40px;
	background: linear-gradient(125deg, #81ecec, #6c5ce7, #81ecec);
	background-position: left;
	background-size: 200%;
	color: white;
	font-weight: bold;
	border: none;
	cursor: pointer;
	transition: 0.4s;
	display: inline;
}
</style>
</head>
<body>
<div class="main" align="center">
	<div>
		<img class="topBanner" src="/resources/images/logo.jpg" title="서울기술교육센터">
	</div>
	
	<div class="login">
		<h1>로그인</h1>
		<form name="loginForm" id="loginForm" class="loginForm" method="POST">
			<input type="text" name="userid" id="userid" class="userid" placeholder="아이디를 입력하세요.">
			<input type="password" name="password" id="password" class="password"
					onkeydown="press()" placeholder="암호를 입력하세요.">
			<p id="msg" style="color:red;text-align:center;"></p>
			<br>
			<input type="checkbox" id="rememberUserid" onclick="checkRememberUserid()">아이디 기억
			<input type="checkbox" id="rememberPassword" onclick="checkRememberPassword()">패스워드 기억
			<input type="checkbox" id="rememberMe" onclick="checkRememberMe()">자동 로그인
			<br><br>
			<input type="button" id="btn_login" class="btn_login" value="로그인" onclick="loginCheck()">
		</form>
	</div>
	<div class="bottomText">
		사용자가 아니면 ▶<a href="/member/signup">여기</a>를 눌러 등록을 해주세요.
		<br><br>
		[<a href="/member/searchID" onmouseover="this.style.background='pink';this.style.textDecoration='underline';"
					onmouseout="this.style.background='white';this.style.textDecoration='none';">아이디</a> |
		<a href="/member/searchPassword" onmouseover="this.style.background='pink';this.style.textDecoration='underline';"
					onmouseout="this.style.background='white';this.style.textDecoration='none';">패스워드 찾기</a>
		]<br><br>
	</div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.2/rollups/aes.js"></script>
<script>

window.onload = async () => {
	// 웹브라우저에서 쿠키 가져오기
	const getCookie = (name) => {
		// authkey=임의의키;path=/;expires=요일, 일 월 년 시:분:초 GMT'
		// userid=유저아이디;path=/;expires=요일, 일 월 년 시:분:초 GMT'
		// password=비밀번호;path=/;expires=요일, 일 월 년 시:분:초 GMT'
		const cookies = document.cookie.split(`; `).map((el) => el.split('='));
		// cookies[][] = { ['authekey', 임의의키], ['expires', 시간] }
		let getItem = [];	// es6+에서 사용 가능한 배열 만들기
		
		// name: 찾고자 하는 쿠키 이름
		for(let i=0; i<cookies.length; i++){
			if(cookies[i][0] === name) {
				getItem.push(cookies[i][1]); // 찾은 쿠키를 getItem에 그 값을 추가
				break;
			}
		}
		if(getItem.length > 0) { // 찾고자 하는 쿠키가 있다.
			return decodeURIComponent(getItem[0]); // 쿠키 값을 리턴
		}
	}	
	
	// 만약 쿠키가 없다면 해당 변수에는 undefined라는 값만 존재
	let userid = getCookie('userid'); // userid라는 이름의 쿠키가 있으면 userid변수에 넣기
	let password = getCookie('password');
	let authkey = getCookie('authkey');
	
	if(userid !== undefined) {
		// 아이디 기억 체크박스 체크
		document.querySelector('#rememberUserid').checked = true;
		// 아이디 입력 칸에 쿠키로 가져온 아이디 입력
		document.querySelector('#userid').value = userid;
	} else {
		document.querySelector('#rememberUserid').checked = false;
	}
	
	if(password !== undefined) {
		// 패스워드 기억 체크박스 체크
		document.querySelector('#rememberPassword').checked = true;
		// Base64로 인코딩(암호화)된 password를 디코딩(복호화)
		const descrypt = CryptoJS.enc.Base64.parse(password);
		const hashData = descrypt.toString(CryptoJS.enc.Utf8);
		password = hashData;
		// 패스워드 입력 칸에 디코딩한 패스워드 입력
		document.querySelector('#password').value = password;
	} else {
		document.querySelector('#rememberPassword').checked = false;
	}
	
	// authkey 쿠키가 있으면 자동로그인
	if(authkey !== undefined) {
		let formData = new FormData();
		formData.append('authkey', authkey);
		await fetch('/member/login?autoLogin=PASS', {
			
			method: 'POST',
			body: formData
			
		}).then((response) => 
			response.json()
		).then((data) => {
			if(data.message == 'good'){
				document.location = '/board/list?page=1';
			} else if(data.message == 'expired'){
				document.location = '/member/checkPasswordNotice';
			} else {
				alert('시스템 장애로 자동 로그인이 실패했습니다.');
			}
		}).catch((error) => {
			console.log("error = " + error);
		});
	}
}

// 아이디 체크 관리
const checkRememberUserid = () => {
	if(document.querySelector('#rememberUserid').checked){
		document.querySelector('#rememberMe').checked = false;
	}
}

// 패스워드 체크 관리
const checkRememberPassword = () => {
	if(document.querySelector('#rememberPassword').checked){
		document.querySelector('#rememberMe').checked = false;
	}
}

// 자동로그인 체크 관리
const checkRememberMe = () => {
	if(document.querySelector('#rememberMe').checked){
		document.querySelector('#rememberUserid').checked = false;
		document.querySelector('#rememberPassword').checked = false;
	}
}

// 로그인 처리
const loginCheck = async () => {
	
	let userid = document.querySelector('#userid');
	let password = document.querySelector('#password');
	let rememberMe = document.querySelector('#rememberMe');
	
	// 유효성 검사
	if(userid.value == ''){
		alert('아이디를 입력하세요');
		userid.focus();
		return false;
	}
	if(password.value== ''){
		alert('비밀번호를 입력하세요');
		password.focus();
		return false;
	}
	
	// let formData = new FormData(loginForm);
	// 이렇게하는 방법도 있지만 요즘은 form자체를 안만들고 아래와 같이 하는 것을 선호
	let formData = new FormData();
	formData.append("userid", userid.value);
	formData.append("password", password.value);
	
	await fetch('/member/login?autoLogin=NEW', {	// NEW: authkey 쿠키가 없다
		
		method: 'POST',
		body: formData,
		
	}).then((response) => 
		response.json()
	).then((data) => {
		if(data.message == 'good'){
			cookieManage(userid.value, password.value, data.authkey);
			document.location = '/board/list?page=1';
		} else if(data.message == 'ID_NOT_FOUND') {
			msg.innerHTML = '존재하지 않는 아이디입니다.';
		} else if(data.message == 'PASSWORD_NOT_FOUND') {
			msg.innerHTML = '비밀번호가 일치하지 않습니다.';
		} else if(data.message == 'expired'){
			document.location = '/member/checkPasswordNotice'
		} else {
			alert("시스템 장애로 로그인이 실패했습니다.");
		}
		
	}).catch((error) => {
		console.log("error=" + error);
	});
	
}

// 쿠키 관리
const cookieManage = (userid, password, authkey) => {
	
	// 자동로그인 시 쿠키 관리
	if(rememberMe.checked){
		// 쿠키 생성: authkey=임의의키;path=/;expires=요일, 일 월 년 시:분:초 GMT'
		// path=/ : 루트 디렉토리 아래의 모든 경로에 쿠키 적용. path=/board/ 같은 방식으로 제한도 가능
		document.cookie = 'authkey=' + authkey + ';path=/;expires=Wed, 31 Dec 2025 23:59:59 GMT';
	} else {
		// 쿠키 삭제: authkey=임의의키;path=/;max-age=0 혹은 expires=지난날
		document.cookie = 'authkey=' + authkey + ';path=/;max-age=0';
	}
	
	// 아이디 체크시 쿠키 관리
	if(rememberUserid.checked){
		document.cookie = 'userid=' + userid + ';path=/;expires=Wed, 31 Dec 2025 23:59:59 GMT';
	} else {
		document.cookie = 'userid=' + userid + ';path=/;max-age=0';
	}
	
	// 비밀번호 체크시 쿠키 관리
	if(rememberPassword.checked){
		
		// Base64(양방향 복호화)로 패스워드 인코딩
		const key = CryptoJS.enc.Utf8.parse(password);		// 1차 암호화
		const base64 = CryptoJS.enc.Base64.stringify(key);	// 2차 암호화
		password = base64;
		document.cookie = 'password=' + password + ';path=/;expires=Wed, 31 Dec 2025 23:59:59 GMT';
	} else {
		document.cookie = 'password=' + password + ';path=/;max-age=0';
	}
}

// 엔터로 로그인
const press = () => {
	if(event.keyCode == 13){
		loginCheck();	
	}
}
</script>
</body>
</html>