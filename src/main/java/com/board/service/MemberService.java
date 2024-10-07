package com.board.service;

import java.util.List;

import com.board.dto.AddressDTO;
import com.board.dto.MemberDTO;

public interface MemberService {
	
	// 회원 등록
	public void signup(MemberDTO member);
	
	// 회원 정보 수정
	public void modifyMemberInfo(MemberDTO member);
	
	// 패스워드 변경
	public void modifyMemberPassword(MemberDTO member);
	
	// 30일 이후 패스워드 변경 연기
	public void nextTime(String userid);
	
	// 아이디 찾기
	public String searchID(MemberDTO member);
	
	// 비밀번호 찾기(임시 비밀번호 발급)
	public MemberDTO searchPassword(MemberDTO member);
	
	// 이름 중복체크(아이디/비밀번호 찾기에 사용)
	public int usernameCheck(String username);
	
	// 전화번호 중복체크(아이디/비밀번호 찾기에 사용)
	public int telnoCheck(String telno);
	
	// 아이디 중복 체크
	public int idCheck(String userid);
	
	// 주소행 최대 갯수 계산
	public int addrTotalCount(String addrSearch);
	
	// 주소 검색
	public List<AddressDTO> addrSearch(int startPoint, int postNum, String addrSearch);
	
	// 회원 정보
	public MemberDTO memberInfo(String userid);
	
	// authkey 등록(update)
	public void authkeyUpdate(MemberDTO member);
	
	// authkey로 회원 정보 가져오기
	public MemberDTO memberInfoByAuthkey(String authkey);
	
	// 회원 로그인, 로그아웃, 패스워드변경시간 등록(update)
	public void lastdateUpdate(String userid, String status);
	
	// 회원 로그 정보 등록
	public void memberLogRegistry(String userid, String status);
}
