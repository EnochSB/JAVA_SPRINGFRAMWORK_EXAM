package com.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.board.dto.BoardDTO;
import com.board.dto.FileDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
	@Autowired
	private SqlSession sql;
	private static String namespace = "com.board.mappers.Board";
	
	// 리스트
	@Override
	public List<BoardDTO> list(int startPoint, int postNum, String keyword) {
		Map<String,Object> data = new HashMap<>();
		data.put("startPoint", startPoint);
		data.put("postNum", postNum);
		data.put("keyword", keyword);
		
		return sql.selectList(namespace + ".list", data);
	}
	
	// 게시물 전체 목록 보기
	@Override
	public List<BoardDTO> listAll(){
		return sql.selectList(namespace + ".listAll");
	};
	
	// 검색 갯수
	@Override
	public int getTotalCount(String keyword) {
		return sql.selectOne(namespace + ".getTotalCount", keyword);
	};
	
	// 게시물 상세 보기
	@Override
	public BoardDTO view(int seqno) {
		return sql.selectOne(namespace + ".view", seqno);
	};
	
	// 게시물 이전 보기
	@Override
	public int pre_seqno(int seqno, String keyword) {
		Map<String,Object> data = new HashMap<>();
		data.put("seqno", seqno);
		data.put("keyword", keyword);
		return sql.selectOne(namespace + ".pre_seqno", data);
	};
	
	// 게시물 다음 보기
	@Override
	public int next_seqno(int seqno, String keyword) {
		Map<String,Object> data = new HashMap<>();
		data.put("seqno", seqno);
		data.put("keyword", keyword);
		return sql.selectOne(namespace + ".next_seqno", data);
	};
	
	// 게시물 조회수 증가
	@Override
	public void hitno(int seqno) {
		sql.update(namespace + ".hitno", seqno);
	};
	
	// 게시물 등록
	@Override
	public void write(BoardDTO board) {
		sql.insert(namespace + ".write", board);
	};
	
	// 게시물 수정
	@Override
	public void modify(BoardDTO board) {
		sql.update(namespace + ".modify", board);
	};
	
	// 게시물 삭제
	@Override
	public void deleteBoard(int seqno) {
		sql.delete(namespace + ".deleteBoard", seqno);
	};
	
	// max seqno 구하기
	@Override
	public int getMaxSeqno(String userid) {
		return sql.selectOne(namespace + ".getMaxSeqno", userid);
	};
	
	// 첨부 파일 정보 등록
	@Override
	public void fileInfoRegistry(Map<String,Object> fileInfo) {
		sql.insert(namespace + ".fileInfoRegistry", fileInfo);
	};
	
	// 게시물 삭제 시 게시물에 포함된 첨부 파일 삭제 / 수정시 선택 파일 삭제
	@Override
	public void deleteFileList(Map<String,Object> data) {
		sql.update(namespace + ".deleteFileList", data);
	};
	
	// 게시물 상세 페이지에서 첨부한 파일 목록 보기
	@Override
	public List<FileDTO> fileListView(int seqno) {
		return sql.selectList(namespace + ".fileListView", seqno);
	};
	
	// 파일 정보 가져오기
	@Override
	public FileDTO fileInfo(int fileseqno) {
		return sql.selectOne(namespace + ".fileInfo", fileseqno);
	};
}
