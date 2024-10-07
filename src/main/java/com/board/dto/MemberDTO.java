package com.board.dto;

import java.time.LocalDateTime;// spring framework에서는 인식이 안됨. 인식 시키려면 복잡한 과정을 거쳐야한다.
import java.util.Date;

public class MemberDTO {
	private String userid;
	private String username;
	private String password;
	private String telno;
	private String email;
	private String gender;
	private String hobby;
    private String job;
    private String description;
    private String zipcode;
    private String address;
    private Date regdate;			// 회원 가입일
    private Date lastlogindate;	// 마지막 로그인 날짜
    private Date lastlogoutdate;	// 마지막 로그아웃 날짜
    private Date lastpwdate;		// 마지막 패스워드 변경일
	private int pwcheck;					// 30일 이후 패스워드 여부 확인
	private String role;					// 회원등급: MASTER=관리자, USER=일반 회원
	private String org_filename;			// 회원가입시 등록한 회원 프로필 이미지 원래 파일명
	private String stored_filename;			// 회원가입시 등록한 회원 프로필 이미지 저장 파일
	private Long filesize;					// 회원가입시 등록한 회원 프로필 이미지 파일 크기
	private String authkey;					// 인증용 토큰
	
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getTelno() {
		return telno;
	}
	public void setTelno(String telno) {
		this.telno = telno;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getHobby() {
		return hobby;
	}
	public void setHobby(String hobby) {
		this.hobby = hobby;
	}
	public String getJob() {
		return job;
	}
	public void setJob(String job) {
		this.job = job;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public Date getLastlogindate() {
		return lastlogindate;
	}
	public void setLastlogindate(Date lastlogindate) {
		this.lastlogindate = lastlogindate;
	}
	public Date getLastlogoutdate() {
		return lastlogoutdate;
	}
	public void setLastlogoutdate(Date lastlogoutdate) {
		this.lastlogoutdate = lastlogoutdate;
	}
	public Date getLastpwdate() {
		return lastpwdate;
	}
	public void setLastpwdate(Date lastpwdate) {
		this.lastpwdate = lastpwdate;
	}
	public int getPwcheck() {
		return pwcheck;
	}
	public void setPwcheck(int pwcheck) {
		this.pwcheck = pwcheck;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getOrg_filename() {
		return org_filename;
	}
	public void setOrg_filename(String org_filename) {
		this.org_filename = org_filename;
	}
	public String getStored_filename() {
		return stored_filename;
	}
	public void setStored_filename(String stored_filename) {
		this.stored_filename = stored_filename;
	}
	public Long getFilesize() {
		return filesize;
	}
	public void setFilesize(Long filesize) {
		this.filesize = filesize;
	}
	public String getAuthkey() {
		return authkey;
	}
	public void setAuthkey(String authkey) {
		this.authkey = authkey;
	}
}
