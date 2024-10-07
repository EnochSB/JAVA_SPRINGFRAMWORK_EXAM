<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>테스트용 게시물 생성</title>
<script>
const sender = async () => {
	
	let result = document.querySelector("#result");
	await fetch('/board/boardmaker', {
		method: 'POST',
		body: ''
	}).then((response) => response.json()
	).then((data) => {
		if(data.message == 'good'){
			result.innerHTML = data.counter + '개의 게시물이 생성되었습니다...';
		}
	}).catch((error) => {
		console.log("error=" + error);
	});
}
</script>
</head>
<body>
<h1>샘플 게시물 생성</h1><input type="button" value="게시물 생성" onclick="sender()">
<br><br>
<h1><span id="result"></span></h1>
</body>
</html>