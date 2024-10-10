package com.board.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.board.dao.BoardDAO;
import com.board.dto.BoardDTO;
import com.board.dto.FileDTO;
import com.board.dto.LikeDTO;
import com.board.dto.ReplyDTO;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDAO dao;
	
	// 리스트
	@Override
	public List<BoardDTO> list(int startPoint, int postNum, String keyword) {
		return dao.list(startPoint, postNum, keyword);
	}
	
	// 게시물 전체 목록 보기
	@Override
	public List<BoardDTO> listAll() {
		return dao.listAll();
	};
	
	// 검색 갯수
	@Override
	public int getTotalCount(String keyword) {
		return dao.getTotalCount(keyword);
	};
	
	// 게시물 상세 보기
	@Override
	public BoardDTO view(int seqno) {
		return dao.view(seqno);
	};
	
	// 게시물 이전 보기
	@Override
	public int pre_seqno(int seqno, String keyword) {
		return dao.pre_seqno(seqno, keyword);
	};
	
	// 게시물 다음 보기
	@Override
	public int next_seqno(int seqno, String keyword) {
		return dao.next_seqno(seqno, keyword);
	};
	
	// 게시물 조회수 증가
	@Override
	public void hitno(int seqno) {
		dao.hitno(seqno);
	};
	
	// 게시물 등록
	@Override
	public void write(BoardDTO board) {
		dao.write(board);
	};
	
	// 게시물 수정
	@Override
	public void modify(BoardDTO board) {
		dao.modify(board);
	};
	
	// 게시물 삭제
	@Override
	public void deleteBoard(int seqno) {
		dao.deleteBoard(seqno);
	};
	
	// max seqno 구하기
	@Override
	public int getMaxSeqno(String userid) {
		return dao.getMaxSeqno(userid);
	};
	
	// 첨부 파일 정보 등록
	@Override
	public void fileInfoRegistry(Map<String,Object> fileInfo) {
		dao.fileInfoRegistry(fileInfo);
	};
	
	// 게시물 삭제 시 게시물에 포함된 첨부 파일 삭제 / 수정시 선택 파일 삭제
	@Override
	public void deleteFileList(Map<String,Object> data) {
		dao.deleteFileList(data);
	};
	
	// 게시물 상세 페이지에서 첨부한 파일 목록 보기
	@Override
	public List<FileDTO> fileListView(int seqno){
		return dao.fileListView(seqno);
	};
	
	// 파일 정보 가져오기
	@Override
	public FileDTO fileInfo(int fileseqno) {
		return dao.fileInfo(fileseqno);
	};
	
	// 좋아요 싫어요 체크 여부 확인
	@Override
	public LikeDTO likeCheckView(int seqno, String userid) {
		return dao.likeCheckView(seqno, userid);
	};
	
	// 좋아요 싫어요 최초 등록
	@Override
	public void likeCheckRegistry(Map<String,Object> data) {
		dao.likeCheckRegistry(data);
	};
	
	// 좋아요 싫어요 수정
	@Override
	public void likeCheckUpdate(Map<String,Object> data) {
		dao.likeCheckUpdate(data);
	};
	
	// 좋아요 싫어요 갯수 수정
	@Override
	public void boardLikeUpdate(int seqno, int likecnt, int dislikecnt) {
		dao.boardLikeUpdate(seqno, likecnt, dislikecnt);
	};
	
	// 댓글 보기
	@Override
	public List<ReplyDTO> replyView(ReplyDTO reply) {
		return dao.replyView(reply);
	};
	
	// 댓글 등록
	@Override
	public void replyRegistry(ReplyDTO reply) {
		dao.replyRegistry(reply);
	};
	
	// 댓글 수정
	@Override
	public void replyUpdate(ReplyDTO reply) {
		dao.replyUpdate(reply);
	};
	
	// 댓글 삭제
	@Override
	public void replyDelete(ReplyDTO reply) {
		dao.replyDelete(reply);
	};
}
