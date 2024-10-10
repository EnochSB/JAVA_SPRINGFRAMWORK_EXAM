package com.board.dao;

import java.util.List;
import java.util.Map;

import com.board.dto.BoardDTO;
import com.board.dto.FileDTO;
import com.board.dto.LikeDTO;
import com.board.dto.ReplyDTO;

public interface BoardDAO {
	// 게시물 리스트
	public List<BoardDTO> list(int startPoint, int postNum, String keyword);
	
	// 게시물 전체 목록 보기
	public List<BoardDTO> listAll();
	
	// 검색 갯수
	public int getTotalCount(String keyword);
	
	// 게시물 상세 보기
	public BoardDTO view(int seqno);
	
	// 게시물 이전 보기
	public int pre_seqno(int seqno, String keyword);
	
	// 게시물 다음 보기
	public int next_seqno(int seqno, String keyword);
	
	// 게시물 조회수 증가
	public void hitno(int seqno);
	
	// 게시물 등록
	public void write(BoardDTO board);
	
	// 게시물 수정
	public void modify(BoardDTO board);
	
	// 게시물 삭제
	public void deleteBoard(int seqno);
	
	// max seqno 구하기
	public int getMaxSeqno(String userid);
	
	// 첨부 파일 정보 등록
	public void fileInfoRegistry(Map<String,Object> fileInfo);
	
	// 게시물 삭제 시 게시물에 포함된 첨부 파일 삭제 / 수정시 선택 파일 삭제
	public void deleteFileList(Map<String,Object> data);
	
	// 게시물 상세 페이지에서 첨부한 파일 목록 보기
	public List<FileDTO> fileListView(int seqno);

	// 파일 정보 가져오기
	public FileDTO fileInfo(int fileseqno);
	
	// 좋아요 싫어요 체크 여부 확인
	public LikeDTO likeCheckView(int seqno, String userid);
	
	// 좋아요 싫어요 최초 등록
	public void likeCheckRegistry(Map<String,Object> data);
	
	// 좋아요 싫어요 수정
	public void likeCheckUpdate(Map<String,Object> data);
	
	// 좋아요 싫어요 갯수 수정
	public void boardLikeUpdate(int seqno, int likecnt, int dislikecnt);
	
	// 댓글 보기
	public List<ReplyDTO> replyView(ReplyDTO reply);
	
	// 댓글 등록
	public void replyRegistry(ReplyDTO reply);
	
	// 댓글 수정
	public void replyUpdate(ReplyDTO reply);
	
	// 댓글 삭제
	public void replyDelete(ReplyDTO reply);
}
