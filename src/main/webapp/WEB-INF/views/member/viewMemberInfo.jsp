<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보</title>
<link rel="stylesheet" href="/resources/CSS/board.css">
<style>
.imgView {
	border: 2px solid #92AAB0;
	width:70%;
	height: auto;
	vertical-align: middle;
	margin: auto;
	padding: 10px;
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
	<img class="topBanner" src="/resources/images/logo.jpg" title="서울기술교육센터">
</div>

<div class="main">
	<h1>회원 정보 보기</h1>
	<br>
	<div class="boardView">
		<div class="imgView">
			<img class="imgView" src="/profile/${member.stored_filename}" style="display:block;width:80%;">
			<div class="field">아이디: ${member.userid}</div>
			<div class="field">이름: ${member.username}</div>
			<div class="field">성별: ${member.gender}</div>
			<div class="field">직업: ${member.job}</div>
			<div class="field">취미: ${member.hobby}</div>
			<div class="field">전화번호: ${member.telno}</div>
			<div class="field">이메일: ${member.email}</div>
			<div class="field">회원가입일: <fmt:formatDate value="${member.regdate}" pattern="yyyy-MM-dd a hh:mm:ss"/></div>
			<div class="field">마지막 로그인일: <fmt:formatDate value="${member.lastlogindate}" pattern="yyyy-MM-dd a hh:mm:ss"/></div>
			<div class="field">마지막 로그아웃일: <fmt:formatDate value="${member.lastlogoutdate}" pattern="yyyy-MM-dd a hh:mm:ss"/></div>
			<div class="field">마지막 패스워드 변경일: <fmt:formatDate value="${member.lastpwdate}" pattern="yyyy-MM-dd a hh:mm:ss"/></div>
			<div class="content"><pre>${member.description}</pre></div>
		</div>
		<br>
		<div class="bottom_menu" align="center">
			&nbsp;&nbsp;
			<a href="/board/list?page=1">처음으로</a>&nbsp;&nbsp;
			<a href="/member/modifyMemberInfo">기본정보 변경</a>&nbsp;&nbsp;
			<a href="/member/modifyMemberPassword">패스워드 변경</a>&nbsp;&nbsp;
			<a href="#">회원 탈퇴</a>&nbsp;&nbsp;
		</div>
			<br><br>
	</div>
</div>
</body>
</html>