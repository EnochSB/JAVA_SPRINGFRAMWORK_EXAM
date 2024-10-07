package com.board.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.MemberDAO;
import com.board.dto.AddressDTO;
import com.board.dto.MemberDTO;

@Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	MemberDAO dao;
	
	// 아이디 중복 체크
	@Override
	public int idCheck(String userid) {
		
		return dao.idCheck(userid);
	}
	
	// 주소 전체 행 갯수
	@Override
	public int addrTotalCount(String addrSearch) {
		
		return dao.addrTotalCount(addrSearch);
	}
	
	// 주소 검색
	@Override
	public List<AddressDTO> addrSearch(int startPoint, int postNum, String addrSearch) {
		
		return dao.addrSearch(startPoint, postNum, addrSearch);
	}
	
	// 회원 등록
	@Override
	public void signup(MemberDTO member) {
		dao.signup(member);
	}
	
	// 회원 정보 수정
	@Override
	public void modifyMemberInfo(MemberDTO member) {
		dao.modifyMemberInfo(member);
	}
	
	// 패스워드 변경
	@Override
	public void modifyMemberPassword(MemberDTO member) {
		dao.modifyMemberPassword(member);
	};
	
	// 30일 이후 패스워드 변경 연기
	@Override
	public void nextTime(String userid) {
		dao.nextTime(userid);
	};
	
	// 아이디 찾기
	@Override
	public String searchID(MemberDTO member) {
		return dao.searchID(member);
	};
	
	// 비밀번호 찾기(임시 비밀번호 발급)
	@Override
	public MemberDTO searchPassword(MemberDTO member) {
		return dao.searchPassword(member);
	};
	
	// 이름 중복체크(아이디/비밀번호 찾기에 사용)
	@Override
	public int usernameCheck(String username) {
		return dao.usernameCheck(username);
	};
	
	// 전화번호 중복체크(아이디/비밀번호 찾기에 사용)
	@Override
	public int telnoCheck(String telno) {
		return dao.telnoCheck(telno);
	};
	
	// 회원 정보
	@Override
	public MemberDTO memberInfo(String userid) {
		
		return dao.memberInfo(userid);
	}
	
	// authkey 등록(update)
	@Override
	public void authkeyUpdate(MemberDTO member) {
		dao.authkeyUpdate(member);
		
	}
	
	// authkey로 회원 정보 검색
	@Override
	public MemberDTO memberInfoByAuthkey(String authkey) {
		
		return dao.memberInfoByAuthkey(authkey);
	}
	
	// 회원 로그인, 로그아웃, 패스워드변경시간 등록(update)
	@Override
	public void lastdateUpdate(String userid, String status) {
		dao.lastdateUpdate(userid, status);
	};
	
	// 회원 로그 정보 등록
	@Override
	public void memberLogRegistry(String userid, String status) {
		dao.memberLogRegistry(userid, status);
	};
}
// controller에서 service호출 service -> dao -> mapper -> sql문 실행